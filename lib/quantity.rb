#! usr/bin/ruby

module Quantify
  class Quantity

    def self.parse(string)
      if quantity = /([\d\s.,]+)([\w\s\/\^\d-]*)/.match(string)
        Quantity.new($1, $2)
      else
        raise Quantify::QuantityParseError "Cannot parse string into value and unit"
      end
    end

    attr_accessor :value, :unit

    def initialize(value, unit)
      @value = value.to_f
      if unit.is_a? Quantify::Unit::Base
        @unit = unit
      else
        @unit = Unit.for(unit)
      end
    end

    def represents
      self.unit.measures
    end

    def to_s
      "#{self.value} #{self.unit.symbol}"
    end

    def to(new_unit)
      new_unit = Unit.for new_unit unless new_unit.is_a? Unit::Base
      unless new_unit.is_alternative_for? self.unit
        raise InvalidUnitError, "Units do not represent the same physical quantity"
      end
      new_value = (((self.value + self.unit.scaling) * self.unit.factor) / new_unit.factor) - new_unit.scaling
      Quantity.new new_value, new_unit
    end

    def to_si

    end

    def add(other)
      if other.is_a? Quantity
        other = other.to self.unit if other.unit.is_alternative_for? self.unit
        if self.unit == other.unit
          @value += other.value
          return self
        else
          raise Quantify::InvalidObjectError "Cannot add Quantities with different dimensions"
        end
      else
        raise Quantify::InvalidObjectError "Cannot add non-Quantity objects"
      end
    end

    def subtract(other)
      if other.is_a? Quantity
        other = other.to self.unit if other.unit.is_alternative_for? self.unit
        if self.unit == other.unit
          @value -= other.value
          return self
        else
          raise Quantify::InvalidObjectError "Cannot subtract Quantities with different dimensions"
        end
      else
        raise Quantify::InvalidObjectError "Cannot subtract non-Quantity objects"
      end
    end

    def multiply(other)
      if other.kind_of? Numeric
        @value *= other
        return self
      elsif other.kind_of? Quantity
        raise Quantify::InvalidArgumentError "Multiplying quantities by quantities not implemented yet"
      else
        raise Quantify::InvalidArgumentError "Cannot multiply a Quantity by a non-Quantity or non-Numeric object"
      end
    end

    def divide(other)
      if other.kind_of? Numeric
        @value /= other
        return self
      elsif other.kind_of? Quantity
        raise Quantify::InvalidArgumentError "Multiplying quantities by quantities not implemented yet"
      else
        raise Quantify::InvalidArgumentError "Cannot multiply a Quantity by a non-Quantity or non-Numeric object"
      end
    end

    def round(decimal_places = nil)
      if decimal_places == 0 or decimal_places.nil?
        @value = value.to_i
      else
        factor = 10.0 ** decimal_places
        @value = (@value * factor).round / factor
      end
      return self
    end

    def method_missing(method, *args, &block)
      if method.to_s =~ /(to_)(.*)/
        to($2)
      else
        raise NoMethodError, "Undefined method `#{method}` for #{self}:#{self.class}"
      end
    end

    alias :times :multiply
    alias :* :multiply
    alias :+ :add
    alias :- :subtract
    alias :/ :divide

  end
end
