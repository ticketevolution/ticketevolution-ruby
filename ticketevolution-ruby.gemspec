# -*- encoding: utf-8 -*-
require File.join(File.dirname(File.expand_path(__FILE__)), 'lib', 'ticket_evolution', 'version')

Gem::Specification.new do |s|
  s.name        = 'ticketevolution-ruby'
  s.version     = TicketEvolution::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Ticket Evolution']
  s.email       = ['dev@ticketevolution.com']
  s.homepage    = 'https://github.com/ticketevolution/ticketevolution-ruby'
  s.summary     = 'Integration gem for Ticket Evolution\'s API'
  s.description = 'Provides Ruby wrappers for the Ticket Evolution API (http://developer.ticketevolution.com). Ticket Evolution is the industry leader in software for the Ticket Broker industry.'

  s.required_rubygems_version = '>= 1.3.5'

  s.add_dependency 'activesupport', '5.0.0.1'
  s.add_dependency 'faraday', '= 0.9.2'
  s.add_dependency 'yajl-ruby', '>= 0.7.7'
  s.add_dependency 'multi_json', '>= 0.0.4'
  s.add_dependency 'nokogiri', '1.6.7.2'

  s.add_development_dependency 'rspec', '3.5.0'
  s.add_development_dependency 'vcr', '3.0.3'
  s.add_development_dependency 'webmock', '2.1.0'
  s.add_development_dependency 'awesome_print', '1.7.0'
  s.add_development_dependency 'rake', '11.3.0'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
