#! usr/bin/ruby

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
  # can be accessed, used and manipulated for arbitrary dimensional uses
  # and are also used to define and create objects of the Unit::Base class.

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
      :currency, :item ]

    # Class variable which holds in memory defined quantities
    @@dimensions = []

    # This method allows specific, named quantities to initialized and
    # loaded into the @@dimensions array. Quantities are specified by their
    # consituent base dimensions, but also must include a name/description,
    # i.e. 'acceleration', :force, andindicated by the :physical_quantity key,
    # in order to be included in the system of known dimensions, e.g.:
    #
    #  Dimensions.load :physical_quantity => :force,
    #                  :length => 1,
    #                  :mass => 1,
    #                  :time => -2
    #
    # Standard quantities such as force, energy, mass, etc. should not need to
    # be defined as they are included in the set of quantities already defined
    # (below) and automatically loaded. These can, in principle, be removed,
    # overridden or configured differently if required.
    #
    def self.load(options)
      if options[:physical_quantity]
        @@dimensions << Dimensions.new(options)
      else
        raise InvalidDimensionError, "Cannot load dimensions without physical quantity description"
      end
    end

    # Provides access the class array which holds all defined quantities
    def self.dimensions
      @@dimensions
    end

    # Returns an array containing the names/descriptions of all known (loaded)
    # physical quantities, e.g.:
    #
    #  Dimensions.physical_quantities     #=>    [ 'acceleration',
    #                                              'area',
    #                                              'electric_current',
    #                                               ... ]
    #
    def self.physical_quantities
      @@dimensions.map { |quantity| quantity.physical_quantity.to_s }
    end

    # Retrieve a known quantity - returns a Dimensions instance, which is a
    # clone of the initialized instance of the specified quantity. This enables
    # the object to be modified/manipulated without corrupting the representation
    # of the quantity in the @@dimensions class array.
    #
    # The required quantity name/desriptor can be specified as a symbol or a
    # string, e.g.:
    # 
    #  Dimensions.for :acceleration
    #  Dimensions.for 'luminous_flux'
    # 
    # These can be shortened to, e.g. Dimensions.acceleration by virtue of the 
    # #method_missing class method (below)
    #
    def self.for(name)
      if name.is_a? String or name.is_a? Symbol
        if quantity = @@dimensions.find do |quantity|
            quantity.physical_quantity == name.standardize
          end
          return quantity.clone
        else
          raise InvalidArgumentError, "Physical quantity not known: #{name}"
        end
      else
        raise InvalidArgumentError, "Argument must be a Symbol or String"
      end
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
      else
        raise NoMethodError, "Undefined method `#{method}` for #{self}:#{self.class}"
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
    def self.configure &block
      class_eval &block
    end

    # Make all base quantities readable attributes of each instance
    BASE_QUANTITIES.each { |quantity| attr_reader quantity }

    # Make the name/description of the physical quantity represented by the
    # Dimensions object and accesible attribute.
    #
    attr_accessor :physical_quantity

    # Initialize a new Dimension object.
    #
    # The options argument is a hash which represents the base dimensions that
    # define the physical quantity. Each key-value pair should consist of a key
    # included in the BASE_QUANTITIES array, and a value which represents the
    # index/power of that base quantity.
    #
    # In addition, a name or description of the physical quantity can be
    # specified (i.e. 'acceleration', 'electric_current'). This is optinal for
    # creating a new Dimensions instance, but required if that object is to be
    # loaded into the @@dimensions class array. e.g.:
    #
    #  Dimensions.new :physical_quantity => :density,
    #                 :mass => 1,
    #                 :length => -3
    #
    def initialize(options={})
      if options.has_key?(:physical_quantity)
        @physical_quantity = options.delete(:physical_quantity).standardize
      end
      enumerate_base_quantities(options)
      describe
    end

    # Load an already instantiated Dimensions object into the @@dimensions class
    # array, from which it will be provide a universal representation of that
    # physical quantity.
    #
    # Object must include a non-nil @physical_quantity attribute, i.e. a name or
    # description of the physical quantity represented.
    #
    def load
      if describe
        @@dimensions << self
      else
        raise InvalidDimensionError, "Cannot load dimensions without physical quantity description"
      end
    end

    # Return a description of what physical quantity self represents. If no
    # value is found in the @physical_quantity instance variable, the task is
    # delegated to the #get_description method.
    #
    def describe
      @physical_quantity or get_description
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
    # a change to the configuration of base dimensions. This method tries to
    # find a description of the new quantity.
    #
    # If none is found, self.physical_quantity is set to nil.
    #
    def get_description
      similar = @@dimensions.find { |quantity| quantity == self }
      @physical_quantity = (similar.nil? ? nil : similar.physical_quantity )
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
      return true if describe
      return false
    end

    # Returns true if self is a dimensionless quantity
    def is_dimensionless?
      return true if base_quantities.empty?
      return false
    end

    # Returns true if self represents one of the base quantities (i.e. length,
    # mass, time, etc.)
    def is_base?
      return true if base_quantities.size == 1 and
        self.instance_variable_get(base_quantities.first) == 1
      return false
    end

    # Method for identifying quantities which are 'specific' quantities, i.e
    # quantities which represent a quantity of something *per unit mass*
    #
    # This is intended to be used eventually as part of a richer system for
    # recognising and naming unknown quantities
    #
    def is_specific_quantity?
      denominator_quantities == ["@mass"]
    end

    # Method for identifying quantities which are 'molar' quantities, i.e
    # quantities which represent a quantity of something *per mole*
    #
    # This is intended to be used eventually as part of a richer system for
    # recognising and naming unknown quantities
    #
    def is_molar_quantity?
      denominator_quantities == ["@amount_of_substance"]
    end


    # Multiplies self by another Dimensions object, returning self with an
    # updated configuration of dimensions. Since this is likely to have resulted
    # in the representation of a different physical quantity than was originally
    # represented, the #get_description method is invoked to attempt to find a
    # suitable description.
    #
    def multiply!(other)
      enumerate_base_quantities(other.to_hash)
      get_description
      return self
    end

    # Similar to #multiply! but returns a new Dimensions instance representing
    # the physical quantity which results from the multiplication.
    #
    def multiply(other)
      new_dimensions = Dimensions.new(self.to_hash)
      new_dimensions.multiply! other
      return new_dimensions
    end

    # Similar to #multiply! but performs a division of self by the specified
    # Dimensions object.
    #
    def divide!(other)
      enumerate_base_quantities(other.reciprocalize.to_hash)
      get_description
      return self
    end

    # Similar to #divide! but returns a new Dimensions instance representing
    # the physical quantity which results from the division.
    #
    def divide(other)
      new_dimensions = Dimensions.new(self.to_hash)
      new_dimensions.divide! other
      return new_dimensions
    end

    # Raises self to the power provided. As with multiply and divide, the
    # #get_description method is invoked to attempt to find a suitable
    # description for the new quantity represented.
    #
    def pow!(power)
      make_dimensionless if power == 0
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
      new_dimensions = Dimensions.new(self.to_hash)
      new_dimensions.pow!(power)
      return new_dimensions
    end

    # Inverts self, returning a representation of 1/self. This is equivalent to
    # raising to the power -1. The #get_description method is invoked to attempt
    # to find a suitable description for the new quantity represented.
    #
    def reciprocalize!
      base_quantities.each do |variable|
        new_value = self.instance_variable_get(variable) * -1
        self.instance_variable_set(variable, new_value)
      end
      get_description
      return self
    end

    # Similar to #reciprocalize! but returns a new Dimensions instance representing
    # the physical quantity which results from the inversion.
    #
    def reciprocalize
      new_dimensions = Dimensions.new(self.to_hash)
      return new_dimensions.reciprocalize!
    end

    alias :times :multiply
    alias :* :multiply
    alias :/ :divide
    alias :** :pow

    protected

    # Returns an array containing the names of the instance variables which
    # represent the base quantities of self. This enables various operations to
    # be performed on these variables without touching the @physical_quantity
    # variable.
    #
    def base_quantities
      quantities = self.instance_variables
      quantities.delete("@physical_quantity")
      return quantities
    end

    def numerator_quantities
      base_quantities.select { |quantity| self.instance_variable_get(quantity) > 0 }
    end

    def denominator_quantities
      base_quantities.select { |quantity| self.instance_variable_get(quantity) < 0 }
    end

    # Returns a hash representation of the base dimensions of self. This is used
    # in various operations and is useful for instantiating new objects with
    # the same base dimensions.
    #
    def to_hash
      hash = {}
      base_quantities.each do |variable|
        hash[variable.gsub("@","").to_sym] = self.instance_variable_get(variable)
      end
      return hash
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
    def enumerate_base_quantities(options)
      options.each_pair do |base_quantity,index|
        unless index.is_a? Integer and
            BASE_QUANTITIES.include? base_quantity.standardize!
          raise InvalidDimensionError,
            "An invalid base quantity was specified (#{base_quantity})"
        end
        variable = "@#{base_quantity.to_s.downcase}"
        if self.instance_variable_defined? variable
          new_index = self.instance_variable_get(variable) + index
          if new_index == 0
            remove_instance_variable(variable)
          else
            self.instance_variable_set(variable, new_index)
          end
        else
          self.instance_variable_set(variable, index)
        end
      end
    end

    # Make object represent a dimensionless quantity.
    def make_dimensionless
      self.physical_quantity = :dimensionless
      base_quantities.each do |var|
        remove_instance_variable(var)
      end
    end

    

  end
end
