
module Quantify
  module Unit
    class CompoundBaseUnit

      # Container class for compound unit base units. Each instance is represented
      # by a unit and an index, i.e. a unit raised to some power. If no index is
      # present, 1 is assumed.
      #
      # Instances of this class can be used to initialize base units, and are the
      # structures which hold base units within compound units
      #

      attr_accessor :unit, :index

      def initialize(unit,index=1)
        @unit = Unit.match(unit) || raise(Exceptions::InvalidUnitError, "Base unit not known: #{unit}")
        raise Exceptions::InvalidUnitError, "Base unit cannot be compound unit" if @unit.is_a? Compound
        @index = index
      end

      def dimensions
        @unit.dimensions ** @index
      end

      # Only refers to the unit index, rather than the dimensions configuration
      # of the actual unit
      #
      def is_dimensionless?
        @index == 0
      end

      # Absolute index as names always contain 'per' before denominator units
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

      # Reciprocalized version of label, i.e. sign changed. This is used to make
      # a denominator unit renderable in cases where there are no numerator units,
      # i.e. where no '/' appears in the label
      #
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

      # The following methods refer only to the unit of the CompoundBaseUnit
      # object, rather than the unit *together with its index*

      Unit_Methods = [ :base_quantity_si_unit, :base_unit, :benchmark_unit, :si_unit,
                       :non_si_unit, :prefixed_unit, :derived_unit ]
  
      Unit_Methods.each do |method|
        method = "is_#{method.to_s}?"
        define_method(method) do
          @unit.send method.to_sym
        end
      end

      def measures
        @unit.measures
      end

      def initialize_copy(source)
        instance_variable_set("@unit", unit.clone)
      end
    end
  end
end