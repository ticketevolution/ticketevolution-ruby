class Fake
  def self.token
    Digest::MD5.hexdigest("fake_token")
  end

  def self.secret
    Base64.encode64(OpenSSL::Random.random_bytes(30)).chomp
  end

  def self.connection
    TicketEvolution::Connection.new({:token => Fake.token, :secret => Fake.secret})
  end

  def self.response_handler(response)
    "called fake handler"
  end

  def self.response_alt
    proc {|response| "A response was handled"}
  end

  def self.response
    OpenStruct.new.tap do |resp|
      resp.header = 'fake header string (we don\'t currently process this)'
      resp.response_code = 200
      resp.body = {:body => "test", :connection => self.connection}
      resp.server_message = TicketEvolution::Endpoint::RequestHandler::CODES[200].last
    end
  end

  def self.redirect_response
    r = self.response
    r.header = {'location' => 'http://api.ticketevolution.com/something_else/1'}
    r.response_code = 302
    r.server_message = TicketEvolution::Endpoint::RequestHandler::CODES[302].last
    r
  end

  def self.show_response
    r = self.response
    r.body = {
      :connection => Fake.connection,
      "url" => "/brokerages/2",
      "updated_at" => "2011-12-18T17:30:06Z",
      "natb_member" => true,
      "name" => "Golden Tickets",
      "id" => "2",
      "abbreviation" => "Golden Tickets"
    }
    r
  end

  def self.list_response
    r = self.response
    r.body = {
      :connection => Fake.connection,
      "current_page" => 1,
      "per_page" => 2,
      "brokerages" => [
        {
          "url" => "/brokerages/1",
          "updated_at" => "2011-12-18T19:06:19Z",
          "natb_member" => true,
          "name" => "National Event Company",
          "id" => "1",
          "abbreviation" => "NECO"
        },
        {
          "url" => "/brokerages/2",
          "updated_at" => "2011-12-18T17:30:06Z",
          "natb_member" => true,
          "name" => "Golden Tickets",
          "id" => "2",
          "abbreviation" => "Golden Tickets"
        }
      ],
      "total_entries" => 1379
    }
    r
  end

  def self.list_response_with_unique_categories
    r = self.response
    r.body = {
      :connection => Fake.connection,
      "current_page" => 1,
      "per_page" => 2,
      "brokerages" => [
        {
          "url" => "/brokerages/1",
          "updated_at" => "2011-12-18T19:06:19Z",
          "natb_member" => true,
          "name" => "National Event Company",
          "id" => "1",
          "abbreviation" => "NECO"
        },
        {
          "url" => "/brokerages/2",
          "updated_at" => "2011-12-18T17:30:06Z",
          "natb_member" => true,
          "name" => "Golden Tickets",
          "id" => "2",
          "abbreviation" => "Golden Tickets"
        }
      ],
      "total_entries" => 1379,
      "unique_categories" => [1,2,3,4,5]
    }
    r
  end

  def self.create_response(endpoint = nil, connection = Fake.connection, number = 1)
    r = self.response
    r.body = {
      :connection => connection,
      endpoint.to_s => number.times.collect do
        {
          "url" => "/clients/2097",
          "email_addresses" => [],
          "updated_at"=>"2012-01-06T02:34:47Z",
          "phone_numbers"=>[],
          "addresses"=>[],
          "name"=>"Morris Moe Szyslak",
          "id"=>"2097"
        }
      end
    }
    r
  end

  def self.error_response
    OpenStruct.new.tap do |resp|
      resp.header = ''
      resp.response_code = 500
      resp.body = {
        :connection => Fake.connection,
        'error' => 'Internal Server Error',
        'extra_parameter' => 'something important'
      }
      resp.server_message = TicketEvolution::Endpoint::RequestHandler::CODES[500].last
    end
  end
end
