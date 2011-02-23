
module Quantify
  module Unit
    class NonSI < Base

      def initialize(options)
        @scaling = options[:scaling].nil? ? 0.0 : options.delete(:scaling).to_f
        super(options)
      end

      def with_prefix(name_or_symbol)
        if name_or_symbol.is_a? Prefix
          prefix = name_or_symbol
        else
          prefix = Prefix.for(name_or_symbol)
        end
        # deal with attempts to apply prefix
        # to a unit which already uses a prefix
        #
        unless prefix.nil?
          unless prefix.is_a? Quantify::Prefix::NonSI
            raise InvalidArgumentError, "Invalid prefix for Unit::NonSI class: #{name_or_symbol}"
          end
          new_unit_options = {}
          new_unit_options[:name] = "#{prefix.name}_#{self.name}".standardize
          new_unit_options[:symbol] = "#{prefix.symbol}#{self.symbol}"
          new_unit_options[:factor] = prefix.factor * self.factor
          new_unit_options[:physical_quantity] = self.dimensions
          NonSI.new(new_unit_options)
        else
          raise InvalidArgumentError, "Prefix unit is not known: #{prefix}"
        end
      end

    end
  end
end
