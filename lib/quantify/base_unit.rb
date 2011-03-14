
module Quantify
  module Unit
    class Base

      # Base unit class, providing most of the functionality which is inherited
      # by SI and NonSI unit classes.

      # Create a new instance of self (i.e. Base or an inherited class) and load
      # into the system of known units. See initialize for details of options
      #
      def self.load(options)
        if options.is_a? Hash
          Quantify::Unit.units << self.new(options)
        end
      end

      # Syntactic sugar for defining the known units. This method simply
      # evaluates code within the context of the self class, enabling
      # the required assocaited units to be loaded at runtime, e.g.
      #
      #  Unit::[Base|SI|NonSI].configure do
      #
      #    load :name => :metre, :physical_quantity => :length
      #    load :name => 'hectare', :physical_quantity => :area, :factor => 10000
      #    load :name => :watt, :physical_quantity => :power, :symbol => 'W'
      #
      #  end
      #
      def self.configure &block
        class_eval &block
      end

      attr_reader :name, :symbol, :label
      attr_reader :dimensions, :factor

      # Create a new Unit::Base instance.
      #
      # Valid options are: :name              => The unit name, e.g. :kilometre
      #
      #                    :physical_quantity => The physical quantity represented
      #                                          by the unit (e.g. force, mass).
      #                                          This must be recognised as a member
      #                                          of the Dimensions.dimensions array
      #
      #                    :symbol            => The unit symbol, e.g. 'kg'
      #
      #                    :factor            => The factor which relates the unit
      #                                          to the SI unit for the same physical
      #                                          quantity. For example the :factor for
      #                                          a foot would be 0.3048, since a foot
      #                                          = 0.3048 m (metre is the SI unit of
      #                                          length). If no factor is set, it is
      #                                          assumed to be 1 - which represents
      #                                          an SI unit.
      #
      #                    :scaling           => A scaling factor, used on by NonSI
      #                                          temperature units (see Unit::NonSI)
      #
      #                    :label    => The label used by JScience for the
      #                                          unit
      #
      # The physical quantity option is used to locate the corresponding dimensional
      # representation in the Dimensions class. This dimensions attribunte is used
      # in much of the unit functionality
      #
      def initialize(options={})
        unless options.keys.include?(:name) && options.keys.include?(:physical_quantity)
          raise InvalidArgumentError, "Unit definition must include a :name and :physical quantity"
        end
        @name = options[:name].standardize.singularize.downcase
        if options[:physical_quantity].is_a? Dimensions
          @dimensions = options[:physical_quantity]
        elsif options[:physical_quantity].is_a? String or options[:physical_quantity].is_a? Symbol
          @dimensions = Dimensions.for options[:physical_quantity]
        else
          raise InvalidArgumentError, "Unknown physical_quantity specified"
        end
        @factor = options[:factor].nil? ? 1.0 : options[:factor].to_f
        @symbol = options[:symbol].nil? ? nil : options[:symbol].standardize
        @label = options[:label].nil? ? nil : options[:label].to_s
      end

      # Load an initialized Unit into the system of known units
      def load
        Quantify::Unit.units << self
      end

      # Returns the scaling factor for the unit with repsect to its SI alternative.
      #
      # For example the scaling factor for degrees celsius is 273.15, i.e. celsius
      # is a value of 273.15 greater than kelvin (but with no multiplicative factor).
      #
      # Since these are rare and only used in non-SI units, an accessible attribute
      # is not deemed necessary
      #
      def scaling
        @scaling || 0.0
      end

      # Describes what the unit measures/represents. This is taken from the
      # @dimensions ivar, being, ultimately and attribute of the assocaited
      # Dimensions object, e.g.
      #
      #  unit = Unit.metre
      #  unit.measure                      #=> :length
      #
      #  unit = Unit.J
      #  unit.measure                      #=> :energy
      #
      def measures
        @dimensions.describe
      end

      def pluralized_name
        self.name.pluralize
      end

      def valid_prefixes
        return nil if self.is_compound_unit?
        Prefix.prefixes.select do |prefix|
          if self.is_si_unit?
            prefix.is_si_prefix?
          elsif self.is_non_si_unit?
            prefix.is_non_si_prefix?
          end
        end
      end

      def is_base_unit?
        Dimensions::BASE_QUANTITIES.map(&:standardize).include? self.measures
      end

      def is_derived_unit?
        not is_base_unit?
      end

      def is_prefixed_unit?
        return true if valid_prefixes and
          self.name =~ /\A(#{valid_prefixes.map(&:name).join("|")})/
        return false
      end

      def is_benchmark_unit?
        self.factor == 1.0
      end

      # Determine is a unit object represents an SI named unit
      def is_si_unit?
        self.is_a? SI
      end

      # Determine is a unit object represents an NonSI named unit
      def is_non_si_unit?
        self.is_a? NonSI
      end

      # Determine is a unit object represents an compound unit consisting of SI
      # or non-SI named units
      def is_compound_unit?
        self.is_a? Compound
      end

      # Determine if self is the same unit as another. Similarity is based on
      # representing the same physical quantity (i.e. dimensions) and the same
      # factor and scaling values.
      #
      #  Unit.metre.is_same_as? Unit.foot    #=> false
      #
      #  Unit.metre.is_same_as? Unit.gram    #=> false
      #
      #  Unit.metre.is_same_as? Unit.metre   #=> true
      #
      # The base_units attr of Compound units are not compared. Neither are the
      # names or symbols. This is because we want to recognise cases where units
      # derived from operations and defined as compound units (therefore having
      # compounded names and symbols) are the same as known, named units. For
      # example, if we build a unit for energy using only SI units, we want to
      # recognise this as a joule, rather than a kg m^2 s^-2, e.g.
      #
      #   (Unit.kg*Unit.m*Unit.m/Unit.s/Unit.s).is_same_as? Unit.joule
      #
      #                                      #=> true
      #
      def is_same_as?(other)
        return false unless self.dimensions == other.dimensions
        return false unless self.factor == other.factor
        return false unless self.scaling == other.scaling
        return true
      end

      alias :== :is_same_as?

      # Determine if another unit is an alternative unit for self, i.e. do the two
      # units represent the same physical quantity. This is established by compraing
      # their dimensions attributes. E.g.
      #
      #  Unit.metre.is_alternative_for? Unit.foot    #=> true
      #
      #  Unit.metre.is_alternative_for? Unit.gram    #=> false
      #
      #  Unit.metre.is_alternative_for? Unit.metre   #=> true
      #
      def is_alternative_for?(other)
        return true if other.dimensions == self.dimensions
        return false
      end

      # List the alternative units for self, i.e. the other units which share
      # the same dimensions.
      #
      # The list can be returned containing the alternative unit names, symbols
      # or JScience labels by providing the required format as a symbolized
      # argument.
      #
      # If no format is provide, the full unit objects for all alternative units
      # are returned within the array
      #
      def alternatives(by=nil)
        list = self.dimensions.units.reject do |unit|
          unit.is_same_as? self
        end.map(&by)
      end

      def si_unit
        self.dimensions.si_unit
      end

      # Multiply two units together. This results in the generation of a compound
      # unit.
      #
      # In the event that the new unit represents a known unit, the non-compound
      # representation is returned (i.e. of the SI or NonSI class).
      #
      def multiply(other)
        options = []
        if self.instance_of? Unit::Compound
          self.base_units.each { |unit| options << unit }
        else
          options << { :unit => self }
        end

        if other.instance_of? Unit::Compound
          other.base_units.each { |unit| options << unit }
        else
          options << { :unit => other }
        end
        Unit::Compound.new(options)#.or_equivalent_known_unit
      end

      # Divide one unit by another. This results in the generation of a compound
      # unit.
      #
      # In the event that the new unit represents a known unit, the non-compound
      # representation is returned (i.e. of the SI or NonSI class).
      #
      def divide(other)
        options = []
        if self.instance_of? Unit::Compound
          self.base_units.each { |unit| options << unit }
        else
          options << { :unit => self }
        end

        if other.instance_of? Unit::Compound
          other.base_units.each do |unit|
            options << { :unit => unit[:unit], :index => unit[:index] * -1 }
          end
        else
          options << { :unit => other, :index => -1 }
        end
        Unit::Compound.new(options)#.or_equivalent_known_unit
      end

      # Raise a unit to a power. This results in the generation of a compound
      # unit, e.g. m^3.
      # 
      # In the event that the new unit represents a known unit, the non-compound
      # representation is returned (i.e. of the SI or NonSI class).
      #
      def pow(power)
        return nil if power == 0
        original_unit = self.deep_clone
        if power > 0
          new_unit = self.deep_clone
          (power - 1).times do
            new_unit *= original_unit
          end
        elsif power < 0
          new_unit = Compound.new( [{ :unit => self, :index => -1 }] )
          ((power.abs) - 1).times do
            new_unit /= original_unit
          end
        end
        return new_unit
      end

      alias :times :multiply
      alias :* :multiply
      alias :/ :divide
      alias :** :pow

      def coerce(object)
        if object.kind_of? Numeric and object == 1
          return Unit.unity, self
        else
          raise InvalidArgumentError, "Cannot coerce #{self.class} into #{object.class}"
        end
      end
      
      # Clone self and explicitly and additionally clone the Dimensions object
      # located at @dimensions. This enables full or 'deep' copies of the already
      # initialized units to be retrieve and manipulated without corrupting the
      # known unit representations. (self.clone make only a shallow copy, i.e.
      # clones attributes but not referenced objects)
      #
      def deep_clone
        new = self.clone
        new.instance_variable_set("@dimensions", self.dimensions.clone)
        return new
      end

      # Provides syntactic sugar for generating a prefixed version of self. E.g.
      #
      #  Unit.metre.to_kilo
      #
      # is equivalent to Unit.metre.with_prefix :kilo
      #
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
