
module Quantify
  module Unit
    class CompoundBaseUnit

      attr_accessor :unit, :index

      def initialize(unit,index=1)
        @unit = Unit.for(unit)
        raise InvalidArgumentError, "Base unit cannot be compound unit" if @unit.is_a? Compound
        @index = index
      end

      def dimensions
        @unit.dimensions ** @index
      end

      def is_dimensionless?
        @index == 0
      end

      def name
        @unit.name.to_power(@index.abs)
      end

      def pluralized_name
        @unit.pluralized_name.to_power(@index.abs)
      end

      def symbol
        @unit.symbol.to_s + ( @index.nil? or @index == 1 ? "" : "^#{@index}" )
      end

      def label
        @unit.label + (@index == 1 ? "" : "^#{@index}")
      end

      def reciprocalized_label
        @unit.label + (@index == -1 ? "" : "^#{@index * -1}")
      end

      def factor
        @unit.factor ** @index
      end

      def is_numerator?
        @index > 0
      end

      def is_denominator?
        @index < 0
      end

      def is_si_unit?
        @unit.is_si_unit?
      end

      def is_non_si_unit?
        @unit.is_non_si_unit?
      end

      def measures
        @unit.dimensions.physical_quantity
      end
    end
  end
end
