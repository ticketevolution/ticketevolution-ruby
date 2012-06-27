# Faraday request middleware that processes requests made to *.lvh.me or
# *.xip.io domains. When encountering one, it swaps out the hostname with the
# raw IP, but populates the 'Host' request HTTP header with the original hostname.
#
# This enables usage of lvh.me and xip.io domains even when their DNS service
# is down, because it completely circumvents any DNS lookup.
class FaradayLocalhostHeader < Struct.new(:app)
  HOST   = 'Host'.freeze
  HOME   = '127.0.0.1'
  LVH_ME = /(?:^|\.)lvh\.me/i
  XIP_IO = /(?:^|\.)((?:\d+\.){4})xip\.io/i

  def call env
    detect_domain_hack env[:url] do |hostname, ip|
      env[:url].host = ip
      env[:request_headers][HOST] = hostname
    end
    app.call env
  end

  def detect_domain_hack url
    case url.host
    when LVH_ME then yield url.host, HOME
    when XIP_IO then yield url.host, $1.chomp('.')
    end
  end
end
