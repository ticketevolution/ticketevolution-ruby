Objects
=======
There are four main object types:

**Connection objects**

Each set of API credentials can be combined with a mode and api version to create a unique connection to Ticket Evolution. A connection object is the basis of any call and must be created before anything else can be done. _Your API credentials can be found [https://settings.ticketevolution.com/brokerage/credentials](https://settings.ticketevolution.com/brokerage/credentials). You must have an active brokerage account with Ticket Evolution._

    # Example connection configuration (defaults shown)
    @connection = TicketEvolution::Connection.new({
      :token => '',       # => (required) The API token, used to identify you
      :secret => '',      # => (required) The API secret, used to sign requests
                          #               More info: [http://developer.ticketevolution.com/signature_tool](http://developer.ticketevolution.com/signature_tool))
      :mode => :sandbox,  # => (optional) Specifies the server environment to use
                                          Valid options: :production or :sandbox
      :version => 8,      # => (optional) API version to use - the only available
                                          version at the time of this writing is 8
      :logger => nil      # => (optional) Object to use for logging requests and
                          #               responses. Any 'Logger' instance object
                          #               is valid. EX: Logger.new('log/te_api.log')
    })

Behind the scenes we use [Faraday](https://github.com/technoweenie/faraday) with the [:net_http](https://github.com/technoweenie/faraday/blob/master/lib/faraday/adapter/net_http.rb) adapter to process connections. You can change this [adapter](https://github.com/technoweenie/faraday/tree/master/lib/faraday/adapter) by setting it on the connection class _before_ you instantiate your connection object.

    TicketEvolution::Connection.adapter = :typhoeus

**Endpoint objects**

These are always (except in the case of Search) pluralized class names and match the endpoints listed at [http://developer.ticketevolution.com](http://developer.ticketevolution.com/). To instantiate an endpoint instance, create a connection object and then call the endpoints name, underscored, as a method on the connection object.

    @connection.brokerages

Some endpoints are scoped to model objects from other endpoints. One example of this is the Addresses endpoint, which is based off of an instance of TicketEvolution::Client. These endpoints can be called directly off of the model instance.

    @client = @connection.clients.show(1)
    @address = @client.addresses.show(1)

**Model objects**

Calling a create, show or update method will result in the creation of a model object. The type of model object generated matches the endpoint called.

    @connection.brokerages.show(1)    # => an instance of TicketEvolution::Brokerage with an id of 1

**Collection objects**

Calls to list and search methods will return TicketEvolution::Collection objects. These are Enumerable objects containing an array of entries. Each object in this array is an type of model object. In addition to the #entries method, #total_entries, #per_page and #current_page can all be called on collections.

