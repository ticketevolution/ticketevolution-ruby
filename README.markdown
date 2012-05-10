Introduction [![Build Status](https://secure.travis-ci.org/ticketevolution/ticketevolution-ruby.png)](http://travis-ci.org/ticketevolution/ticketevolution-ruby)
============
The Ticket Evolution gem is a toolkit that provides a seamless and total wrapper around the Ticket Evolution APIs. Ticket Evolution uses the gem in-house to build consumer products.

The gem follows an instance based approach to the Restful API. This way multiple credentials can be used within the same environment, avoiding the static nature of ActiveResource. The classes allow you to access all endpoints of the API with a familiar ActiveRecord style -- convenient attribute methods, finders, etc.

All API documentation can be found at [http://developer.ticketevolution.com](http://developer.ticketevolution.com/).

_NOTE: Known issues and missing functionality are documented in the [Github Issues](https://github.com/ticketevolution/ticketevolution-ruby/issues)._

**Rubies supported**

- 1.9.2
- 1.8.7
- ree

Installation
============

Rails / Bundler
---------------
In your Gemfile, add the following line

    gem 'ticketevolution-ruby', :require => 'ticket_evolution'

Ruby / IRB
----------
In bash / terminal

    gem install ticketevolution-ruby
    irb

Then

    require 'rubygems'
    require 'ticket_evolution'
    @connection = TicketEvolution::Connection.new({
      :token => '<YOUR TOKEN>',
      :secret => '<YOUR SECRET>'
    })
    @connection.brokerages.list({:per_page => 1})

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

Interacting with an endpoint
============================

    @connection.brokerages.list           # => builds a TicketEvolution::Collection object containing
                                          #    a collection of TicketEvolution::Brokerage model objects

    @connection.brokerages.show(id)       # => builds a TicketEvolution::Brokerage model object

    @connection.brokerages.search(params) # => returns a TicketEvolution::Collection object containing
                                          #    a collection of TicketEvolution::Brokerage model objects

Alias methods
-------------
To more directly match ActiveRecord style, the following aliases exist and can be called on endpoints which include thier equivalent method:

**#find aliases #show**

    @connection.brokerages.find(1)
    # is the same as calling
    @connection.brokerages.show(1)

**#update_attributes indirectly aliases #update** - A call to #update_attributes will update the attributes on the instance as well as calling #update on the endpoint.

    @brokerage = @connection.brokerages.find(1)
    @brokerage.update_attributes(params)
    # is an easy way to call
    TicketEvolution::Brokerages.new({:connection => @connection, :id => 1}).update(params)

**#save indirectly aliases #update**

    @brokerage = @connection.brokerages.find(1)
    @brokerage.attributes = params
    @brokerage.save
    # is an easy way to call
    TicketEvolution::Brokerages.new({:connection => @connection, :id => 1}).update(params)

**#all aliases #list** - If you use this, be aware that #list maxes out at 100 results, so #all defaultly has the following defined parameter - :limit => 100

    @connection.brokerages.all
    # is the same as calling
    @connection.brokerages.list

Available endpoints
-------------------
Click on the links next to each endpoint for more detail.

**Accounts** - [http://developer.ticketevolution.com/endpoints/accounts](http://developer.ticketevolution.com/endpoints/accounts)

    @account = @connection.accounts.list(params)
    @account = @connection.accounts.show(id)

**Addresses** - [http://developer.ticketevolution.com/endpoints/addresses](http://developer.ticketevolution.com/endpoints/addresses)

    @address = @client.addresses.create(params)
    @address = @client.addresses.list(params)
    @address = @client.addresses.show(id)
    @address = @address.update_attributes(params)

**Brokerages** - [http://developer.ticketevolution.com/endpoints/brokerages](http://developer.ticketevolution.com/endpoints/brokerages)

    @brokerage = @connection.brokerages.list(params)
    @brokerage = @connection.brokerages.search(params)
    @brokerage = @connection.brokerages.show(id)

**Categories** - [http://developer.ticketevolution.com/endpoints/categories](http://developer.ticketevolution.com/endpoints/categories)

    @category = @connection.categories.deleted(params)
    @category = @connection.categories.list(params)
    @category = @connection.categories.show(id)

**Clients** - [http://developer.ticketevolution.com/endpoints/clients](http://developer.ticketevolution.com/endpoints/clients)

    @client = @connection.clients.create(params)
    @client = @connection.clients.list(params)
    @client = @connection.clients.show(id)
    @client = @client.update_attributes(params)

**Companies** - [http://developer.ticketevolution.com/endpoints/companies](http://developer.ticketevolution.com/endpoints/companies)

    @company = @connection.companies.create(params)
    @company = @connection.companies.list(params)
    @company = @connection.companies.show(id)
    @company = @company.update_attributes(params)

**Configurations** - [http://developer.ticketevolution.com/endpoints/configurations](http://developer.ticketevolution.com/endpoints/configurations)

    @configuration = @connection.configurations.list(params)
    @configuration = @connection.configurations.show(id)

**Credit Cards** - [http://developer.ticketevolution.com/endpoints/credit-cards](http://developer.ticketevolution.com/endpoints/credit-cards)

    @credit_card = @client.credit_cards.create(params)
    @credit_card = @client.credit_cards.list(params)

**Email Addresses** - [http://developer.ticketevolution.com/endpoints/email-addresses](http://developer.ticketevolution.com/endpoints/email-addresses)

    @email_address = @client.email_addresses.create(params)
    @email_address = @client.email_addresses.list(params)
    @email_address = @client.email_addresses.show(id)
    @email_address = @email_address.update_attributes(params)

**Events** - [http://developer.ticketevolution.com/endpoints/events](http://developer.ticketevolution.com/endpoints/events)

    @event = @connection.events.deleted(params)
    @event = @connection.events.list(params)
    @event = @connection.events.show(id)

**Offices** - [http://developer.ticketevolution.com/endpoints/offices](http://developer.ticketevolution.com/endpoints/offices)

    @office = @connection.offices.list(params)
    @office = @connection.offices.search(params)
    @office = @connection.offices.show(id)

**Orders** - [http://developer.ticketevolution.com/endpoints/orders](http://developer.ticketevolution.com/endpoints/orders)

    @order = @order.accept(params)
    @order = @order.complete
    @order = @connection.orders.create_brokerage_order(params)
    @order = @connection.orders.create_client_order(params)
    @order = @connection.orders.create_fulfillment_order(params)
    @order = @connection.orders.list(params)
    @order = @order.reject(params)
    @order = @connection.orders.show(id)
    @order = @order.update_attributes(params)

**Performers** - [http://developer.ticketevolution.com/endpoints/performers](http://developer.ticketevolution.com/endpoints/performers)

    @performer = @connection.performers.deleted(params)
    @performer = @connection.performers.list(params)
    @performer = @connection.performers.search(params)
    @performer = @connection.performers.show(id)

**Phone Numbers** - [http://developer.ticketevolution.com/endpoints/phone-numbers](http://developer.ticketevolution.com/endpoints/phone-numbers)

    @phone_number = @client.phone_numbers.create(params)
    @phone_number = @client.phone_numbers.list(params)
    @phone_number = @client.phone_numbers.show(id)
    @phone_number = @phone_number.update_attributes(params)

**Quotes** - [http://developer.ticketevolution.com/endpoints/quotes](http://developer.ticketevolution.com/endpoints/quotes)

    @quote = @connection.quotes.list(params)
    @quote = @connection.quotes.search(params)
    @quote = @connection.quotes.show(id)

**Search** - [http://developer.ticketevolution.com/endpoints/search](http://developer.ticketevolution.com/endpoints/search)

    @search = @connection.search.list(params)

**Shipments** - [http://developer.ticketevolution.com/endpoints/shipments](http://developer.ticketevolution.com/endpoints/shipments)

    @shipment = @connection.shipments.create(params)
    @shipment = @connection.shipments.create_airbill(params)
    @shipment = @connection.shipments.list(params)
    @shipment = @connection.shipments.show(id)
    @shipment = @shipment.update_attributes(params)

**Ticket Groups** - [http://developer.ticketevolution.com/endpoints/ticket-groups](http://developer.ticketevolution.com/endpoints/ticket-groups)

    @ticket_group = @connection.ticket_groups.list(params)
    @ticket_group = @connection.ticket_groups.show(id)

**Transactions** - [http://developer.ticketevolution.com/endpoints/transactions](http://developer.ticketevolution.com/endpoints/transactions)

    @transaction = @account.transactions.list(params)
    @transaction = @account.transactions.show(id)

**Users** - [http://developer.ticketevolution.com/endpoints/users](http://developer.ticketevolution.com/endpoints/users)

    @user = @connection.users.list(params)
    @user = @connection.users.search(params)
    @user = @connection.users.show(id)

**Venues** - [http://developer.ticketevolution.com/endpoints/venues](http://developer.ticketevolution.com/endpoints/venues)

    @venue = @connection.venues.deleted(params)
    @venue = @connection.venues.list(params)
    @venue = @connection.venues.search(params)
    @venue = @connection.venues.show(id)


######ticketevolution-ruby v0.7.7

License
-------

See LICENSE file for licensing information.
