class Hash
  def to_ordered_hash
    ActiveSupport::OrderedHash.new.tap do |hash|
      self.sort_by{|k,v| k.to_s}.each do |k, v|
        hash[k] = v

        v.sort_by! { |e| e.to_s } if v.is_a? Array
      end
    end
  end
end
