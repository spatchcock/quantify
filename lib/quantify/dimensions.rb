module Quantify

  # The Dimensions class represents specfic physical quantities in
  # terms of powers of their constituent base dimensions, e.g.:
  # 
  # area = length^2
  # force = mass^1 x length^1 x time^-2
  # 
  # Each dimension object is characterised by instance variables
  # which describe the power (or index) of the respective base dimensions.
  # Dimension objects can be manipulated - multiplied, divided, raised
  # to powers, etc.
  #
  # Standard physical quantities (e.g. length, acceleration, energy)
  # are loaded into the @@dimensions class variable at runtime. These
  # can be accessed, used and manipulated for arbitrary dimensional uses.
  # 
  # Instances of Dimensions are also used as the basis for defining and
  # manipulating objects of the Unit::Base class.

  class Dimensions

    # The BASE_QUANTITIES array specifies the system of base quantities
    # upon which all Dimensions objects are defined.
    #
    # :information, :currency, :item represent tentative additions to
    # the standard set of base quantities.
    #
    # :item is intended to represent arbitrary 'things' for specifying
    # quantities such as, for example:
    #
    # 'dollars per capita' (:currency => 1, :items => -1)
    # 'trees per hectare' (:items => 1, :length => -2).
    #
    BASE_QUANTITIES = [
        :mass, :length, :time, :electric_current, :temperature,
        :luminous_intensity, :amount_of_substance, :information,
        :currency, :item]

    BASE_QUANTITIES.each do |quantity_symbol|
      define_method quantity_symbol.to_s do
        return nil unless @base_quantity_hash
        @base_quantity_hash[quantity_symbol]
      end
    end

    attr_accessor :physical_quantity

    # Class variable which holds in memory all defined (and 'loaded') quantities
    @@dimensions = []

    # Provides access the class array which holds all defined quantities
    def self.dimensions
      @@dimensions
    end

    # Returns an array of Dimensions objects representing just the base quantities,
    # i.e. length, mass, time, temperature, etc.
    #
    def self.base_dimensions
      @@dimensions.select do |dimensions|
        BASE_QUANTITIES.map { |quantity| quantity.remove_underscores }.include?(dimensions.describe)
      end
    end

    # This method allows specific, named quantities to be initialized and
    # loaded into the @@dimensions array. Quantities are specified by their
    # consituent base dimensions, but must also include a name/description,
    # i.e. 'acceleration', :force - indicated by the :physical_quantity key -
    # in order to be included in the system of known dimensions, e.g.:
    #
    #  Dimensions.load :physical_quantity => :force,
    #                  :length => 1,
    #                  :mass => 1,
    #                  :time => -2
    #
    # Standard quantities such as force, energy, mass, etc. should not need to
    # be defined as they are included in the set of quantities already defined
    # (see config.rb) and automatically loaded. These can be removed, overridden
    # or configured differently if desired.
    #
    def self.load(options)
      if options[:physical_quantity]
        @@dimensions << Dimensions.new(options)
      else
        raise Exceptions::InvalidDimensionError, "Cannot load dimensions without physical quantity description"
      end
    end

    # Remove a dimension from the system of known dimensions
    def self.unload(*unloaded_dimensions)
      [unloaded_dimensions].flatten.each do |unloaded_dimension|
        unloaded_dimension = Dimensions.for(unloaded_dimension)
        @@dimensions.delete_if { |dimension| dimension.has_same_identity_as? unloaded_dimension }
      end
    end

    # Returns an array containing the names/descriptions of all known (loaded)
    # physical quantities, e.g.:
    #
    #  Dimensions.physical_quantities     #=>    [ 'acceleration',
    #                                              'area',
    #                                              'electric Current',
    #                                               ... ]
    #
    def self.physical_quantities
      @@dimensions.map { |dimension| dimension.physical_quantity }
    end

    # Retrieve a known quantity - returns a Dimensions instance, which is a
    # clone of the initialized instance of the specified quantity. This enables
    # the object to be modified/manipulated without corrupting the representation
    # of the quantity in the @@dimensions class array.
    #
    # The required quantity name/descriptor can be specified as a symbol or a
    # string, e.g.:
    # 
    #  Dimensions.for :acceleration
    #  Dimensions.for 'luminous_flux'
    # 
    # These can be shortened to, e.g. Dimensions.acceleration by virtue of the 
    # #method_missing class method (below)
    #
    def self.for(name)
      return name if name.is_a? Dimensions
      if (name.is_a?(String) || name.is_a?(Symbol))
        name = name.remove_underscores.downcase
        if quantity = @@dimensions.find { |quantity| quantity.physical_quantity == name }
          return quantity.clone
        else
          raise Exceptions::InvalidArgumentError, "Physical quantity not known: #{name.inspect}"
        end
      else
        raise Exceptions::InvalidArgumentError, "Argument must be a Symbol or String"
      end
    end

    # Syntactic sugar for defining the known quantities. This method simply
    # evaluates code within the context of the Dimensions class, enabling
    # the required quantities to be loaded at runtime, e.g.
    #
    #  Dimensions.configure do
    #
    #    load :physical_quantity => :length, :length => 1
    #    load :physical_quantity => :area, :length => 2
    #    load :physical_quantity => :power, :mass => 1, :length => 2, :time => -3
    #
    #  end
    #
    def self.configure(&block)
      self.class_eval(&block) if block
    end

    # Provides a shorthand for retrieving known quantities, e.g.:
    #
    #  Dimensions.force
    #
    # is equivalent to
    #
    #  Dimensions.for :force
    #
    # Both variants return a clone of the initialized dimensional representation
    # of the specified physical quantity (i.e. force).
    #
    def self.method_missing(method, *args, &block)
      if dimensions = self.for(method)
        return dimensions
      end
      super
    end


    # Initialize a new Dimension object.
    #
    # The options argument is a hash which represents the base dimensions that
    # define the physical quantity. Each key-value pair should consist of a key
    # included in the BASE_QUANTITIES array, and a value which represents the
    # index/power of that base quantity.
    #
    # In addition, a name or description of the physical quantity can be
    # specified (i.e. 'acceleration', 'electric_current'). This is optional for
    # creating a new Dimensions instance, but required if that object is to be
    # loaded into the @@dimensions class array. e.g.:
    #
    #  Dimensions.new :physical_quantity => :density,
    #                 :mass => 1,
    #                 :length => -3
    #
    def initialize(options={ })
      @base_quantity_hash = { }
      init_base_quantities(options)
      describe
    end

    # Load an already instantiated Dimensions object into the @@dimensions class
    # array, from which it will be accessible as a universal representation of
    # that physical quantity.
    #
    # Object must include a non-nil physical_quantity, i.e. a name or
    # description of the physical quantity represented.
    #
    def load
      if describe && !loaded?
        @@dimensions << self
      elsif describe
        raise Exceptions::InvalidDimensionError, "A dimension instance with the same physical quantity already exists"
      else
        raise Exceptions::InvalidDimensionError, "Cannot load dimensions without physical quantity description"
      end
    end

    def loaded?
      Dimensions.dimensions.any? { |quantity| self.has_same_identity_as? quantity }
    end

    # Remove from system of known units.
    def unload
      Dimensions.unload(self.physical_quantity)
    end

    def has_same_identity_as?(other)
      physical_quantity == other.physical_quantity && !physical_quantity.nil?
    end

    # Return a description of what physical quantity self represents. If no
    # value is found in the physical_quantity, the task is
    # delegated to the #get_description method.
    #
    def describe
      physical_quantity or get_description
    end

    # Searches the system of known physical quantities (@@dimensions class
    # array) looking for any which match self in terms of the configuration of
    # base dimensions, i.e. an object which dimensionally represents the same
    # thing.
    #
    # If found, the name/description of that quantity is assigned to the
    # @physical_quantity attribute of self.
    #
    # This method is useful in cases where Dimensions instances are manipulated
    # using operators (e.g. multiply, divide, power, reciprocal), resulting in
    # a change to the configuration of base dimensions (perhaps as a new instance).
    # This method tries to find a description of the new quantity.
    #
    # If none is found, self.physical_quantity is set to nil.
    #
    def get_description
      similar = @@dimensions.find { |quantity| quantity == self }
      @physical_quantity = similar.nil? ? nil : similar.physical_quantity
    end

    # Returns an array containing the known units which represent the physical
    # quantity described by self
    #
    # If no argument is given, the array holds instances of Unit::Base (or
    # subclasses) which represent each unit. Alternatively only the names or
    # symbols of each unit can be returned by providing the appropriate unit
    # attribute as a symbolized argument, e.g.
    #
    #   Dimensions.energy.units             #=> [ #<Quantify::Dimensions: .. >,
    #                                             #<Quantify::Dimensions: .. >,
    #                                             ... ]
    #
    #   Dimensions.mass.units :name         #=> [ 'kilogram', 'ounce',
    #                                             'pound', ... ]
    #
    #   Dimensions.length.units :symbol     #=> [ 'm', 'ft', 'yd', ... ]
    #
    def units(by=nil)
      Unit.units.values.select { |unit| unit.dimensions == self }.map(&by).to_a
    end

    # Returns the SI unit for the physical quantity described by self.
    #
    # Plane/solid angle are special cases which are dimensionless units, and so
    # are handled explicitly. Otherwise, the si base units for each of the base
    # dimensions of self are indentified and the corresponding compound unit is
    # derived. If this new unit is the same as a known (SI derived) unit, the
    # known unit is returned.
    #
    #   Dimensions.energy.units                  #=> #<Quantify::Dimensions: .. >
    #
    #   Dimensions.energy.si_unit.name           #=> 'joule'
    #
    #   Dimensions.kinematic_viscosity.si_unit.name
    #
    #                                            #=> 'metre squared per second'
    #
    def si_unit
      return Unit.steridian if describe == 'solid angle'
      return Unit.radian    if describe == 'plane angle'

      val = si_base_units.inject(Unit.unity) do |compound,unit|
        compound * unit
      end
      val = val.or_equivalent
      val
    # rescue
    #   return nil
    end

    # Returns an array representing the base SI units for the physical quantity
    # described by self
    #
    # If no argument is given, the array holds instances of Unit::Base (or
    # subclasses) which represent each base unit. Alternatively only the names
    # or symbols of each unit can be returned by providing the appropriate unit
    # attribute as a symbolized argument, e.g.
    #
    #   Dimensions.energy.si_base_units       #=> [ #<Quantify::Unit: .. >,
    #                                               #<Quantify::Unit: .. >,
    #                                               ... ]
    #
    #   Dimensions.energy.si_base_units :name
    #
    #                                         #=> [ "metre squared",
    #                                               "per second squared",
    #                                               "kilogram"]    #
    #
    #   Dimensions.force.units :symbol        #=> [ "m", "s^-2", "kg"]
    #
    def si_base_units(by=nil)
      val = self.to_hash.map do |dimension, index|

        Unit.base_quantity_si_units.select do |unit|

          unit.measures == dimension.remove_underscores
        end.first.clone ** index
      end.map(&by)
      val.to_a
    end

    # Compares the base quantities of two Dimensions objects and returns true if
    # they are the same. This indicates that the two objects represent the same
    # physical quantity (irrespective of their names - @physical_quantity - being
    # similar, different, or absent.
    #
    def ==(other)
      self.to_hash == other.to_hash
    end

    # Returns true if the physical quantity that self represents is known
    def is_known?
      describe ? true : false
    end

    # Returns true if self is a dimensionless quantity
    def is_dimensionless?
      physical_quantity=="dimensionless" || @base_quantity_hash.empty?
    end

    # Returns true if self represents one of the base quantities (i.e. length,
    # mass, time, etc.)
    def is_base?
      base_quantities.size == 1 &&
          @base_quantity_hash[base_quantities.first] == 1 ? true : false
    end

    # Method for identifying quantities which are 'specific' quantities, i.e
    # quantities which represent a quantity of something *per unit mass*
    #
    def is_specific_quantity?
      denominator_quantities == [:mass]
    end

    # Method for identifying quantities which are 'molar' quantities, i.e
    # quantities which represent a quantity of something *per mole*
    #
    def is_molar_quantity?
      denominator_quantities == [:amount_of_substance]
    end


    # Multiplies self by another Dimensions object, returning self with an
    # updated configuration of dimensions. Since this is likely to have resulted
    # in the representation of a different physical quantity than was originally
    # represented, the #get_description method is invoked to attempt to find a
    # suitable description.
    #
    def multiply!(other)
      init_base_quantities(other.to_hash)
      get_description
      return self
    end

    # Similar to #multiply! but returns a new Dimensions instance representing
    # the physical quantity which results from the multiplication.
    #
    def multiply(other)
      Dimensions.new(self.to_hash).multiply! other
    end

    alias :times :multiply
    alias :* :multiply

    # Similar to #multiply! but performs a division of self by the specified
    # Dimensions object.
    #
    def divide!(other)
      init_base_quantities(other.reciprocalize.to_hash)
      get_description
      return self
    end

    # Similar to #divide! but returns a new Dimensions instance representing
    # the physical quantity which results from the division.
    #
    def divide(other)
      Dimensions.new(self.to_hash).divide! other
    end

    alias :/ :divide

    # Raises self to the power provided. As with multiply and divide, the
    # #get_description method is invoked to attempt to find a suitable
    # description for the new quantity represented.
    #
    def pow!(power)
      make_dimensionless if power == 0
      return self if power == 1
      if power < 0
        self.reciprocalize!
        power *= -1
      end
      original_dimensions = self.clone
      (power - 1).times { self.multiply!(original_dimensions) }
      get_description
      return self
    end

    # Similar to #pow! but returns a new Dimensions instance representing
    # the physical quantity which results from the raised power.
    #
    def pow(power)
      Dimensions.new(self.to_hash).pow!(power)
    end
    alias :** :pow

    # Inverts self, returning a representation of 1/self. This is equivalent to
    # raising to the power -1. The #get_description method is invoked to attempt
    # to find a suitable description for the new quantity represented.
    #
    def reciprocalize!
      base_quantities.each do |variable|
        new_value = @base_quantity_hash[variable] * -1
        @base_quantity_hash[variable] = new_value
      end
      get_description
      return self
    end

    # Similar to #reciprocalize! but returns a new Dimensions instance representing
    # the physical quantity which results from the inversion.
    #
    def reciprocalize
      Dimensions.new(self.to_hash).reciprocalize!
    end

    protected

    # Returns an array containing the names of the instance variables which
    # represent the base quantities of self. This enables various operations to
    # be performed on these variables without touching the physical_quantity
    # variable.
    #
    def base_quantities
      @base_quantity_hash.keys
    end

    # Just the base quantities which have positive indices
    def numerator_quantities
      base_quantities.select { |key| @base_quantity_hash[key] > 0 }
    end

    # Just the base quantities which have negative indices
    def denominator_quantities
      base_quantities.select { |key| @base_quantity_hash[key] < 0 }
    end

    # Returns a hash representation of the base dimensions of self. This is used
    # in various operations and is useful for instantiating new objects with
    # the same base dimensions.
    #
    def to_hash
      @base_quantity_hash
    end

    # Method for initializing the base quantities of self.
    #
    # Where base quantities are already defined, the new indices are added to
    # the existing ones. This represents the multiplication of base quantities
    # (multiplication of similar quantities involves the addition of their
    # powers).
    #
    # This method is therefore used in the multiplication of Dimensions objects,
    # but also in divisions and raising of powers following other operations.
    #
    def init_base_quantities(options = { })
      if options.has_key?(:physical_quantity)
        @physical_quantity = options.delete(:physical_quantity)
        @physical_quantity = @physical_quantity.remove_underscores.downcase if @physical_quantity
      end
      options.each_pair do |base_quantity, index|
        base_quantity = base_quantity.to_s.downcase.to_sym
        unless index.is_a?(Integer) && BASE_QUANTITIES.include?(base_quantity)
          raise Exceptions::InvalidDimensionError, "An invalid base quantity was specified (#{base_quantity})"
        end
        if @base_quantity_hash[base_quantity] == nil
          @base_quantity_hash[base_quantity] = index
        else
          new_index = @base_quantity_hash[base_quantity] + index
          if new_index == 0
            @base_quantity_hash.delete(base_quantity)
          else
            @base_quantity_hash[base_quantity] = new_index
          end
        end
      end

      # Make object represent a dimensionless quantity.
      def make_dimensionless
        @base_quantity_hash = { physical_quantity: 'dimensionless' }
      end

    end
  end
end
