module LazyHighCharts
  module OptionsKeyFilter
    def self.milliseconds value
      value * 1000
    end

    def self.date_to_js_code date
      "Date.UTC(#{date.year}, #{date.month - 1}, #{date.day}, #{date.hour}, #{date.min}, #{date.sec})".js_code
    end

    def self.filter options
      new_options = options.map do |k, v|
        if v.is_a? ::Hash
          v = filter v
        else
          FILTER_MAP.each_pair do |method, matchers|
            v = method.call(v) if matchers.include?(k)
            if v.is_a?(Array) && v[0][0].is_a?(ActiveSupport::TimeWithZone) then
              0.upto(v.size - 1) do |idx|
                v[idx] = [ self.date_to_js_code(v[idx][0]), v[idx][1] ]
              end
            end
          end
        end
        [k, v]
      end
      Hash[new_options]
    end
  end
end