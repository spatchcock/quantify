
module Quantify
  module Unit
    class NonSI < Base

      # Class representing SI units. This inherits from Unit::Base


      # Additional initialize. Some NonSI units - temperature units, celsius and
      # farenheit - contain scaling factors in addition to multiplicative factors.
      # These are required in order to perform conversion, e.g. kelvin => celsius
      # and therefore become and additional attribute to NonSI units
      #
      def initialize(options)
        @scaling = options[:scaling].nil? ? 0.0 : options.delete(:scaling).to_f
        super(options)
      end

      # Create a new NonSI unit based on self and a valid NonSI prefix
      # Can probably abstract this out to Unit::Base - requirement is that
      # a unit of same class (i.e. NonSI) be created and that the assocaited prefix
      # alse be of the analogous Prefix class (i.e. NonSI).
      #
      def with_prefix(name_or_symbol)
        if self.name =~ /\A(#{Prefix.non_si_names.join("|")})/
          raise InvalidArgumentError, "Cannot add prefix where one already exists: #{self.name}"
        end

        if name_or_symbol.is_a? Prefix
          prefix = name_or_symbol
        else
          prefix = Prefix.for(name_or_symbol)
        end
        
        unless prefix.nil?
          unless prefix.is_a? Quantify::Prefix::NonSI
            raise InvalidArgumentError, "Invalid prefix for Unit::NonSI class: #{name_or_symbol}"
          end
          new_unit_options = {}
          new_unit_options[:name] = "#{prefix.name}_#{self.name}".capitalize
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
