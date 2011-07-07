module Quantify

  def self.configure &block
    self.module_eval &block if block
  end

  # Check whether superscript characters are turned on.
  def self.use_superscript_characters?
    @use_superscript_characters.nil? ? true : @use_superscript_characters
  end

  # Shorthand method for Quantify.use_superscript_characters=true
  def self.use_superscript_characters!
    self.use_superscript_characters=true
  end

  # Declare whether superscript characters should be used for unit names, symbols
  # and labels - i.e. "²" and "³" rather than "^2" and "^3". Set to either true or
  # false. If not set, superscript characters are used by default.
  #
  def self.use_superscript_characters=(true_or_false)
    raise Exceptions::InvalidArgumentError,
      "Argument must be true or false" unless true_or_false == true || true_or_false == false
    @use_superscript_characters = true_or_false
    refresh_all_unit_identifiers!
  end

  # Switch all unit identifiers (name, symbol, label) to use the currently
  # configured system for superscripts.
  #
  def refresh_all_unit_identifiers!
    Unit.units.replace(
      Unit.units.map do |unit|
        unit.refresh_identifiers!
        unit
      end
    )
  end

  module ExtendedMethods

    # Provides syntactic sugar for accessing units via the #for method.
    # Specify:
    #
    #  Unit.degree_celsius
    #
    # rather than Unit.for :degree_celsius
    #
    def method_missing(method, *args, &block)
      if method.to_s =~ /((si|non_si|compound)_)?(non_(prefixed)_)?((base|derived|benchmark)_)?units(_by_(name|symbol|label))?/
        if $2 || $4 || $6
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
      elsif unit = Unit.for(method)
        return unit
      else
        super
      end
    end
    
  end
end