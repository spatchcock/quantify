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
      unit = Unit.for unit
      other_unit = Unit.for other_unit
      unless unit.is_alternative_for? other_unit
        raise InvalidUnitError, "Units do not represent the same physical quantity"
      end
      new_unit = (unit / other_unit)
      value = 1/new_unit.factor
      Quantity.new(value, new_unit)
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
    # based on the initialized Unit for :metre and Prefix :centi.
    #
    def self.for(name_symbol_label_or_object)
      return name_symbol_label_or_object.deep_clone if name_symbol_label_or_object.is_a? Unit::Base
      name_symbol_or_label = name_symbol_label_or_object
      unless name_symbol_or_label.is_a? String or name_symbol_or_label.is_a? Symbol
        raise InvalidArgumentError, "Argument must be a Symbol or String"
      end
      if unit = Unit.match(name_symbol_or_label)
        return unit
      end
      if unit = Unit.parse(name_symbol_or_label)
        return unit
      end
      raise InvalidArgumentError, "Unit not known: #{name_symbol_or_label}"
    end

    # Parse complex strings into unit.
    #
    def self.parse(string)
      string = string.standardize
      if string.scan(/(\/|per)/).size > 1
        raise InvalidArgumentError, "Malformed unit: multiple uses of '/' or 'per'"
      end

      units = []
      numerator, per, denominator = string.split(/(\/|per)/)
      units += Unit.parse_numerator_units(numerator)
      units += Unit.parse_denominator_units(denominator) unless denominator.nil?
      if units.size == 1 and units.first.index == 1
        return units.first.unit
      else
        return Unit::Compound.new(*units)
      end
    end

    def self.match(name_symbol_or_label)
      return name_symbol_or_label.deep_clone if name_symbol_or_label.is_a? Unit::Base
      Unit.match_known_unit_or_prefixed_variant(:label, name_symbol_or_label) or
      Unit.match_known_unit_or_prefixed_variant(:name, name_symbol_or_label) or
      Unit.match_known_unit_or_prefixed_variant(:symbol, name_symbol_or_label)
    end

    protected

    def self.match_known_unit_or_prefixed_variant(attribute, string_or_symbol)
      Unit.match_known_unit(attribute, string_or_symbol) or
        Unit.match_prefixed_variant(attribute, string_or_symbol)
    end

    def self.match_known_unit(attribute, string_or_symbol)
      string_or_symbol = Unit.format_unit_attribute(attribute, string_or_symbol)
      unit = @units.find { |unit| unit.send(attribute) == string_or_symbol }
      return unit.deep_clone rescue nil
    end

    def self.match_prefixed_variant(attribute, string_or_symbol)
      string_or_symbol = Unit.format_unit_attribute(attribute, string_or_symbol)
      if string_or_symbol =~ /\A(#{Prefix.si_prefixes.map(&attribute).join("|")})(#{Unit.si_non_prefixed_units.map(&attribute).join("|")})\z/ or
          string_or_symbol =~ /\A(#{Prefix.non_si_prefixes.map(&attribute).join("|")})(#{Unit.non_si_non_prefixed_units.map(&attribute).join("|")})\z/
        return Unit.for($2).with_prefix($1).deep_clone
      end
      return nil
    end

    # Standardizes query strings or symbols into canonical form for unit names,
    # symbols and labels
    #
    def self.format_unit_attribute(attribute, string_or_symbol)
      string_or_symbol = case attribute
        when :symbol then string_or_symbol.standardize
        when :name then string_or_symbol.standardize.singularize.downcase
        else string_or_symbol.to_s
      end
    end
    
    def self.parse_unit_and_index(string)
      string.scan(/([^0-9\^]+)\^?([\d\.-]*)?/i)
      index = ($2.nil? or $2.empty? ? 1 : $2.to_i)
      CompoundBaseUnit.new($1.to_s, index)
    end

    def self.parse_numerator_units(string)
      # If no middot then names parsed by whitespace
      # Need to consider multi word unit names
      num_units = ( string =~ /·/ ? string.split("·") : string.split(" ") )
      num_units.map! do |substring|
        Unit.parse_unit_and_index(substring)
      end
    end

    def self.parse_denominator_units(string)
      Unit.parse_numerator_units(string).map do |unit|
        unit.index *= -1
        unit
      end
    end

    # This can be replicated by method missing approach, but explicit method provided
    # given importance in #match (and #for) methods regexen
    #
    def self.si_non_prefixed_units
      @units.select {|unit| unit.is_si_unit? and not unit.is_prefixed_unit? }
    end

    # This can be replicated by method missing approach, but explicit method provided
    # given importance in #match (and #for) methods regexen
    #
    def self.non_si_non_prefixed_units
      @units.select {|unit| unit.is_non_si_unit? and not unit.is_prefixed_unit? }
    end

    def self.multi_word_unit_names
      @units.map(&:name).compact.select {|name| name.word_count > 1 }
    end

    def self.multi_word_unit_pluralized_names
      multi_word_unit_names.map(&:pluralize)
    end

    def self.multi_word_unit_symbols
      @units.map(&:symbol).compact.select {|symbol| symbol.word_count > 1 }
    end

    # Provides syntactic sugar for accessing units via the #for method.
    # Specify:
    #
    #  Unit.degree_celsius
    #
    # rather than Unit.for :degree_celsius
    #
    def self.method_missing(method, *args, &block)
      if method.to_s =~ /((si|non_si|compound)_)?(non_(prefixed)_)?((base|derived|benchmark)_)?units(_by_(name|symbol|label))?/
        if $2 or $4 or $6
          conditions = []
          conditions << "unit.is_#{$2}_unit?" if $2
          conditions << "!unit.is_prefixed_unit?" if $4
          conditions << "unit.is_#{$6}_unit?" if $6
          units = Unit.units.select { |unit| instance_eval(conditions.join(" and ")) }
        else
          units = Unit.units
        end
        return_format = ( $8 ? $8.to_sym : nil )
        units.map(&return_format)
      elsif unit = self.for(method)
        return unit
      else
        super
      end
    end

  end
end
