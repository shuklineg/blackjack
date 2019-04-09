# Validation module
module Validation
  def self.included(base)
    base.extend(ClassMethods)
    base.include(InstanceMethods)
  end

  # Validation class methods
  module ClassMethods
    def validate(name, type)
      raise TypeError if !name.is_a?(Symbol) || !type.is_a?(Symbol)

      @validators ||= {}
      var_name = "@#{name}".to_sym
      @validators["#{var_name}_#{type}"] = { name: var_name, type: type }
    end
  end

  # Validation instance methods
  module InstanceMethods
    def validate!
      validators = self.class.instance_variable_get(:@validators)
      validators.each do |_key, validator|
        value = instance_variable_get(validator[:name])
        validate_presence(value) if validator[:type] == :presence
      end
      true
    end

    def valid?
      validate!
    rescue StandardError
      false
    end

    protected

    def validate_presence(value)
      empty = value.nil? || value == ''
      raise BlackjackExceptions::IsEmpty, 'Не может быть пустым' if empty
    end
  end
end
