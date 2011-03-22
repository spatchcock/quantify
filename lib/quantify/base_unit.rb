
module Quantify
  module Unit
    class Base

      # Base unit class, providing most of the functionality which is inherited
      # by SI and NonSI unit classes.

      # Create a new instance of self (i.e. Base or an inherited class) and load
      # into the system of known units. See initialize for details of options
      #
      def self.load(options)
        unit = self.new(options)
        unit.load
      end

      # Syntactic sugar for defining the known units. This method simply
      # evaluates code within the context of the self class, enabling
      # the required assocaited units to be loaded at runtime, e.g.
      #
      #  Unit::[Base|SI|NonSI].configure do |config|
      #
      #    config.load :name => :metre, :physical_quantity => :length
      #    config.load :name => 'hectare', :physical_quantity => :area, :factor => 10000
      #    config.load :name => :watt, :physical_quantity => :power, :symbol => 'W'
      #
      #  end
      #
      def self.configure
        yield self if block_given?
      end

      attr_accessor :name, :symbol, :label
      attr_accessor :dimensions, :factor

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
      #                    :label             => The label used by JScience for the
      #                                          unit
      #
      # The physical quantity option is used to locate the corresponding dimensional
      # representation in the Dimensions class. This dimensions attribunte is used
      # in much of the unit functionality
      #
      def initialize(options=nil)
        if options.is_a? Hash
          @name = options[:name].standardize.singularize.downcase
          options[:dimensions] = options[:dimensions] || options[:physical_quantity]
          if options[:dimensions].is_a? Dimensions
            @dimensions = options[:dimensions]
          elsif options[:dimensions].is_a? String or options[:dimensions].is_a? Symbol
            @dimensions = Dimensions.for options[:dimensions]
          else
            raise InvalidArgumentError, "Unknown physical_quantity specified"
          end
          @factor = options[:factor].nil? ? 1.0 : options[:factor].to_f
          @symbol = options[:symbol].nil? ? nil : options[:symbol].standardize
          @label = options[:label].nil? ? nil : options[:label].to_s
        end
        yield self if block_given?
        valid?
      end

      def valid?
        return true if valid_name? and valid_dimensions?
        raise InvalidArgumentError, "Unit definition must include a name and physical quantity"
      end

      def valid_name?
        @name.is_a? String and not @name.empty?
      end

      def valid_dimensions?
        @dimensions.is_a? Dimensions
      end

      # Permits a block to be used, operating on self. This is useful for modifying
      # the attributes of an already instantiated unit, especially when defining
      # units on the basis of operation on existing units for adding specific
      # (rather than derived) names or symbols, e.g.
      #
      #   (Unit.pound_force/(Unit.in**2)).operate do |unit|
      #     unit.symbol = 'psi'
      #     unit.label = 'psi'
      #     unit.name = 'pound per square inch'
      #   end
      #
      def operate
        yield self if block_given?
        return self if valid?
      end

      # Load an initialized Unit into the system of known units.
      #
      # If a block is given, the unit can be operated on prior to loading, in a
      # similar to way to the #operate method.
      #
      def load
        yield self if block_given?
        raise InvalidArgumentError, "A unit with the same label: #{self.name}) already exists" if loaded?
        Quantify::Unit.units << self if valid?
      end

      # check if an object with the same label already exists
      def loaded?
        Unit.units.any? { |unit| self.has_same_identity_as? unit }
      end

      # Returns the scaling factor for the unit with repsect to its SI alternative.
      #
      # For example the scaling factor for degrees celsius is 273.15, i.e. celsius
      # is a value of 273.15 greater than kelvin (but with no multiplicative factor).
      #
      # Since these are rare and only used in non-SI, temperature units, an accessible
      # attribute was deemed overkill
      #
      def scaling
        @scaling || 0.0
      end

      def has_scaling?
        scaling != 0.0
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

      # Returns an array representing the valid prefixes for the unit described 
      # by self
      #
      # If no argument is given, the array holds instances of Prefix::Base (or
      # subclasses). Alternatively only the names or symbols of each prefix can 
      # be returned by providing the appropriate prefix attribute as a symbolized 
      # argument, e.g.
      #
      #   Unit.m.valid_prefixes                 #=> [ #<Quantify::Prefix: .. >,
      #                                               #<Quantify::Prefix: .. >,
      #                                               ... ]
      #
      #   Unit.m.valid_prefixes :name           #=> [ "deca", "hecto", "kilo", 
      #                                               "mega", "giga", "tera"
      #                                               ... ]    
      #
      #   Unit.m.valid_prefixes :symbol         #=> [ "da", "h", "k", "M", "G",
      #                                               "T", "P" ... ]
      #
      def valid_prefixes(by=nil)
        return nil if self.is_compound_unit?
        Prefix.prefixes.select do |prefix|
          if self.is_si_unit?
            prefix.is_si_prefix?
          elsif self.is_non_si_unit?
            prefix.is_non_si_prefix?
          end
        end.map(&by)
      end

      # Determine if the unit represents one of the base quantities
      def is_base_unit?
        Dimensions::BASE_QUANTITIES.map(&:standardize).include? self.measures
      end

      # Determine is the unit is a derived unit - that is, a unit made up of more
      # than one of the base quantities
      #
      def is_derived_unit?
        not is_base_unit?
      end

      # Determine if the unit is a prefixed unit
      def is_prefixed_unit?
        return true if valid_prefixes and
          self.name =~ /\A(#{valid_prefixes.map(&:name).join("|")})/
        return false
      end

      # Determine if the unit is one of the units against which all other units
      # of the same physical quantity are defined. These units are almost entirely
      # equivalent to the non-prefixed, SI units, but the one exception is the
      # kilogram, making this method necessary.
      #
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
        [:dimensions,:factor,:scaling].all? do |attr|
          self.send(attr) == other.send(attr)
        end
      end

      alias :== :is_same_as?

      # Check if unit has the identity as another, i.e. the same label. This is
      # used to determine if a unit with the same accessors already exists in
      # the module variable @@units
      #
      def has_same_identity_as?(other)
        self.label == other.label and not self.label.nil?
      end

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
        other.dimensions == self.dimensions
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
        self.dimensions.units(nil).reject do |unit|
          unit.is_same_as? self
        end.map(&by)
      end

      # Returns the SI unit for the same physical quantity which is represented
      # by self, e.g.
      #
      def si_unit
        self.dimensions.si_unit
      end

      # Multiply two units together. This results in the generation of a compound
      # unit.
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
        Unit::Compound.new(options)
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
        Unit::Compound.new(options)
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

      def with_prefix(name_or_symbol)
        if self.name =~ /\A(#{valid_prefixes(:name).join("|")})/
          raise InvalidArgumentError, "Cannot add prefix where one already exists: #{self.name}"
        end

        if name_or_symbol.is_a? Prefix
          prefix = name_or_symbol
        else
          prefix = Prefix.for(name_or_symbol)
        end

        unless prefix.nil?
          new_unit_options = {}
          new_unit_options[:name] = "#{prefix.name}#{self.name}"
          new_unit_options[:symbol] = "#{prefix.symbol}#{self.symbol}"
          new_unit_options[:label] = "#{prefix.symbol}#{self.label}"
          new_unit_options[:factor] = prefix.factor * self.factor
          new_unit_options[:physical_quantity] = self.dimensions
          self.class.new(new_unit_options)
        else
          raise InvalidArgumentError, "Prefix unit is not known: #{prefix}"
        end
      end

      def or_equivalent
        equivalent_known_unit || self
      end

      def equivalent_known_unit
        Unit.units.find {|unit| unit == self and not unit.is_compound_unit? }
      end

      # Enables neat shorthand for reciprocal of a unit, e.g.
      #
      #   unit = Unit.m
      #
      #   (1/unit).symbol                     #=> "m^-1"
      #
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

      # Provides syntactic sugar for several methods. E.g.
      #
      #  Unit.metre.to_kilo
      #
      # is equivalent to Unit.metre.with_prefix :kilo.
      # 
      #  Unit.m.alternatives_by_name
      #  
      # is equaivalent to Unit.m.alternatives :name
      #
      #
      #
      def method_missing(method, *args, &block)
        if method.to_s =~ /(to_)(.*)/ and prefix = Prefix.for($2.to_sym)
          self.with_prefix prefix
        elsif method.to_s =~ /(alternatives_by_)(.*)/ and self.respond_to? $2.to_sym
          self.alternatives $2.to_sym
        elsif method.to_s =~ /(valid_prefixes_by_)(.*)/ and Prefix::Base.instance_methods.include? $2.to_s
          self.valid_prefixes $2.to_sym
        else
          super
        end
      end

    end
  end
end
