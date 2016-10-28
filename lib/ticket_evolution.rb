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
require 'active_support/deprecation'
require 'active_support/version'
require 'active_support/json'
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
c.req 'test_response'
c.req 'time'

# Errors
c.req 'api_error'
i.req 'errors', 'connection_not_found'
i.req 'errors', 'endpoint_configuration_error'
i.req 'errors', 'invalid_configuration'
i.req 'errors', 'method_unavailable_error'

# Endpoint modules
m.req 'create'
m.req 'create_in_background'
m.req 'deleted'
m.req 'destroy'
m.req 'list'
m.req 'retrieve_queued_order'
m.req 'retrieve_queued_order_params'
m.req 'search'
m.req 'show'
m.req 'update'

# Builder Classes
i.req 'account'
i.req 'affiliate'
i.req 'address'
i.req 'brokerage'
i.req 'category'
i.req 'city'
i.req 'company'
i.req 'client'
i.req 'commission'
i.req 'configuration'
i.req 'credit_card'
i.req 'credit_memo'
i.req 'custom_page'
i.req 'ticket_hold'
i.req 'email_address'
i.req 'credential'
i.req 'event'
i.req 'office'
i.req 'order'
i.req 'payment'
i.req 'performer'
i.req 'phone_number'
i.req 'promotion_code'
i.req 'queued_order'
i.req 'quote'
i.req 'rate_option'
i.req 'service_fee'
i.req 'shipment'
i.req 'shipping_setting'
i.req 'filtered_ticket'
i.req 'ticket_group'
i.req 'track_detail'
i.req 'transaction'
i.req 'user'
i.req 'venue'

# Endpoint Classes
i.req 'accounts'
i.req 'affiliates'
i.req 'address_check'
i.req 'brokerages'
i.req 'categories'
i.req 'cities'
i.req 'companies'
i.req 'clients'
i.req 'commissions'
i.req 'commission_payment'
i.req 'configurations'
i.req 'credit_memos'
i.req 'credit_memo_payment'
i.req 'credentials'
i.req 'custom_pages'
i.req 'events'
i.req 'item'
i.req 'offices'
i.req 'orders'
i.req 'payments'
i.req 'performers'
i.req 'promotion_codes'
i.req 'queued_orders'
i.req 'quotes'
i.req 'rate_options'
i.req 'settings'
i.req 'shipments'
i.req 'filtered_tickets'
i.req 'ticket_groups'
i.req 'track_details'
i.req 'transactions'
i.req 'users'
i.req 'venues'
i.req 'search'
i.req 'searches'
i.req 'reports'

i.req 'clients', 'addresses'
i.req 'clients', 'credit_cards'
i.req 'clients', 'email_addresses'
i.req 'clients', 'phone_numbers'

i.req 'accounts', 'transactions'

i.req 'credit_memos', 'credit_memo_payments'
i.req 'commissions', 'commission_payments'
i.req 'orders', 'items'

i.req 'offices', 'credit_cards'

i.req 'ticket_groups', 'ticket_holds'
