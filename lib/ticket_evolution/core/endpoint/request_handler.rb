class TestResponse
  def response_code
    200
  end
  def server_message
    response_code
  end
  def body
    {}
  end
  def header
    {'location' => '127.0.0.1'}
  end
end
module TicketEvolution
  class Endpoint < Base
    module RequestHandler

      # Response Code Mappings From TicketEvolution API
      CODES = {
        200 => ["OK","Generally returned by successful GET requests. "],
        201 => ["Created","Generally returned by successful POST requests. "],
        202 => ["Accepted","Generally returned when a request has succeeded, but has been scheduled processing at a later time. "],
        301 => ["Moved Permanently","Used when a resource's URL has changed."],
        302 => ["Found","Returned when there's a redirect that should be followed."],
        400 => ["Bad Request","Generally returned on POST and PUT requests when validation fails for the given input. "],
        401 => ["Unauthorized","Returned when the authentication credentials are invalid."],
        404 => ["Not Found","The requested resource could not be located."],
        406 => ["Not Acceptable","The requested content type or version is invalid."],
        422 => ["Unprocessable Entity","Returned when the application can't processes the data."],
        500 => ["Internal Server Error","Used a general error response for processing errors or other issues with the web service. "],
        503 => ["Service Unavailable","Returned when the API service is temporarily unavailable. This could also indicate that the rate limit for the given token has been reached. If this status is received, the request should be retried."]
      }

      def request(method, path, params = nil, &response_handler)
        params = params.to_ordered_hash if params.is_a?(Hash)
        redirecting = caller.first =~ /request_handler/ ? false : true
        request = self.build_request(method, path, params, redirecting)

        if Rails.env == 'test'
          response = TestResponse.new
        else
          response = self.naturalize_response do
            method = method.to_s.downcase.to_sym
            if method == :get
              request.send(method)
            else
              request.send(method) do |req|
                req.body = MultiJson.encode(params) if params.present?
              end
            end
          end
        end
        if [301, 302].include?(response.response_code)
          new_path = response.header['location'].match(/^https?:\/\/[a-zA-Z_]+[\.a-zA-Z_]+(\/[\w\/]+)[\?]*/).to_a[1]
          self.request(method, new_path, params, &response_handler)
        elsif response.response_code >= 300
          TicketEvolution::ApiError.new(response)
        else
          response_handler.call(response)
        end
      end

      def build_request(method, path, params = nil, build_path = true)
        raise EndpointConfigurationError, "#{self.class.to_s}#request requires it's first parameter to be a valid HTTP method" unless [:GET, :POST, :PUT, :DELETE].include? method.to_sym
        self.connection.build_request(method, "#{build_path ? self.base_path : ''}#{path}", params)
      end

      def naturalize_response(response = nil)
        response = yield if block_given?
        OpenStruct.new.tap do |resp|
          resp.header = response.headers
          resp.response_code = response.status
          resp.body = (MultiJson.decode(response.body) rescue {"error" => "Internal Server Error"}).merge({:connection => self.connection})
          resp.server_message = (CODES[resp.response_code] || ['Unknown Error']).last
        end
      end

      def collection_handler(response)
        TicketEvolution::Collection.build_from_response(response, self.class.name.demodulize.underscore, singular_class)
      end

      def upload_history_handler(response)
        TicketEvolution::Collection.build_from_response(response, 'upload_history', singular_class)
      end

      def raw_handler(response)
        response
      end
    end
  end
end
