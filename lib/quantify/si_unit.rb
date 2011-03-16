
module Quantify
  module Unit
    class SI < Base

      # Class representing SI units. This inherits from Unit::Base

      # Create a new SI unit based on self and a valid SI prefix
      # Can probably abstract this out to Unit::Base - requirement is that
      # a unit of same class (i.e. SI) be created and that the assocaited prefix
      # alse be of the analogous Prefix class (i.e. SI).
      #
      def with_prefix(name_or_symbol)
        if self.name =~ /\A(#{Prefix.si_names.join("|")})/
          raise InvalidArgumentError, "Cannot add prefix where one already exists: #{self.name}"
        end

        if name_or_symbol.is_a? Prefix
          prefix = name_or_symbol
        else
          prefix = Prefix.for(name_or_symbol)
        end
        
        unless prefix.nil?
          unless prefix.is_a? Quantify::Prefix::SI
            raise InvalidArgumentError, "Invalid prefix for Unit::SI class: #{name_or_symbol}"
          end
          new_unit_options = {}
          new_unit_options[:name] = "#{prefix.name}#{self.name}"
          new_unit_options[:symbol] = "#{prefix.symbol}#{self.symbol}"
          new_unit_options[:label] = "#{prefix.symbol}#{self.label}"
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
