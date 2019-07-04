module FullTextSearch
  # TODO: Use ActiveModel::TypeValue when we drop Redmine 3.4 support
  class MroongaIntegerArrayType < ActiveRecord::Type::Value
    def initialize(vector_load_is_supported, *args, &block)
      @vector_load_is_supported = vector_load_is_supported
      super(*args, &block)
    end

    def type
      :mroonga_integer_array
    end

    # TODO: Remove this when we drop Redmine 3.4 support
    def type_cast(value)
      deserialize(value)
    end

    def deserialize(value)
      return nil if value.nil?
      return [] if value.empty?
      case value
      when Array
        value
      else
        if @vector_load_is_supported and
           string.start_with?("[") and
           string.end_with?("]")
          return JSON.parse(string)
        end
        string.unpack("l*")
      end
    end

    def serialize(value)
      return nil if value.nil?
      if @vector_load_is_supported
        value.to_json
      else
        ""
      end
    end
  end
end
