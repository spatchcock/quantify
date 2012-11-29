#! usr/bin/ruby

module Quantify
  class Quantity

    include Comparable

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
    # subseqent unit name, symbol or JScience label. Returns an array containing
    # quantity objects for each quantity recognised.
    def self.parse(string,options={})

      return [Quantity.new(nil, nil)] unless string != nil && string.strip.length > 0

      # Split the string into groups of words starting with a number
      quantities   = []
      remainder    = []
      words        = string.words

      until words.empty? do
        word = words.shift

        if word.starts_with_number?
          if (Unit::QUANTITY_REGEX).match(word)
            word, other = $1, $2
            words.unshift(other)
          end
          quantities << [word]
        else
          if quantities.empty?
            remainder << word
          else
            quantities.last << word
          end
        end
      end

      remainders = []
      remainders << remainder.join(" ")

      # Iterate through word groups and parse units following each number
      quantities.map! do |words|

        value  = words.shift
        string = words.join(" ")

        # Parse string for unit references
        unit, remainder = Unit.parse(string, :iterative => true, :remainder => true) 
        unit, remainder = Unit.dimensionless, string if unit.nil?
        remainders << remainder

        # Instantiate quantity using value and unit
        Quantity.new(value,unit)
          
      end.compact

      return [quantities, remainders] if options[:remainder] == true
      return quantities
      
    rescue Quantify::Exceptions::InvalidArgumentError
      raise Quantify::Exceptions::QuantityParseError, "Cannot parse string into value and unit"
    end

    def self.configure(&block)
      self.class_eval(&block) if block
    end

    def self.auto_consolidate_units=(true_or_false)
      @auto_consolidate_units = true_or_false
    end
    
    def self.auto_consolidate_units?
      @auto_consolidate_units.nil? ? false : @auto_consolidate_units
    end

    protected

    def self.is_basic_conversion_with_scalings?(quantity,new_unit)
      return true if (quantity.unit.has_scaling? || new_unit.has_scaling?) &&
                     !quantity.unit.is_compound_unit? &&
                     !new_unit.is_compound_unit?

      return false
    end
    
    public

    attr_reader :value, :unit

    # Float(...) ensures an error is raised if value is not representable as number
    def value=(value)
      if value.nil?
        @value = nil
      else
        @value = Float(value)
      end
    end

    # Unit.for(...) ensures an error is rasied if unit is not a valid unit
    def unit=(unit)
      if unit.nil?
        @unit = Unit.for(:unity)
      else
        @unit = Unit.for(unit)
      end
    end

    # Initialize a new Quantity object. Two arguments are required: a value and
    # a unit. The unit can be a an instance of Unit::Base or the label, name, symbol or
    # JScience reference of a known (or derivable through known units and prefixes)
    # unit
    #
    def initialize(value, unit = nil)
      if value
        @value = Float(value)
      else
        @value = nil
      end
      
      if unit
        @unit = Unit.for(unit)
      else
        @unit = Unit.dimensionless
      end
    end

    # Returns a description of what the quantity describes, based upon the physica
    # quantity which is represented by the Dimensions object in the Quantity unit.
    # e.g.
    #
    #   Quantity.parse("25 yr").represents            #=> :time
    #
    #   1.foot.represents                             #=> :length
    #
    #   Quantity.new(123.456, :degree_celsius).represents
    #                                                 #=> :temperature
    def represents
      @unit.measures
    end

    # Returns a string representation of the quantity, using the unit symbol
    def to_s format=:symbol
      if format == :name
        unit_string = @value == 1 || @value == -1 ? @unit.name : @unit.pluralized_name 
      else
        unit_string = @unit.send format 
      end

      string =  "#{@value}"
      string += " #{unit_string}" unless unit_string.empty?

      string
    end
    
    def inspect
      to_s
    end

    # Converts self into a quantity using the unit provided as an argument. The
    # new unit must represent the same physical quantity, i.e. have the same
    # dimensions, e.g.
    #
    #   Quantity.parse("12 yd").to(:foot).to_s          #=> "36 ft"
    #
    #   1000.kilogram.to(:tonne).to_s                   #=> "1 t"
    #
    # For compound units, it is permissable to pass in units which are same dimension of at
    # least one base unit. 
    #
    # #method_missing provides some syntactic sugar for the new unit to
    # be provided as part of the method name, based around /to_(<unit>)/, e.g.
    #
    #   200.cm.to_metre.to_s                   #=> "1 t"
    #
    # The unit value is converted to the corresponding value for the same quantity
    # in terms of the new unit.
    #
    def to(new_unit)
      new_unit = Unit.for(new_unit)

      if Quantity.is_basic_conversion_with_scalings?(self,new_unit)
        Quantity.new(@value,@unit).conversion_with_scalings! new_unit

      elsif self.unit.is_alternative_for? new_unit
        Quantity.new(@value,@unit).convert_to_equivalent_unit! new_unit

      elsif self.unit.is_compound_unit?
        Quantity.new(@value,@unit).convert_compound_unit_to_non_equivalent_unit! new_unit

      else
        raise Exceptions::InvalidArgumentError, "Cannot convert #{self.unit.to_s} quantity into #{new_unit.to_s}. Units are incompatible"
      end      
    end
    
    # Converts a quantity to the equivalent quantity using only SI units
    def to_si
      if @unit.is_compound_unit?
        Quantity.new(@value,@unit).convert_compound_unit_to_si!
      elsif @unit.is_dimensionless?
        return self.dup
      elsif @value.nil?
        return Quantity.new(nil, @unit.si_unit)
      else
        self.to(@unit.si_unit)
      end
    end
    
    def pow!(power)
      raise Exceptions::InvalidArgumentError, "Argument must be an integer" unless power.is_a? Integer

      @value = @value ** power
      @unit  = @unit ** power

      return self
    end

    def add!(other)
      add_or_subtract!(:+, other)
    end

    def subtract!(other)
      add_or_subtract!(:-, other)
    end

    def multiply!(other)
      multiply_or_divide!(:*, other)
    end

    def divide!(other)
      multiply_or_divide!(:/, other)
    end

    def add(other)
      Quantity.new(@value,@unit).add!(other)
    end
    alias :+ :add

    def subtract(other)
      Quantity.new(@value,@unit).subtract!(other)
    end
    alias :- :subtract

    def multiply(other)
      Quantity.new(@value,@unit).multiply!(other)
    end
    alias :times :multiply
    alias :* :multiply

    def divide(other)
      Quantity.new(@value,@unit).divide!(other)
    end
    alias :/ :divide

    def pow(power)
      Quantity.new(@value,@unit).pow!(power)
    end
    alias :** :pow

    def rationalize_units
      return self unless @unit.is_a? Unit::Compound
      self.to @unit.clone.rationalize_base_units!
    end

    def rationalize_units!
      rationalized_quantity = self.rationalize_units

      @value = rationalized_quantity.value
      @unit  = rationalized_quantity.unit

      return self
    end

    def cancel_base_units!(*units)
      @unit = @unit.cancel_base_units!(*units) if @unit.is_compound_unit?
      return self
    end

    # Round the value attribute to the specified number of decimal places. If no
    # argument is given, the value is rounded to NO decimal places, i.e. to an
    # integer
    #
    def round!(decimal_places=0)
      factor = ( decimal_places == 0 ? 1 : 10.0 ** decimal_places )
      @value = (@value * factor).round / factor
      
      return self
    end

    # Similar to #round! but returns new Quantity instance rather than rounding
    # in place
    #
    def round(decimal_places=0)
      rounded_quantity = Quantity.new @value, @unit
      rounded_quantity.round! decimal_places
    end

    def <=>(other)
      raise Exceptions::InvalidArgumentError, "Argument must be another quantity" unless other.is_a? Quantity
      raise Exceptions::InvalidArgumentError, "Argument must be of same dimensions as self" unless other.unit.is_alternative_for?(unit)
      
      return 0 if @value.nil? && (other.nil? || other.value.nil?)

      other = other.to @unit
      @value.to_f <=> other.value.to_f
    end

    def ===(range)
      raise Exceptions::InvalidArgumentError, "Argument must be a Range" unless range.is_a? Range
      range.cover? self
    end

    def between?(min, max)
      raise NoMethodError, "Cannot compare quantities, you have a nil value" if @value.nil?
      super(min,max)
    end

    protected
    
    # Quantities must be of the same dimension in order to operate. If they are
    # represented by different units (but represent the same physical quantity)
    # the second quantity is converted into the unit belonging to the first unit
    # and the addition is completed
    #
    def add_or_subtract!(operator,other)
      if other.is_a? Quantity
        other = other.to(@unit) if other.unit.is_alternative_for?(@unit)

        if @unit.is_equivalent_to? other.unit
          @value = @value.send operator, other.value

          return self
        else
          raise Quantify::Exceptions::InvalidObjectError, "Cannot add or subtract Quantities with different dimensions"
        end
      else
        raise Quantify::Exceptions::InvalidObjectError, "Cannot add or subtract non-Quantity objects"
      end
    end

    def multiply_or_divide!(operator,other)
      if other.kind_of? Numeric
        raise ZeroDivisionError if (other.to_f == 0.0 && operator == :/)
        @value = @value.send(operator,other)

        return self
      elsif other.kind_of? Quantity
        @unit = @unit.send(operator,other.unit).or_equivalent
        @unit.consolidate_base_units! if @unit.is_compound_unit? && Quantity.auto_consolidate_units?
        @value = @value.send(operator,other.value)
        
        return self
      else
        raise Quantify::Exceptions::InvalidArgumentError, "Cannot multiply or divide a Quantity by a non-Quantity or non-Numeric object"
      end
    end
    
    # Conversion where both units (including compound units) are of precisely
    # equivalent dimensions, i.e. direct alternatives for one another. Where
    # previous unit is a compound unit, new unit must be cancelled by all original
    # base units
    #
    def convert_to_equivalent_unit!(new_unit)
      old_unit = @unit
      self.multiply!(Unit.ratio new_unit, old_unit)
      old_base_units = old_unit.base_units.map { |base| base.unit } if old_unit.is_compound_unit?
      self.cancel_base_units!(*old_base_units || [old_unit])
    end

    def conversion_with_scalings!(new_unit)
      @value = (((@value + @unit.scaling) * @unit.factor) / new_unit.factor) - new_unit.scaling
      @unit  = new_unit

      return self
    end

    # Conversion where self is a compound unit, and new unit is not an alternative
    # to the whole compound but IS an alternative to one or more of the base units,
    # e.g.,
    #
    #   Unit.kilowatt_hour.to :second           #=> 'kilowatt second'
    #
    def convert_compound_unit_to_non_equivalent_unit!(new_unit)
      @unit.base_units.select do |base|
        base.unit.is_alternative_for? new_unit
      end.inject(self) do |quantity,base|
        factor = Unit.ratio(new_unit**base.index, base.unit**base.index)
        quantity.multiply!(factor).cancel_base_units!(base.unit)
      end
    end
    
    def convert_compound_unit_to_si!
      until @unit.is_base_quantity_si_unit? do
        
        unit = @unit.base_units.find do |base|
          !base.is_base_quantity_si_unit?
        end.unit

        self.convert_compound_unit_to_non_equivalent_unit!(unit.si_unit)
      end
      return self
    end

    # Enables shorthand for reciprocal of quantity, e.g.
    #
    #   quantity = 2.m
    #
    #   (1/quantity).to_s :name                 #=> "0.5 per metre"
    #
    def coerce(object)
      if object.kind_of? Numeric
        return Quantity.new(object, Unit.unity), self
      else
        raise Exceptions::InvalidArgumentError, "Cannot coerce #{self.class} into #{object.class}"
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
        super
      end
    end

  end
end
