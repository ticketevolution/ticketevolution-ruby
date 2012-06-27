# Faraday request middleware that processes requests made to domains such as
# *.lvh.me or *.xip.io. When encountering one, it swaps out the hostname with
# the raw IP, but populates the 'Host' request HTTP header with the original
# hostname.
#
# This enables usage of lvh.me and xip.io domains even when their DNS service
# is down, because it completely circumvents any DNS lookup.
class FaradayLocalhostHeader
  attr_reader :app, :patterns

  HOST = 'Host'.freeze
  HOME = '127.0.0.1'

  def initialize app, patterns
    @app = app
    @patterns = Array(patterns)
  end

  def call env
    detect_domain_hack env[:url] do |hostname, ip|
      env[:url].host = ip
      env[:request_headers][HOST] = hostname
    end
    app.call env
  end

  def detect_domain_hack url
    patterns.each do |re|
      if url.host =~ re
        ip = $1 ? $1.chomp('.') : HOME
        yield url.host, ip
        return
      end
    end
  end
end
