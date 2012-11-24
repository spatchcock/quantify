module Quantify
  module Unit
    class Base

      extend ExtendedMethods

      # Base unit class, providing most of the functionality which is inherited
      # by SI and NonSI unit classes.

      # Create a new instance of self (i.e. Base or an inherited class) and load
      # into the system of known units. See initialize for details of options
      #
      def self.load(options=nil,&block)
        self.new(options,&block).load
      end

      def self.construct_and_load(unit,&block)
        self.construct(unit, &block).load
      end
      
      def self.initialize_prefixed_version(prefix,unit)

        prefix, unit = Prefix.for(prefix), Unit.for(unit)

        raise Exceptions::InvalidArgumentError, "Prefix is not known" if prefix.nil?
        raise Exceptions::InvalidArgumentError, "Unit is not known" if unit.nil?
        raise Exceptions::InvalidArgumentError, "Cannot add prefix where one already exists: #{unit.prefix.name}" if unit.prefix
        
        self.new &self.block_for_prefixed_version(prefix,unit)
      end

      # Mass load prefixed units. First argument is a single or array of units.
      # Second argument is a single or array of prefixes. All specfied units will
      # be loaded with all specified prefixes.
      #
      def self.prefix_and_load(prefixes,units)
        [units].flatten.each do |unit|
          unit = Unit.for(unit)
          [prefixes].flatten.each do |prefix|
            prefixed_unit = unit.with_prefix(prefix) rescue unit
            prefixed_unit.load unless prefixed_unit.loaded?
          end
        end
      end

      # Define a new unit in terms of an already instantiated compound unit. This
      # unit becomes a representation of the compound - without explicitly holding
      # the base units, e.g.
      #
      #   Unit::Base.construct(Unit.m**2).name           #=> "square metre"
      #
      #   Unit::Base.construct(Unit.m**3) do |unit|
      #     unit.name = "metres cubed"
      #   end.name                                       #=> "metres cubed"
      #
      def self.construct(unit,&block)
        new_unit = self.new unit.to_hash
        block.call(new_unit) if block_given?
        return new_unit
      end

      # Syntactic sugar for defining the units known to the system, enabling the
      # required associated units to be loaded at runtime, e.g.
      #
      #   Unit::[Base|SI|NonSI].configure do |config|
      #
      #     load :name => :metre, :physical_quantity => :length
      #     load :name => 'hectare', :physical_quantity => :area, :factor => 10000
      #     load :name => :watt, :physical_quantity => :power, :symbol => 'W'
      #
      #   end
      #
      def self.configure(&block)
        class_eval(&block) if block
      end
      
      attr_reader :name, :symbol, :label, :j_science, :factor, :dimensions
      attr_reader :acts_as_alternative_unit, :acts_as_equivalent_unit
      attr_accessor :base_unit, :prefix

      # Create a new Unit::Base instance.
      #
      # Valid options are: :name              => The unit name, e.g. :kilometre
      #
      #                    :dimensions        => The physical quantity represented
      #                                          by the unit (e.g. force, mass).
      #                                          This must be recognised as a member
      #                                          of the Dimensions.dimensions array
      #
      #                    :physical_quantity => Alias for :dimensions
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
      #                                          an SI benchmark unit.
      #
      #                    :scaling           => A scaling factor, used only by NonSI
      #                                          temperature units
      #
      #                    :label             => The label used by JScience for the
      #                                          unit
      #
      # The physical quantity option is used to locate the corresponding dimensional
      # representation in the Dimensions class. This dimensions attribute is to
      # provide much of the unit functionality
      #
      def initialize(options=nil,&block)
        @acts_as_alternative_unit = true
        @acts_as_equivalent_unit  = false

        self.factor    = 1.0
        self.symbol    = nil
        self.label     = nil
        self.name      = nil
        self.j_science = nil
        self.base_unit = nil
        self.prefix    = nil

        if options.is_a? Hash
          self.dimensions = options[:dimensions] if options[:dimensions]
          self.factor     = options[:factor]     if options[:factor]
          self.name       = options[:name]       if options[:name]
          self.symbol     = options[:symbol]     if options[:symbol]
          self.label      = options[:label]      if options[:label]
          self.j_science  = options[:j_science]  if options[:j_science]
        end

        block.call(self) if block_given?
        valid?
      end

      # Set the dimensions attribute of self. Valid arguments passed in are (1)
      # instances of the Dimensions class; or (2) string or symbol matching
      # the physical quantity attribute of a known Dimensions object.
      #
      def dimensions=(dimensions)
        if dimensions.is_a? Dimensions
          @dimensions = dimensions
        elsif dimensions.is_a?(String) || dimensions.is_a?(Symbol)
          @dimensions = Dimensions.for(dimensions)
        else
          raise Exceptions::InvalidArgumentError, "Unknown physical_quantity specified"
        end
      end
      alias :physical_quantity= :dimensions=

      # Set the name attribute of self. Names are stringified, singlularized and
      # stripped of underscores. Superscripts are formatted according to the
      # configuration found in Quantify.use_superscript_characters? Names are NOT
      # case sensitive (retrieving units by name can use any or mixed cases).
      #
      def name=(name)
        name  = name.to_s.remove_underscores.singularize
        @name = Unit.use_superscript_characters? ? name.with_superscript_characters : name.without_superscript_characters
      end

      # Set the symbol attribute of self. Symbols are stringified and stripped of
      # any underscores. Superscripts are formatted according to the configuration
      # found in Quantify.use_superscript_characters?
      #
      # Conventional symbols for units and unit prefixes prescribe case clearly
      # (e.g. 'm' => metre, 'M' => mega-; 'g' => gram, 'G' => giga-) and
      # therefore symbols ARE case senstive.
      #
      def symbol=(symbol)
        symbol  = symbol.to_s.remove_underscores
        @symbol = Unit.use_superscript_characters? ? symbol.with_superscript_characters : symbol.without_superscript_characters
      end

      # Set the label attribute of self. This represents the unique identifier for
      # the unit, and follows JScience for many standard units and general
      # formatting (e.g. underscores, forward slashes, middots).
      #
      # Labels are stringified and superscripts are formatted according to the
      # configuration found in Quantify.use_superscript_characters?
      #
      # Labels are a unique consistent reference and are therefore case senstive.
      #
      def label=(label)
        @label = label.to_s.gsub(" ","_").without_superscript_characters.to_sym
      end

      def j_science=(j_science)
        j_science = j_science.to_s.gsub(" ","_")
        @j_science = Unit.use_superscript_characters? ? j_science.with_superscript_characters : j_science.without_superscript_characters
      end

      # Refresh the name, symbol and label attributes of self with respect to the
      # configuration found in Quantify.use_superscript_characters?
      #
      def refresh_attributes
        self.name      = name
        self.symbol    = symbol
        self.label     = label
        self.j_science = j_science
      end

      def factor=(factor)
        @factor = factor.to_f
      end

      # Permits a block to be used, operating on self. This is useful for modifying
      # the attributes of an already instantiated unit, especially when defining
      # units on the basis of operation on existing units for adding specific
      # (rather than derived) names or symbols, e.g.
      #
      #   (Unit.pound_force/(Unit.in**2)).configure do |unit|
      #     unit.symbol = 'psi'
      #     unit.label = 'psi'
      #     unit.name = 'pound per square inch'
      #   end
      #
      def configure(&block)
        block.call(self) if block_given?
        return self if valid?
      end

      # Similar to #configure but makes the new unit configuration the canonical
      # unit for self.label
      #
      def configure_as_canonical(&block)
        unload if loaded?
        configure(&block) if block_given?
        make_canonical
      end

      # Load an initialized Unit into the system of known units.
      #
      # If a block is given, the unit can be configured prior to loading, in a
      # similar to way to the #configure method.
      #
      def load(&block)
        block.call(self) if block_given?
        raise Exceptions::InvalidArgumentError, "A unit with the same label: #{self.name}) already exists" if loaded?
        Quantify::Unit.load(self) if valid?
        return self
      end

      # Remove from system of known units.
      def unload
        Unit.unload(self.label)
      end

      # check if an object with the same label already exists
      def loaded?
        Unit.units.has_key? @label
      end

      # Make self the canonical representation of the unit defined by self#label
      def make_canonical
        unload if loaded?
        load
      end

      # Set the canonical unit label - the unique unit identifier - to a new value
      def canonical_label=(new_label)
        unload if loaded?
        self.label = new_label
        load
      end

      def acts_as_alternative_unit=(value)
        @acts_as_alternative_unit = (value == (true||false) ? value : false)
        make_canonical
      end

      def acts_as_equivalent_unit=(value)
        @acts_as_equivalent_unit = (value == (true||false) ? value : false)
        make_canonical
      end

      # Returns the scaling factor for the unit with repsect to its SI alternative.
      #
      # For example the scaling factor for degrees celsius is 273.15, i.e. celsius
      # is a value of 273.15 greater than kelvin (but with no multiplicative factor).
      #
      def scaling
        @scaling || 0.0
      end

      def has_scaling?
        scaling != 0.0
      end

      # Describes what the unit measures/represents. This is taken from the
      # @dimensions ivar, being, ultimately an attribute of the assocaited
      # Dimensions object, e.g.
      #
      #  Unit.metre.measures                      #=> :length
      #
      #  Unit.J.measures                          #=> :energy
      #
      def measures
        @dimensions.describe
      end

      def pluralized_name
        @name.pluralize
      end
      
      # Determine if the unit represents one of the base quantities, length,
      # mass, time, temperature, etc.
      #
      def is_base_unit?
        Dimensions::BASE_QUANTITIES.map {|base| base.remove_underscores }.include? self.measures
      end

      # Determine if the unit is THE canonical SI unit for a base quantity (length,
      # mass, time, etc.). This method ignores prefixed versions of SI base units,
      # returning true only for metre, kilogram, second, Kelvin, etc.
      #
      def is_base_quantity_si_unit?
        is_si_unit? && is_base_unit? && is_benchmark_unit?
      end

      # Determine is the unit is a derived unit - that is, a unit made up of more
      # than one of the base quantities
      #
      def is_derived_unit?
        !is_base_unit?
      end

      # Determine if the unit is a prefixed unit
      def is_prefixed_unit?
        self.prefix ? true : false
      end

      # Determine if the unit is one of the units against which all other units
      # of the same physical quantity are defined. These units are almost entirely
      # equivalent to the non-prefixed, SI units, but the one exception is the
      # kilogram, which is an oddity in being THE canonical SI unit for mass, yet
      # containing a prefix. This oddity makes this method useful/necessary.
      #
      def is_benchmark_unit?
        @factor == 1.0
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

      def is_dimensionless?
        @dimensions.is_dimensionless?
      end

      # Determine if self is equivalent to another. Equivalency is based on
      # representing the same physical quantity (i.e. dimensions) and the same
      # factor and scaling values.
      #
      #  Unit.metre.is_equivalent_to? Unit.foot    #=> false
      #
      #  Unit.metre.is_equivalent_to? Unit.gram    #=> false
      #
      #  Unit.metre.is_equivalent_to? Unit.metre   #=> true
      #
      # The base_units attr of Compound units are not compared. Neither are the
      # names or symbols. This is because we want to recognise cases where units
      # derived from operations and defined as compound units (therefore having
      # compounded names and symbols) are the same as known, named units. For
      # example, if we build a unit for energy using only SI units, we want to
      # recognise this as a joule, rather than a kg m^2 s^-2, e.g.
      #
      #   (Unit.kg*Unit.m*Unit.m/Unit.s/Unit.s).is_equivalent_to? Unit.joule
      #
      #                                      #=> true
      #
      def is_equivalent_to?(other)
        [:dimensions,:factor,:scaling].all? do |attr|
          self.send(attr) == other.send(attr)
        end
      end
      alias :== :is_equivalent_to?

      # Check if unit has the identity as another, i.e. the same label. This is
      # used to determine if a unit with the same accessors already exists in
      # the module variable @@units
      #
      def has_same_identity_as?(other)
        @label == other.label && !@label.nil?
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
        other.dimensions == @dimensions
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
        @dimensions.units(nil).reject do |unit|
          unit.is_equivalent_to?(self) || !unit.acts_as_alternative_unit
        end.map(&by).to_a
      end

      # Returns the SI unit for the same physical quantity which is represented
      # by self, e.g.
      #
      def si_unit
        @dimensions.si_unit
      end

      def valid?
        return true if valid_descriptors? && valid_dimensions?
        raise Exceptions::InvalidArgumentError, "Unit definition must include a name, a symbol, a label and dimension"
      end

      def valid_descriptors?
        return true if is_dimensionless?
        #
        return false unless label.is_a?(Symbol)

        [:name, :symbol].all? do |attr|
          attribute = send(attr)
          attribute.is_a?(String) && !attribute.empty?
        end
      end

      def valid_dimensions?
        @dimensions.is_a? Dimensions
      end

      # Multiply two units together. This results in the generation of a compound
      # unit.
      #
      def multiply(other)
        options = []
        self.instance_of?(Unit::Compound) ? options += @base_units : options << self
        other.instance_of?(Unit::Compound) ? options += other.base_units : options << other
        Unit::Compound.new(*options)
      end
      alias :times :multiply
      alias :* :multiply

      # Divide one unit by another. This results in the generation of a compound
      # unit.
      #
      # In the event that the new unit represents a known unit, the non-compound
      # representation is returned (i.e. of the SI or NonSI class).
      #
      def divide(other)
        options = []
        self.instance_of?(Unit::Compound) ? options += @base_units : options << self

        if other.instance_of? Unit::Compound
          options += other.base_units.map { |base| base.index *= -1; base }
        else
          options << CompoundBaseUnit.new(other,-1)
        end
        Unit::Compound.new(*options)
      end
      alias :/ :divide

      # Raise a unit to a power. This results in the generation of a compound
      # unit, e.g. m^3.
      # 
      # In the event that the new unit represents a known unit, the non-compound
      # representation is returned (i.e. of the SI or NonSI class).
      #
      def pow(power)
        return nil if power == 0
        original_unit = self.clone
        if power > 0
          new_unit = self.clone
          (power - 1).times { new_unit *= original_unit }
        elsif power < 0
          new_unit = reciprocalize
          ((power.abs) - 1).times { new_unit /= original_unit }
        end
        return new_unit
      end
      alias :** :pow

      # Return new unit representing the reciprocal of self, i.e. 1/self
      def reciprocalize
        Unit.unity / self
      end

      # Apply a prefix to self. Returns new unit according to the prefixed version
      # of self, complete with modified name, symbol, factor, etc..
      #
      def with_prefix(name_or_symbol)
        self.class.initialize_prefixed_version(name_or_symbol,self)
      end

      # Return an array of new unit instances based upon self, together with the
      # prefixes specified by <tt>prefixes</tt>
      #
      def with_prefixes(*prefixes)
        [prefixes].map { |prefix| self.with_prefix(prefix) }
      end

      # Return a hash representation of self containing each unit attribute (i.e
      # each instance variable)
      #
      def to_hash
        hash = {}
        self.instance_variables.each do |var|
          symbol = var.to_s.gsub("@","").to_sym
          hash[symbol] = send symbol
        end
        return hash
      end

      # Enables shorthand for reciprocal of a unit, e.g.
      #
      #   unit = Unit.m
      #
      #   (1/unit).symbol                     #=> "m^-1"
      #
      def coerce(object)
        if object.kind_of?(Numeric) && object == 1
          return Unit.unity, self
        else
          raise Exceptions::InvalidArgumentError, "Cannot coerce #{self.class} into #{object.class}"
        end
      end

      private
      
      # Clone self and explicitly clone the associated Dimensions object located
      # at @dimensions.
      # 
      # This enables full or 'deep' copies of the already initialized units to be
      # retrieved and manipulated without corrupting the known unit representations.
      # (self.clone makes only a shallow copy, i.e. clones attributes but not
      # referenced objects)
      #
      def initialize_copy(source)
        super
        instance_variable_set("@dimensions", @dimensions.clone)
      end
      
      def self.block_for_prefixed_version(prefix,unit)
        return Proc.new do |new_unit| 
          new_unit.base_unit  = unit.clone
          new_unit.prefix     = prefix
          new_unit.dimensions = unit.dimensions.clone
          new_unit.name       = "#{prefix.name}#{unit.name}"
          new_unit.factor     = prefix.factor * unit.factor
          new_unit.symbol     = "#{prefix.symbol}#{unit.symbol}"
          new_unit.label      = "#{prefix.symbol}#{unit.label}"
          new_unit.j_science  = "#{prefix.symbol}#{unit.j_science}"
        end
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
      def method_missing(method, *args, &block)
        if method.to_s =~ /(to_)(.*)/ && prefix = Prefix.for($2.to_sym)
          return self.with_prefix(prefix)
        elsif method.to_s =~ /(alternatives_by_)(.*)/ && self.respond_to?($2.to_sym)
          return self.alternatives($2.to_sym)
        end
        super
      end

    end
  end
end
