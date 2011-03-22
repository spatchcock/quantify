#! usr/bin/ruby

module Quantify
  class Quantity

    # The quantity class represents quantities. Quantities are represented by a
    # numeric value - of class Numeric - and a unit - of class Unit::Base.
    #
    # Quantity objects can be added and subtracted. Mulyiplication and division
    # by scalar values is also possible, but multiplying and dividing two quantity
    # objects will be possible when Unit::Compound is implemented.
    #
    # Quantity units can be initialized using three methods:
    #
    #  1. Conventionally, using:
    #
    #       Quantity.new <value>, <unit> , e.g.         #=> Quantity
    #
    #       quantity = Quantity.new 3599.8, :joule      #=> Quantity
    #
    #     The unit argument can be an instance of Unit::Base (or inheritors) or
    #     the name, symbol or JScience label of a known unit provided as a string
    #     or a symbol
    #
    #  2. Using the class method #parse, which parses a string containing a value
    #     and a unit, e.g.
    #
    #       Quantity.parse "29 m"                       #=> Quantity
    #
    #       Quantity.parse "1025 tonne"                 #=> Quantity
    #
    #  3. Using a shorthand method enabled by extending the Numeric class (see
    #     core_extensions.rb). This allows the name, symbol or JScience label of
    #     a unit to be appended to a Numeric object as a method, e.g.
    #
    #       1.metre                                     #=> Quantity
    #
    #       68.54321.kilogram                           #=> Quantity
    #
    #       16.Gg                                       #=> Quantity (gigagrams)



    # Parse a string and return a Quantity object based upon the value and
    # subseqent unit name, symbol or JScience label
    def self.parse(string)
      if quantity = /([\d\s.,]+)([\w\s\/\^\d-]*)/.match(string)
        Quantity.new($1, $2)
      else
        raise Quantify::QuantityParseError "Cannot parse string into value and unit"
      end
    end

    attr_accessor :value, :unit

    # Initialize a new Quantity object. Two arguments are required: a value and
    # a unit. The unit can be a an instance of Unit::Base or the name, symbol or
    # JScience label of a known (or derivable through know units and prefixes)
    # unit
    def initialize(value, unit)
      @value = value.to_f
      if unit.is_a? Quantify::Unit::Base
        @unit = unit
      else
        @unit = Unit.for(unit)
      end
    end

    # Returns a description of what the quantity describes, based upon the physica
    # quantity which is represented by the Dimensions object in the Quantity unit.
    # e.g.
    #
    #   Quantity.parse( )"25 yr").represents          #=> :time
    #
    #   1.foot.represents                             #=> :length
    #
    #   Quantity.new(123.456, :degree_celsius).represents
    #                                                 #=> :temperature
    def represents
      self.unit.measures
    end

    # Returns a string representation of the quantity, using the unit symbol
    def to_s format=:symbol
      if format == :name
        if self.value == 1 or self.value == -1
          "#{self.value} #{self.unit.name}"
        else
          "#{self.value} #{self.unit.pluralized_name}"
        end
      else
        "#{self.value} #{self.unit.symbol}"
      end
    end

    # Converts self into a quantity using the unit provided as an argument. The
    # new unit must represent the same physical quantity, i.e. have the same
    # dimensions, e.g.
    #
    #   Quantity.parse("12 yd").to(:foot).to_s          #=> "36 ft"
    #
    #   1000.kilogram.to(:tonne).to_s                   #=> "1 t"
    #
    # The method #method_missing provides some syntactic sugar for the new unit to
    # be provided as part of the method name, based around /to_(<unit>)/, e.g.
    #
    #   200.cm.to_metre.to_s                   #=> "1 t"
    #
    # The unit value is converted to the corresponding value for the same quantity
    # in terms of the new unit.
    #
    def to(new_unit)
      new_unit = Unit.for new_unit unless new_unit.is_a? Unit::Base
      if is_basic_conversion_with_scalings? new_unit
        conversion_with_scalings new_unit
      elsif self.unit.is_alternative_for? new_unit
        conversion_with_equivalent_units new_unit
      elsif self.unit.is_compound_unit?
        conversion_with_compound_and_non_equivalent_units new_unit
      else
        nil # raise? or ...
      end      
    end

    # Converts a quantity to the equivalent quantity using only SI units
    def to_si
      if self.unit.is_compound_unit?
        until self.unit.is_si_unit? do
          unit = self.unit.base_units.find do |unit|
            !unit[:unit].is_si_unit?
          end[:unit]
          quantity = self.to unit.si_unit
          @value = quantity.value
          @unit = quantity.unit
        end
        return self
      else
        self.to(self.unit.si_unit)
      end
    end

    # Add two quantities.
    #
    # Quantities must be of the same dimension in order to operate. If they are
    # represented by different units (but represent the same physical quantity)
    # the second quantity is converted into the unit belonging to the first unit
    # and the addition is completed
    #
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

    # Subtract two quantities.
    #
    # Quantities must be of the same dimension in order to operate. If they are
    # represented by different units (but represent the same physical quantity)
    # the second quantity is converted into the unit belonging to the first unit
    # and the subtraction is completed
    #
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

    # Multiply a quantity by a scalar value, i.e. a value of the Numeric class
    #
    def multiply(other)
      if other.kind_of? Numeric
        @value *= other
        return self
      elsif other.kind_of? Quantity
        new_unit = self.unit * other.unit
        new_value = self.value * other.value
        return Quantity.new new_value, new_unit
      else
        raise Quantify::InvalidArgumentError "Cannot multiply a Quantity by a non-Quantity or non-Numeric object"
      end
    end

    # Divide a quantity by a scalar value, i.e. a value of the Numeric class
    #
    def divide(other)
      if other.kind_of? Numeric
        @value /= other
        return self
      elsif other.kind_of? Quantity
        new_unit = self.unit / other.unit
        new_value = self.value / other.value
        return Quantity.new new_value, new_unit
      else
        raise Quantify::InvalidArgumentError "Cannot divide a Quantity by a non-Quantity or non-Numeric object"
      end
    end

    alias :times :multiply
    alias :* :multiply
    alias :+ :add
    alias :- :subtract
    alias :/ :divide

    # Round the value attribute to the specified number of decimal places. If no
    # argument is given, the value is rounded to NO decimal places, i.e. to an
    # integer
    #
    def round!(decimal_places=0)
      factor = ( decimal_places == 0 ? 1 : 10.0 ** decimal_places )
      @value = (@value * factor).round / factor
      self
    end

    # Similar to #round! but returns new Quantity instance rather than rounding
    # in place
    #
    def round(decimal_places=0)
      rounded_quantity = Quantity.new @value, @unit
      rounded_quantity.round! decimal_places
    end

    # Enables neat shorthand for reciprocal of quantity, e.g.
    #
    #   quantity = 2.m
    #
    #   (1/quantity).to_s :name                 #=> "0.5 per metre"
    #
    def coerce(object)
      if object.kind_of? Numeric
        return Quantity.new(object, Unit.unity), self
      else
        raise InvalidArgumentError, "Cannot coerce #{self.class} into #{object.class}"
      end
    end

    # Dynamic method for converting to another unit, e.g
    #
    #   2.ft.to_metre.to_s                           #=> "0.6096 m"
    #
    #   30.degree_celsius.to_K.to_s :name            #=> "303.15 kelvins"
    #
    def method_missing(method, *args, &block)
      if method.to_s =~ /(to_)(.*)/
        to($2)
      else
        raise NoMethodError, "Undefined method '#{method}' for #{self}:#{self.class}"
      end
    end

    protected

    def is_basic_conversion_with_scalings?(new_unit)
      return true if (self.unit.has_scaling? or new_unit.has_scaling?) and
        not self.unit.is_compound_unit? and
        not new_unit.is_compound_unit?
      return false
    end

    def conversion_with_equivalent_units(new_unit)
      self * (Unit.ratio new_unit, self.unit)
    end

    def conversion_with_scalings(new_unit)
      new_value = (((self.value + self.unit.scaling) * self.unit.factor) / new_unit.factor) - new_unit.scaling
      Quantity.new new_value, new_unit
    end

    def conversion_with_compound_and_non_equivalent_units(new_unit)
      self.unit.base_units.select do |unit|
        unit[:unit].is_alternative_for? new_unit
      end.map do |unit|
        Unit.ratio(new_unit**unit[:index],unit[:unit]**unit[:index])
      end.inject(self) do |quantity,factor|
        quantity * factor
      end
    end

  end
end
