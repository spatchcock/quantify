
module Quantify
  module Unit
    class SI < Base

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
          unless prefix.is_a? Quantify::Prefix::SI
            raise InvalidArgumentError, "Invalid prefix for Unit::SI class: #{name_or_symbol}"
          end
          new_unit_options = {}
          new_unit_options[:name] = "#{prefix.name}#{self.name}".standardize
          new_unit_options[:symbol] = "#{prefix.symbol}#{self.symbol}"
          new_unit_options[:factor] = prefix.factor * self.factor
          new_unit_options[:physical_quantity] = self.dimensions
          SI.new(new_unit_options)
        else
          raise InvalidArgumentError, "Prefix unit is not known: #{prefix}"
        end
      end

    end
  end
end
