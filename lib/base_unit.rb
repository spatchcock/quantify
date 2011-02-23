
module Quantify
  module Unit
    class Base

      def self.load(options)
        if options.is_a? Hash
          Quantify::Unit.units << self.new(options)
        end
      end

      def self.configure &block
        class_eval &block
      end

      attr_reader :name, :symbol, :jscience_label
      attr_reader :dimensions, :factor

      def initialize(options={})
        unless options.keys.include?(:name) && options.keys.include?(:physical_quantity)
          raise InvalidArgumentError, "Unit definition must include a :name and :physical quantity"
        end
        @name = options[:name].standardize
        if options[:physical_quantity].is_a? Dimensions
          @dimensions = options[:physical_quantity]
        elsif options[:physical_quantity].is_a? String or options[:physical_quantity].is_a? Symbol
          @dimensions = Dimensions.for options[:physical_quantity]
        else
          raise InvalidArgumentError, "Unknown physical_quantity specified"
        end
        @factor = options[:factor].nil? ? 1.0 : options[:factor].to_f
        @symbol = options[:symbol].nil? ? nil : options[:symbol].to_sym
        @jscience_label = options[:jscience_label].nil? ? nil : options[:jscience_label].to_sym
      end

      def load
        Quantify::Unit.units << self
      end

      def scaling
        @scaling || 0.0
      end

      def measures
        @dimensions.describe
      end

      def is_si?
        self.is_a? SI
      end

      def is_same_as?(other)
        at_least_one_difference = self.instance_variables.inject(false) do |status, var|
          status ||= ( self.instance_variable_get(var) != other.instance_variable_get(var) )
        end
        return false if at_least_one_difference
        return true
      end

      def is_not_same_as?(other)
        return false if is_same_as? other
        return true
      end

      alias :== :is_same_as?

      def is_alternative_for?(other)
        return true if other.dimensions == self.dimensions
        return false
      end

      # List the alternative units for self, i.e. the other units which share
      # the same dimensions.
      #
      # The list can be returned containing the alternative unit names, symbols
      # or JScience labels by providing the required format as a symbolized
      # argument. Names are return by default, i.e. where no argument is given.
      #
      def alternatives(by=nil)
        list = Quantify::Unit.units.select do |unit|
          self.is_alternative_for? unit and
          (self == unit) == false
        end

        if by.nil?
          return list
        else
          return list.map { |unit| unit.send(by) }
        end
      end

      def multiply(other)
        # new_dimensions = self.dimensions * other.dimensions
        # new_name = "#{self.name.to_s}_#{other.name.to_s}".to_sym
        # new_factor = self.factor * other.factor
        
        # Add compound unit functionality

      end

      def divide(other)
        # new_dimensions = self.dimensions / other.dimensions
        # new_name = "#{self.name.to_s}_per_#{other.name.to_s}".to_sym
        # new_factor = self.factor / other.factor
        
        # Add compound unit functionality

      end

      def pow

      end

      alias :times :multiply
      alias :* :multiply
      alias :/ :divide
      alias :** :pow

      def deep_clone
        new = self.clone
        new.instance_variable_set("@dimensions", self.dimensions.clone)
        return new
      end

      def method_missing(method, *args, &block)
        if method.to_s =~ /(to_)(.*)/
          if prefix = Prefix.for($2.to_sym)
            self.with_prefix prefix
          end
        else
          raise NoMethodError, "Undefined method `#{method}` for #{self}:#{self.class}"
        end
      end
    end
  end
end
