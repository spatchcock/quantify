module Quantify

  def self.configure(&block)
    self.module_eval(&block) if block
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
          conditions << "unit.is_#{$2}_unit?"     if $2
          conditions << "!unit.is_prefixed_unit?" if $4
          conditions << "unit.is_#{$6}_unit?"     if $6

          units = Unit.units.values.select { |unit| instance_eval(conditions.join(" && ")) }
        else
          units = Unit.units.values
        end
        return_format = ( $8 ? $8.to_sym : nil )
        units.map(&return_format).to_a
      elsif unit = Unit.for(method)
        return unit
      else
        super
      end
    end
    
  end
end