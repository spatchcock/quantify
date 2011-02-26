
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

      attr_reader :name, :symbol, :jscience_label
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
      #                    :jscience_label    => The label used by JScience for the
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

      # Determine is a unit object represents an SI unit
      def is_si?
        self.is_a? SI
      end

      # Determine if self is the same unit as another. All instance attributes are
      # compared and a true result is only return if all are the same, i.e. same name,
      # symbol, factor and dimensional configuration, e.g.
      #
      #  Unit.metre.is_same_as? Unit.foot    #=> false
      #
      #  Unit.metre.is_same_as? Unit.gram    #=> false
      #
      #  Unit.metre.is_same_as? Unit.metre   #=> true
      #
      def is_same_as?(other)
        at_least_one_difference = self.instance_variables.inject(false) do |status, var|
          status ||= ( self.instance_variable_get(var) != other.instance_variable_get(var) )
        end
        return false if at_least_one_difference
        return true
      end

      # Determine if self is not the same unit as another - inverse of #is_same_as?
      def is_not_same_as?(other)
        return false if is_same_as? other
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

      # NEED TO IMPLEMENT Unit::Compound CLASS
      def multiply(other)
        base_units = []
        base_units << {:unit => self } << { :unit => other }

        Unit::Compound.new base_units
      end

      # NEED TO IMPLEMENT Unit::Compound CLASS
      def divide(other)
        base_units = []
        base_units << {:unit => self } << { :unit => other, :index => -1 }

        Unit::Compound.new base_units
      end

      # NEED TO IMPLEMENT Unit::Compound CLASS
      def pow

      end

      def reciprocalize
        self.dimensions.reciprocalize!
        return self
      end

      alias :times :multiply
      alias :* :multiply
      alias :/ :divide
      alias :** :pow

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
