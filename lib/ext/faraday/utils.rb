# module Faraday
#   module Utils
#     # Override Faraday's version so it sorts the params
#     alias :faradays_build_nested_query :build_nested_query
#     def build_nested_query(value, prefix = nil)
#       if value.is_a? Hash
#         value.to_ordered_hash.map { |k, v|
#           build_nested_query(v, prefix ? "#{prefix}%5B#{escape(k)}%5D" : escape(k))
#         }.join("&")
#       else
#         faradays_build_nested_query(value, prefix)
#       end
#     end
#
#     class ParamsHash
#       def to_query
#         Utils.build_nested_query(self)
#       end
#     end
#   end
# end
