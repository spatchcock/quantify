#! usr/bin/ruby

module Quantify
  module Unit

    # The Unit module contains functionality for defining and handling
    # representations of physical units. 

    attr_accessor :units

    @units = []

    def self.load(unit)
      @units << unit if unit.is_a? Unit::Base
    end

    def self.units
      @units
    end

    def self.si_units
      @units.select { |unit| unit.is_si? }
    end

    def self.non_si_units
      @units.select { |unit| !unit.is_si? }
    end

    def self.names
      @units.map { |unit| unit.name }
    end

    def self.si_names
      si_units.map { |unit| unit.name }
    end

    def self.non_si_names
      non_si_units.map { |unit| unit.name }
    end

    def self.symbols
      @units.map { |unit| unit.symbol }
    end

    def self.si_symbols
      si_units.map { |unit| unit.symbol }
    end

    def self.non_si_symbols
      non_si_units.map { |unit| unit.symbol }
    end

    def self.jscience_labels
      @units.map { |unit| unit.jscience_label }
    end

    def self.si_jscience_labels
      si_units.map { |unit| unit.jscience_label }
    end

    def self.non_si_jscience_labels
      non_si_units.map { |unit| unit.jscience_label }
    end

    def self.for(name_symbol_or_label)
      if name_symbol_or_label.is_a? String or
         name_symbol_or_label.is_a? Symbol
        if unit = @units.find do |unit|
            unit.name == name_symbol_or_label.standardize or
            unit.symbol == name_symbol_or_label.to_sym or
            unit.jscience_label == name_symbol_or_label.to_sym
          end
          return unit.deep_clone
        elsif name_symbol_or_label.to_s =~ /\A(#{Prefix.si_names.join("|")})(#{Unit.si_names.join("|")})\z/ or
          name_symbol_or_label.to_s =~ /\A(#{Prefix.non_si_names.join("|")})(#{Unit.non_si_names.join("|")})\z/ or
          name_symbol_or_label.to_s =~ /\A(#{Prefix.si_symbols.join("|")})(#{Unit.si_symbols.join("|")})\z/ or
          name_symbol_or_label.to_s =~ /\A(#{Prefix.non_si_symbols.join("|")})(#{Unit.non_si_symbols.join("|")})\z/ or
          name_symbol_or_label.to_s =~ /\A(#{Prefix.si_symbols.join("|")})(#{Unit.si_jscience_labels.join("|")})\z/ or
          name_symbol_or_label.to_s =~ /\A(#{Prefix.non_si_symbols.join("|")})(#{Unit.non_si_jscience_labels.join("|")})\z/
          return Unit.for($2).with_prefix($1).deep_clone
        else
          return nil
        end
      else
        raise InvalidArgumentError, "Argument must be a Symbol or String"
      end
    end

    def self.method_missing(method, *args, &block)
      if unit = self.for(method)
        return unit
      else
        raise NoMethodError, "Undefined method `#{method}` for #{self}:#{self.class}"
      end
    end


    # # # OLD. Needs reworking # # #
    #
    # parse complex strings into compound unit
    #
    # def self.parse(string)
    #   escaped_unit_symbols_string = Quantify.unit_symbols.map { |symbol| Regexp.escape(symbol)+'\b' }.join("|")
    #   escaped_unit_names_string = Quantify.unit_names.map { |name| Regexp.escape(name) }.join("|")
    #   @units = string.split(" ").map do |substring|
    #     substring.scan(/(#{Quantify.prefix_names.join("|")})?(#{escaped_unit_names_string})\^?([\d\.-]*)?/i)
    #     unless $2.nil?
    #       prefix, name, index = $1, $2, ( $3.to_i == 0 ? 1 : $3.to_i )
    #     else
    #       substring.scan(/(#{Quantify.prefix_symbols.join("|")})?(#{escaped_unit_symbols_string}\z)\^?([\d\.-]*)?/)
    #       prefix, name, index = $1, $2, ( $3.to_i == 0 ? 1 : $3.to_i )
    #     end
    #     Standard.new(name,index,prefix)
    #   end
    #   if @units.size == 1
    #     return @units[0]
    #   else
    #     return Compound.new(@units)
    #   end
    # end

  end
end
