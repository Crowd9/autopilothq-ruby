module Autopilot
  class Resource
    class << self
      attr_accessor :record_key, :plural_key
      attr_writer :singleton_resource

      def singleton_resource?
        !!@singleton_resource
      end
    end

    undef :id if method_defined?(:id)
    attr_reader :attributes
    private :attributes

    def initialize(attributes = {})
      @id = if attributes.is_a?(Array)
              array[0].present? ? array[0][:id] : nil
            else
              attributes[:id]
            end
      define_id_reader if @id
      build_from_attributes(attributes)
    end

    # Attributes used for serialization
    def to_hash
      attributes.dup
    end
    alias_method :to_h, :to_hash

  private

    def build_from_attributes(attributes)
      if attributes.is_a?(Array)
        @attributes = build_array_attributes(attributes)
      else
        @attributes = Utils.hash_without_key(attributes, :id)
      end

      define_attribute_accessors(@attributes.keys)
    end

    def build_array_attributes(attributes)
      attributes.each_with_object({}).with_index do |(attribute, hash), index|
        hash["custom_field_#{index}".to_sym] = attribute
      end
    end

    def define_id_reader
      Utils.eigenclass(self).instance_eval do
        attr_reader :id
      end
    end

    def define_attribute_accessors(keys)
      Utils.eigenclass(self).instance_eval do
        keys.each do |key|
          define_method(key) do
            attributes[key]
          end

          define_method("#{key}=") do |value|
            attributes[key] = value
          end
        end
      end
    end
  end
end
