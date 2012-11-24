# encoding: UTF-8

module Quantify
  module Unit

    extend ExtendedMethods
    
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
    
    NUMBER_REGEX            = /([\d\s.,]+)/i
      
    UNIT_DENOMINATOR_REGEX  = /(\/|per)/i
      
    ORDINAL_SUFFIXES_REGEX  = /(st|nd|rd|th)\b/i
        
    UNIT_PREFIX_TERMS_REGEX = /\A(square|cubic)\b/i
    
    INDEX_REGEX             = /\^?([\d\.-]*)/

    WORD_WITH_INDEX_REGEX   = /([^\d\s.,\^]+)#{INDEX_REGEX}?/i

    UNIT_SUFFIX_TERMS_REGEX = /\A(squared|cubed|to the \d+(#{ORDINAL_SUFFIXES_REGEX}) power)\b/i
    
    QUANTITY_REGEX          = /#{Unit::NUMBER_REGEX}(#{Quantify::Unit::WORD_WITH_INDEX_REGEX})/i
    
    
    class << self
      attr_reader :units, :unit_names, :unit_symbols
      attr_reader :prefixed_units, :prefixed_unit_names, :prefixed_unit_symbols
    end

    # Instance variable containing system of known units
    @units        = {}
    @unit_names   = {}
    @unit_symbols = {}

    def self.configure(&block)
      self.class_eval(&block) if block
    end

    # Set the default string which is used to delimit numerator and denominator
    # strings in compound unit symbol representations. Defaults to "/".
    #
    def self.symbol_denominator_delimiter=(string)
      @symbol_denominator_delimiter = string
      refresh_all_unit_attributes!
    end

    def self.symbol_denominator_delimiter
      @symbol_denominator_delimiter ||= "/"
    end

    # Set the default string which is used to delimit unit symbol strings in
    # compound unit symbol representations. Defaults to " ".
    #
    def self.symbol_unit_delimiter=(string)
      @symbol_unit_delimiter = string
      refresh_all_unit_attributes!
    end

    def self.symbol_unit_delimiter
      @symbol_unit_delimiter ||= " "
    end

    # Specify whether parentheses should be used to group multiple units in
    # compound unit symbol representations. Set either <tt>true</tt> (e.g.
    # "kg/(t km)") or <tt>false</tt> (e.g. "kg/t km"). Defaults to <tt>false</tt>
    #
    def self.use_symbol_parentheses=(true_or_false)
      @use_symbol_parentheses = true_or_false
      refresh_all_unit_attributes!
    end

    # Shorthand bang! method for configuring parentheses in compound unit symbol
    # representations
    #
    def self.use_symbol_parentheses!
      @use_symbol_parentheses = true
    end

    # Returns <tt>true</tt> if parentheses are configured for use within compound
    # unit symbol representations. Otherwise returns <tt>false</tt>.
    #
    def self.use_symbol_parentheses?
      @use_symbol_parentheses.nil? ? false : @use_symbol_parentheses
    end

    # Shorthand bang! method for configuring denominator structures in compound
    # unit symbol representations (e.g. "kg/t km")
    #
    def self.use_symbol_denominator_syntax!
      self.use_symbol_denominator_syntax = true
    end

    # Shorthand bang! method for configuring index-only structures in compound
    # unit symbol representations (e.g. "kg t^-1 km^-1")
    #
    def self.use_symbol_indices_only!
      self.use_symbol_denominator_syntax = false
    end

    # Specify whether denominator structures should be used in compound unit
    # symbol representations. Set either <tt>true</tt> (e.g. "kg/t km") or
    # <tt>false</tt> (e.g. "kg t^-1 km^-1"). Defaults to <tt>true</tt>
    #
    def self.use_symbol_denominator_syntax=(true_or_false)
      @use_symbol_denominator_syntax = true_or_false
      refresh_all_unit_attributes!
    end

    # Returns <tt>true</tt> if denominator structures are configured for use
    # within compound unit symbol representations. Otherwise returns
    # <tt>false</tt>.
    #
    def self.use_symbol_denominator_syntax?
      @use_symbol_denominator_syntax.nil? ? true : @use_symbol_denominator_syntax
    end

    # Check whether superscript characters are turned on.
    def self.use_superscript_characters?
      @use_superscript_characters.nil? ? true : @use_superscript_characters
    end

    # Shorthand method for ::use_superscript_characters=true
    def self.use_superscript_characters!
      self.use_superscript_characters = true
    end

    # Declare whether superscript characters should be used for unit names, symbols
    # and labels - i.e. "²" and "³" rather than "^2" and "^3". Set to either true or
    # false. If not set, superscript characters are used by default.
    #
    def self.use_superscript_characters=(true_or_false)
      unless true_or_false == true || true_or_false == false
        raise Exceptions::InvalidArgumentError, "Argument must be true or false" 
      end

      @use_superscript_characters = true_or_false
      refresh_all_unit_attributes!
    end

    # Switch all unit identifiers (name, symbol, label) to use the currently
    # configured system for superscripts.
    #
    def self.refresh_all_unit_attributes!
      Unit.units.values.each { |unit| unit.refresh_attributes; unit }
    end

    # Load a new unit into they system of known units
    def self.load(unit)
      if unit.is_a? Unit::Base

        @units[unit.label]              = unit
        @unit_names[unit.name.downcase] = unit.label
        @unit_symbols[unit.symbol]      = unit.label
      end
    end

    # Remove a unit from the system of known units
    def self.unload(*unloaded_units)
      [unloaded_units].flatten.each do |unloaded_unit|
        unloaded_unit = Unit.for(unloaded_unit) 

        @units.delete(unloaded_unit.label)

        @unit_names.delete_if   { |k,v| v == unloaded_unit.label}
        @unit_symbols.delete_if { |k,v| v == unloaded_unit.label}
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
      unit       = Unit.for unit
      other_unit = Unit.for other_unit

      unless unit.is_alternative_for? other_unit
        raise Exceptions::InvalidUnitError, "Units do not represent the same physical quantity"
      end

      new_unit = (unit / other_unit)
      value    = 1/new_unit.factor

      Quantity.new(value, new_unit)
    end

    def self.dimensionless
      Unit::Base.new(:dimensions => 'dimensionless')
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
    def self.for(unit_descriptor)
      if unit_descriptor.is_a? Unit::Base
        return unit_descriptor.clone 
      end

      if unit_descriptor.nil? || ( unit_descriptor.is_a?(String) && unit_descriptor.empty? )
        return nil 
      end

      unless unit_descriptor.is_a?(String) || unit_descriptor.is_a?(Symbol)
        raise Exceptions::InvalidArgumentError, "Argument must be a Symbol or String"
      end
      
      if unit = Unit.match(unit_descriptor)
        return unit
      elsif unit = Unit.parse(unit_descriptor)
        return unit
      elsif unit = Unit.parse(unit_descriptor, :iterative => true)
        return unit
      else
        raise Exceptions::InvalidUnitError, "Unit '#{unit_descriptor}' not known"
      end

    end

    def self.match(unit)
      return unit.clone if unit.is_a? Unit::Base

      Unit.match_known_unit(unit) || Unit.match_prefixed_variant(unit) 
    end
    
    # Parse complex strings into unit.
    #
    def self.parse(string, options={})
      string = string.remove_underscores.without_superscript_characters

      if options[:iterative] == true
        units = Unit.iterative_parse(string, options) 
        units, remainder = units if options[:remainder] == true
      else
        units = Unit.simple_parse(string)
      end

      if units.empty?
        units = nil 
      elsif units.size == 1 && units.first.index == 1
        units = units.first.unit
      else
        units = Unit::Compound.new(*units)
      end

      options[:iterative] == true && options[:remainder] == true ? [units, remainder] : units
    end
    
    # This returns the suite of units which represents THE SI units for each of
    # the base dimensions, i.e. metre, kilogram, second, etc. but not prefixed
    # versions of the same unit
    #
    def self.base_quantity_si_units
      @units.values.select {|unit| unit.is_base_quantity_si_unit? }
    end
    
    # This can be replicated by method missing approach, but explicit method provided
    # given importance in #match (and #for) methods regexen
    #
    def self.non_prefixed_units
      @units.values.select {|unit| !unit.is_prefixed_unit? }
    end

    # This can be replicated by method missing approach, but explicit method provided
    # given importance in #match (and #for) methods regexen
    #
    def self.si_non_prefixed_units
      @units.values.select {|unit| unit.is_si_unit? && !unit.is_prefixed_unit? }
    end

    # This can be replicated by method missing approach, but explicit method provided
    # given importance in #match (and #for) methods regexen
    #
    def self.non_si_non_prefixed_units
      @units.values.select {|unit| unit.is_non_si_unit? && !unit.is_prefixed_unit? }
    end
    
    protected
    
    def self.match_known_unit(unit_descriptor)

      descriptor = Unit.format_unit_attribute(:label, unit_descriptor).to_sym
      if unit = @units[descriptor]
        return unit.clone
      end

      descriptor = Unit.format_unit_attribute(:symbol, unit_descriptor)
      if label = @unit_symbols[descriptor]
        return @units[label].clone
      end

      descriptor = Unit.format_unit_attribute(:name, unit_descriptor)
      if name = @unit_names[descriptor]
        return @units[name].clone
      end

    rescue
      nil
    end
    
    def self.match_prefixed_variant(unit_descriptor)
      [:label, :symbol, :name].each do |attribute|
        formatted_descriptor = Unit.format_unit_attribute(attribute, unit_descriptor)

        if formatted_descriptor =~ /\A(#{Unit.terms_for_regex(Unit::Prefix,:prefixes,attribute)})(#{Unit.terms_for_regex(Unit,:non_prefixed_units,attribute)})\z/
          return Unit.for($2).with_prefix($1).clone
        end
      end

      return nil
    rescue
      nil
    end
    
    def self.simple_parse(string)
      if string.scan(UNIT_DENOMINATOR_REGEX).size > 1
        raise Exceptions::InvalidArgumentError, "Malformed unit: multiple uses of '/' or 'per'"
      end

      units = []
      numerator, per, denominator = string.split(UNIT_DENOMINATOR_REGEX)

      units += Unit.parse_numerator_units(numerator)
      units += Unit.parse_denominator_units(denominator) unless denominator.nil?

      return units
    end
    
    def self.iterative_parse(string, options={})
      units = []

      is_denominator   = false
      current_exponent = nil
      
      while term = string.starts_with_valid_unit_term? do

        if term =~ /^#{UNIT_PREFIX_TERMS_REGEX}$/
          current_exponent = Unit.exponent_term_to_number(term)
        elsif term =~ /^#{UNIT_SUFFIX_TERMS_REGEX}$/ 
          units.last.index *= Unit.exponent_term_to_number(term) unless units.empty?
        elsif term =~ /^#{UNIT_DENOMINATOR_REGEX}/
          is_denominator = true
        else

          if is_denominator
            unit = Unit.parse_denominator_units(term).first
          else
            unit = Unit.parse_numerator_units(term).first
          end

          unit.index *= current_exponent if current_exponent
          
          units << unit
          current_exponent = nil
        end

        # Remove matched pattern from string for next iteration
        match_length = term.size
        string       = string[match_length, string.length - match_length].strip
      end

      options[:remainder] == true ? [units, string]: units
    end
    
    def self.parse_unit_and_index(string)
      string.scan(WORD_WITH_INDEX_REGEX)
      
      index = ($2.nil? || $2.empty? ? 1 : $2.to_i)
      unit  = Unit.match($1.to_s)

      if unit.is_a? Compound
        unit.base_units.each do |base_unit| 
          base_unit.index = base_unit.index * index
        end
      else
        CompoundBaseUnit.new($1.to_s, index)
      end
    end
    
    def self.parse_numerator_units(string)
      # If no middot then units parsed by whitespace
      # Need to escape multi-word units with underscores

      if string =~ /·/
        num_units = string.split("·")
      else
        num_units = Unit.escape_multi_word_units(string).split(" ")
      end

      num_units.map! do |substring|
        Unit.parse_unit_and_index(substring)
      end.flatten
    end
    
    def self.parse_denominator_units(string)
      Unit.parse_numerator_units(string).map do |unit|
        unit.index *= -1
        unit
      end
    end
  
    # standardize query strings or symbols into canonical form for unit names,
    # symbols and labels
    #
    def self.format_unit_attribute(attribute, unit_descriptor)
      unit_descriptor = case attribute
        when :symbol then unit_descriptor.remove_underscores
        when :name   then unit_descriptor.remove_underscores.singularize.downcase
        else              unit_descriptor.to_s
      end

      Unit.use_superscript_characters? ?
        unit_descriptor.with_superscript_characters : unit_descriptor.without_superscript_characters
    end
    
    # Return a list of unit names which are multi-word
    def self.multi_word_unit_names
      Unit.unit_names.keys.map { |name| name if name.word_count > 1 }.compact
    end
    
    # Return a list of pluralised unit names which are multi-word
    def self.multi_word_unit_pluralized_names
      multi_word_unit_names.map { |name| name.pluralize }
    end
    
    # Return a list of unit symbols which are multi-word
    def self.multi_word_unit_symbols
      Unit.unit_symbols.keys.map { |symbol| symbol if symbol.word_count > 1 }.compact
    end
    
    # Underscore any parts of string which represent multi-word unit identifiers
    # so that units can be parsed on whitespace
    #
    def self.escape_multi_word_units(string)
      (multi_word_unit_symbols + multi_word_unit_pluralized_names + multi_word_unit_names).each do |id|

        if /#{id}/i.match(string)
          string.gsub!(/#{id}/i, id.gsub(" ","_"))
        end
      end

      string
    end
    
    def self.exponent_term_to_number(term)
      return 2 if /square(d)?/i.match(term)
      return 3 if /cub(ic|ed)/i.match(term)
    end
    
    # Returns a list of "|" separated unit identifiers for use as regex
    # alternatives. Lists are constructed by calling 
    def self.terms_for_regex(klass,method,attribute)

      # Don't include the unity unit as it has blank name/symbol
      list = klass.send(method).map do |item| 
        item.send(attribute).to_s.gsub("/","\\/").gsub("^","\\^") unless item.label == :unity
      end.compact

      list.map! { |item| item.downcase } if attribute == :name
      list.sort { |x, y| y.size <=> x.size }.join("|")
    end
    
    def self.unit_label_regex
      /(#{Unit.terms_for_regex(Unit::Prefix,:prefixes,:label)})??((#{Unit.terms_for_regex(Unit,:non_prefixed_units,:label)})\b)/
    end
    
    def self.unit_symbol_regex
      /(#{Unit.terms_for_regex(Unit::Prefix,:prefixes,:symbol)})??((#{Unit.terms_for_regex(Unit,:non_prefixed_units,:symbol)})\b)/
    end
    
    def self.unit_name_regex
      # Specifically case insensitive
      # Double '?' (i.e. '??') makes prefix matching lazy, e.g. "centimetres of mercury" is matched fully rather than as 'centimetres'
      /(#{Unit.terms_for_regex(Unit::Prefix,:prefixes,:name)})??((#{Unit.terms_for_regex(Unit,:non_prefixed_units,:pluralized_name)}|#{Unit.terms_for_regex(Unit,:non_prefixed_units,:name)})\b)/i
    end
    
  end
end
