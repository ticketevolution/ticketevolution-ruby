require 'rubygems'
require 'yajl'
require 'multi_json'
require 'faraday'

require 'ostruct'
require 'base64'
require 'digest/md5'
require 'openssl'
require 'pathname'
require 'cgi'

require 'active_support/hash_with_indifferent_access'
require 'active_support/version'
require 'active_support/core_ext/class'
require 'active_support/core_ext/hash'
require 'active_support/core_ext/module'
require 'active_support/core_ext/object'
require 'active_support/inflector'
require 'active_support/ordered_hash'

require 'ext/hash'
require 'ext/faraday/utils'

require 'faraday/response/verbose_logger'

module TicketEvolution
  mattr_reader :root

  @@root = Pathname.new(File.dirname(File.expand_path(__FILE__))) + 'ticket_evolution'
end

c = Module.new { def self.req(*parts); require TicketEvolution.root + 'core' + File.join(parts); end }
i = Module.new { def self.req(*parts); require TicketEvolution.root + File.join(parts); end }
m = Module.new { def self.req(*parts); require TicketEvolution.root + 'modules' + File.join(parts); end }

i.req 'version' unless defined?(TicketEvolution::VERSION)

# Core modules
c.req 'singular_class'

# Core classes
c.req 'base'
c.req 'builder'
c.req 'collection'
c.req 'connection'
c.req 'datum'
c.req 'endpoint', 'request_handler'
c.req 'endpoint'
c.req 'model'
c.req 'model/parental_behavior'
c.req 'time'

# Errors
c.req 'api_error'
i.req 'errors', 'connection_not_found'
i.req 'errors', 'endpoint_configuration_error'
i.req 'errors', 'invalid_configuration'
i.req 'errors', 'method_unavailable_error'

# Endpoint modules
m.req 'create'
m.req 'deleted'
m.req 'destroy'
m.req 'list'
m.req 'search'
m.req 'show'
m.req 'update'

# Builder Classes
i.req 'account'
i.req 'address'
i.req 'brokerage'
i.req 'category'
i.req 'company'
i.req 'client'
i.req 'configuration'
i.req 'credit_card'
i.req 'email_address'
i.req 'event'
i.req 'office'
i.req 'order'
i.req 'payment'
i.req 'performer'
i.req 'phone_number'
i.req 'quote'
i.req 'rate_option'
i.req 'shipment'
i.req 'shipping_setting'
i.req 'ticket_group'
i.req 'track_detail'
i.req 'transaction'
i.req 'user'
i.req 'venue'

# Endpoint Classes
i.req 'accounts'
i.req 'brokerages'
i.req 'categories'
i.req 'companies'
i.req 'clients'
i.req 'configurations'
i.req 'events'
i.req 'offices'
i.req 'orders'
i.req 'performers'
i.req 'quotes'
i.req 'rate_options'
i.req 'settings'
i.req 'shipments'
i.req 'ticket_groups'
i.req 'track_details'
i.req 'transactions'
i.req 'users'
i.req 'venues'
i.req 'search'

i.req 'clients', 'addresses'
i.req 'clients', 'credit_cards'
i.req 'clients', 'email_addresses'
i.req 'clients', 'phone_numbers'

i.req 'offices', 'credit_cards'

i.req 'orders', 'payments'
