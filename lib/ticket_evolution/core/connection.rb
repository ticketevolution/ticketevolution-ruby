require 'faraday/localhost_header'

module TicketEvolution
  class Connection < Base
    DEFAULT_SUBDOMAIN = 'api'
    DEFAULT_URL_BASE  = 'ticketevolution.com'
    DEFAULT_PROTOCOL  = 'https'

    cattr_reader :default_options, :expected_options, :oldest_version_in_service
    cattr_accessor :protocol, :subdomain, :url_base, :adapter

    @@oldest_version_in_service = 8

    @@default_options = HashWithIndifferentAccess.new({
      :version => @@oldest_version_in_service,
      :mode => :sandbox,
      :ssl_verify => true,
      :test_responses => false,
      :logger => nil
    })

    @@expected_options = [
      'version',
      'mode',
      'token',
      'secret',
      'ssl_verify',
      'test_responses',
      'logger'
    ]

    @@subdomain = DEFAULT_SUBDOMAIN
    @@url_base  = DEFAULT_URL_BASE
    @@protocol  = DEFAULT_PROTOCOL

    @@adapter = :net_http

    def initialize(opts = {})
      @adapter = self.class.adapter
      @config = self.class.default_options.merge(opts)
      @config.delete_if{|k, v| ! TicketEvolution::Connection.expected_options.include?(k)}

      # Error Notification
      if @config.keys.sort_by{|x|x} == TicketEvolution::Connection.expected_options.sort_by{|x|x}
        raise InvalidConfiguration.new("Invalid Token Format") unless @config[:token] =~ /^[a-zA-Z0-9]{32}$/
        raise InvalidConfiguration.new("Invalid Secret Format") unless @config[:secret] =~ /^\S{40}$/
        raise InvalidConfiguration.new("Please Use API Version #{TicketEvolution::Connection.oldest_version_in_service} or Above") unless @config[:version] >= TicketEvolution::Connection.oldest_version_in_service
      else
        raise InvalidConfiguration.new("Missing: #{(self.class.expected_options - @config.keys).join(', ')}")
      end
    end

    def config
      @config
    end

    def url
      @url ||= [].tap do |parts|
        parts << TicketEvolution::Connection.protocol
        parts << "://#{ TicketEvolution::Connection.subdomain }."
        parts << "#{@config[:mode]}." if @config[:mode].present? && @config[:mode].to_sym != :production
        parts << TicketEvolution::Connection.url_base
      end.join
    end

    def uri(path)
      parts = [].tap do |parts|
        parts << self.url
        parts << "/v#{@config[:version]}" if @config[:version] > 8
        parts << path
      end.join
    end

    def sign(method, path, content = nil)
      d = "#{method} #{process_params(method, path, content).gsub(TicketEvolution::Connection.protocol+'://', '').gsub(/\:\d{2,5}\//, '/')}"
      Base64.encode64(
        OpenSSL::HMAC.digest(
          OpenSSL::Digest.new('sha256'),
          @config[:secret],
          d
      )).chomp
    end

    def build_request(method, path, params = nil)
      options = {
        :headers => {
          "Accept" => accept_header,
          "X-Signature" => sign(method, self.uri(path), params),
          "X-Token" => @config[:token]
        },
        :ssl => {
          :verify => @config[:ssl_verify]
        }
      }
      options[:headers]['Content-Type'] = "application/json" unless method == :GET
      options[:params] = params if method == :GET
      Faraday.new(self.uri(path), options) do |builder|
        builder.use Faraday::Response::VerboseLogger, self.logger if self.logger.present?
        builder.use FaradayLocalhostHeader, [ /(?:^|\.)lvh\.me$/i, /(?:^|\.)((?:\d+\.){4})xip\.io$/i ]
        builder.adapter @adapter
        builder.options[:timeout] = 120
        builder.options[:open_timeout] = 120
      end
    end

    def logger
      @config[:logger]
    end

    private

    # Return the Accpet header value fot the given version of the API.
    # Starting at v9 `application/json` is expected (error if not present).
    #
    # @return [String] the Accept header value.
    def accept_header
      return "application/vnd.ticketevolution.api+json; version=#{@config[:version]}" if @config[:version] < 9

      "application/json"
    end

    def post_body(params)
      MultiJson.encode(params)
    end

    def process_params(method, uri, params)
      "#{uri}?#{if params.present?
        case method
        when :GET
          Faraday::Utils.build_nested_query(params)
        else
          post_body(params)
        end
      end}"
    end
  end
end
