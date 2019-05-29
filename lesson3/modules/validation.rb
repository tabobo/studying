module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_reader :validators

    def validate(attr_name, type, *attributes)
      @validators ||= {}
      @validators[attr_name] ||= []
      @validators[attr_name] << { type: type, attributes: attributes }
    end
  end

  module InstanceMethods
    def validate!
      self.class.validators.each do |attr_name, validations|
        attr_value = instance_variable_get("@#{attr_name}")
        validations.each do |validation|
          send(validation[:type], attr_value, *validation[:attributes])
        end
      end

    end

    def valid?
      validate!
      true
    rescue
      false
    end

    private

    def presence(value)
      raise "Значение атрибута #{value} не может быть nil" if value.nil? 
      raise "Значение атрибута #{value} не может быть пустой строкой" if value.strip.empty?
    end

    def format(value, format)
      raise "Значение атрибута #{value} не соответствует формату #{format}" if value !~ format
    end

    def type(value, type)
      raise "Значение атрибута #{value} не соответствует классу #{type}" unless value.is_a?(type)
    end
  end
end

# class ValidationTest
#   include Validation

#   attr_accessor :name, :number, :myclass, :several

#   validate :name, :presence
#   #validate :number, :format, /A-Z{0,3}/
#   #validate :myclass, :type, String

# end

# v = ValidationTest.new
# v.name = '  '
# v.number = 55555
# v.myclass = 87

# puts 'valid?'
# puts v.valid?

# puts '----'

# puts 'validate!'
# puts v.validate!