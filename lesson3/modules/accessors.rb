module Accessors
  def attr_accessor_with_history(*names)
    names.each do |name|
      var_name = "@#{name}".to_sym

      define_method(name) { instance_variable_get(var_name) }

      define_method("#{name}=") do |value|
        instance_variable_set(var_name, value)
        instance_variable_set("@#{name}_history", []) unless instance_variable_get("@#{name}_history")
        instance_variable_get("@#{name}_history") << value
      end

      define_method("#{name}_history") { instance_variable_get("@#{name}_history") }
    end
  end

  def strong_attr_accessor(name, attr_class)
    var_name = "@#{name}".to_sym
    define_method(name) { instance_variable_get(var_name) }
    define_method("#{name}=") do |value|
      raise 'Класс атрибута неверный!' unless value.is_a?(attr_class)

      instance_variable_set(var_name, value)
    end
  end
end

# class Example
#   extend Accessors

#   attr_accessor_with_history :foo
#   attr_accessor_with_history :bar

#   strong_attr_accessor :int, Integer
#   strong_attr_accessor :str, String
# end

# a = Example.new; a.foo = 2; a.foo = "test";
# p a.foo_history # => [nil, 2, "test"]

# a = Example.new
# p a.foo_history # => [nil]

# a.int = 86
# a.str = 'str'

# # a.int = 'str'
# # a.str = 86
