module TicketEvolution
  class TestResponse
    def self.connection_in_test_mode(object)
      connection = self.get_connection(object)
      connection ? connection.config["test_responses"] : false
    end

    def self.get_connection(object)
      return object if object.class.is_a? TicketEvolution::Connection
      return false  if !object.respond_to?(:parent)
      return self.get_connection(object.parent)
    end

    def initialize(path, request, base)
      @path = request.sub base, ''
      @path = "#{@path}.json"
    end

    def test_response_path
      "#{TicketEvolution.root}/test_responses" 
    end

    def test_responses
      Dir.glob("#{test_response_path}/**/*").map { |path|
        path.sub test_response_path, ''
      }
    end

    def status
      200
    end

    def body
      if test_responses.include?(@path)
        File.open("#{test_response_path}/#{@path}").read
      else
        {}
      end
    end

    def headers
      {'location' => '127.0.0.1'}
    end
  end
end
