#! usr/bin/ruby

module Quantify
  module Unit

    # The Unit module contains functionality for defining and handling
    # representations of physical units.
    #
    # All units are defined using the Unit::SI and Unit::NonSI classes, both of
    # which inherit from Unit::Base.
    #
    # New units can be defined to represent whatever is required. However a
    # system of known units is stored in the Unit module instance variable
    # @units, accessible using Unit.units. These known units can be configured
    # to represent which ever units are required. The Unit module will handle
    # any combinations of units and prefixes according to the known units and
    # prefixes specified in config.rb. New units can be defined (with or without
    # prefixes) at any time and either used in place or loaded into the known
    # system.

    # Make the @units instance array readable
    class << self
      attr_reader :units
    end

    # Instance variable containing system of known units
    @units = []

    # Load a new unit into they system of known units
    def self.load(unit)
      @units << unit if unit.is_a? Unit::Base
    end

    # Retrieve an object representing the specified unit.
    #
    # Argument can be the unit name, symbol or JScience label and provided as
    # a string or a symbol, e.g.
    #
    #   Unit.for :metre
    #
    #   Unit.for 'kilogram'
    #
    # This can be shortened to, for example, Unit.metre by virtue of the
    # #method_missing method (see below)
    #
    # This method will recognise valid combinations of known units and prefixes,
    # irrespective of whether the prefixed unit has been initialized into the
    # system of known units in it's own right. For example,
    #
    #   Unit.centimetre ... or, alternatively ... Unit.cm
    #
    # will return a Unit::SI object with attributes representing a centimetre
    # based on the initialized Unit for :metre and Prefix :centi. Note: this
    # method is designed to only allow SI units to use SI prefixes, and NonSI
    # units to use only NonSI prefixes
    #
    def self.for(name_symbol_or_label)
      if name_symbol_or_label.is_a? String or
         name_symbol_or_label.is_a? Symbol
        if unit = @units.find do |unit|
            unit.label == name_symbol_or_label or
            unit.name == name_symbol_or_label.standardize.singularize.downcase or
            unit.symbol == name_symbol_or_label.standardize
          end

          return unit.deep_clone
        elsif name_symbol_or_label =~ /\A(#{Prefix.si_symbols.join("|")})(#{Unit.si_labels.join("|")})\z/ or
          name_symbol_or_label =~ /\A(#{Prefix.non_si_symbols.join("|")})(#{Unit.non_si_labels.join("|")})\z/ or
          name_symbol_or_label.standardize.singularize.downcase =~ /\A(#{Prefix.si_names.join("|")})(#{Unit.si_names.join("|")})\z/ or
          name_symbol_or_label.standardize.singularize.downcase =~ /\A(#{Prefix.non_si_names.join("|")})(#{Unit.non_si_names.join("|")})\z/ or
          name_symbol_or_label.standardize =~ /\A(#{Prefix.si_symbols.join("|")})(#{Unit.si_symbols.join("|")})\z/ or
          name_symbol_or_label.standardize =~ /\A(#{Prefix.non_si_symbols.join("|")})(#{Unit.non_si_symbols.join("|")})\z/
          
          return Unit.for($2).with_prefix($1).deep_clone
        else
          raise InvalidArgumentError, "Unit not known: #{name_symbol_or_label}"
        end
      else
        raise InvalidArgumentError, "Argument must be a Symbol or String"
      end
    end

    # Parse complex strings into compound unit.
    #
    # Method currently only accepts unit symbols using "^" syntax for powers.
    #
    # Intention is to permit unit names, together with syntax such as "/" and
    # "per" for 'per' quantities
    #
    def self.parse(string)
      units = string.split(" ").map do |substring|
        substring.scan(/([^0-9\^]+)\^?([\d\.-]*)?/i)
        { :unit => $1.to_s, :index => ( $2.nil? or $2.empty? ? nil : $2.to_i ) }
      end

      if units.size == 1 and units[0][:index].nil?
        return Unit.for units[0][:unit]
      else
        return Unit::Compound.new(units)
      end
    end

    # Returns an instance of the class Quantity which represents the ratio of two
    # units. For example, the ratio of miles to kilometers is 1.609355, or there
    # are 1.609355 km in 1 mile.
    #
    #   ratio = Unit.ratio :km, :mi         #=> <Quantify::Quantity:0xj9ab878a7>
    #
    #   ratio.to_s :name                    #=> "1.609344 kilometres per mile"
    #
    # In other words the quantity represents the definition of one unit in terms
    # of the other.
    #
    def self.ratio(unit,other_unit)
      unit = Unit.for unit unless unit.is_a? Unit::Base
      other_unit = Unit.for other_unit unless other_unit.is_a? Unit::Base
      unless unit.is_alternative_for? other_unit
        raise InvalidUnitError, "Units do not represent the same physical quantity"
      end
      new_unit = (unit / other_unit)
      value = 1/new_unit.factor
      Quantity.new value, new_unit
    end

    # Provides syntactic sugar for accessing units. Specify:
    #
    #  Unit.degree_celsius
    #
    # rather than Unit.for :degree_celsius
    #
    def self.method_missing(method, *args, &block)
      if unit = self.for(method)
        return unit
      else
        raise NoMethodError, "Undefined method `#{method}` for #{self}:#{self.class}"
      end
    end

    
    # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #


    # The following represent some of the various useful ways in which the known
    # system of units might want to be searched and retrieved.
    #
    # These can probably be tidied up using some dynamic method building at some
    # stage.
    #


    # Returns an array containing objects representing all known SI units. By
    # default, only the standard (non-prefixed) units are returned - e.g. m, s,
    # J, N, W...
    #
    # If <true> is passed as an argument all multiples and divisors are returned
    # - e.g. cm, dm, m, km, Mm,... J, kJ, MJ, GJ,... W, kW, MW,...
    #
    def self.si_units(include_multiples=false)
      units = @units.select do |unit|
        if block_given?
          unit.is_si_unit? and
          yield(unit)
        else
          unit.is_si_unit?
        end
      end
      return units if include_multiples
      units.select do |unit|
        unit.is_benchmark_unit?
      end
    end

    # Just the SI base units (metre, second, kelvin)
    def self.si_base_units(include_multiples=false)
      self.si_units(include_multiples) { |unit| unit.is_base_unit? }
    end

    # Just the SI derived units (joule, newton, watt, etc.)
    def self.si_derived_units(include_multiples=false)
      self.si_units(include_multiples) { |unit| unit.is_derived_unit? }
    end

    # Returns an array containing objects representing all known non-SI units
    def self.non_si_units
      @units.select { |unit| unit.is_non_si_unit? }
    end

    # Returns an array containing objects representing all known compound units
    def self.compound_units
      @units.select { |unit| unit.is_compound_unit? }
    end

    # Returns an array containing the names of all known units
    def self.names
      @units.map { |unit| unit.name }
    end

    # Returns an array containing the names of all known SI units
    def self.si_names
      si_units.map { |unit| unit.name }
    end

    # Returns an array containing the names of all known non-SI units
    def self.non_si_names
      non_si_units.map { |unit| unit.name }
    end

    # Returns an array containing the names of all known compound units
    def self.compound_unit_names
      compound_units.map { |unit| unit.name }
    end

    # Returns an array containing the symbols of all known units
    def self.symbols
      @units.map { |unit| unit.symbol }
    end

    # Returns an array containing the symbols of all known SI units
    def self.si_symbols
      si_units.map { |unit| unit.symbol }
    end

    # Returns an array containing the symbols of all known non-SI units
    def self.non_si_symbols
      non_si_units.map { |unit| unit.symbol }
    end

    # Returns an array containing the symbols of all known compound units
    def self.compound_unit_symbols
      compound_units.map { |unit| unit.symbol }
    end

    # Returns an array containing the JScience labels of all known units
    def self.labels
      @units.map { |unit| unit.label }
    end

    # Returns an array containing the JScience labels of all known SI units
    def self.si_labels
      si_units.map { |unit| unit.label }
    end

    # Returns an array containing the JScience labels of all known non-SI units
    def self.non_si_labels
      non_si_units.map { |unit| unit.label }
    end

    # Returns an array containing the JScience labels of all known compound units
    def self.compound_unit_labels
      compound_units.map { |unit| unit.label }
    end

  end
end
