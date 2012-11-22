
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
        @unit = Unit.match(unit)

        raise Exceptions::InvalidUnitError, "Base unit not known: #{unit}"      if @unit.nil?
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
      def name(reciprocal=false)
        name_to_power(@unit.name, @index.abs)
      end

      def pluralized_name
        name_to_power(@unit.pluralized_name, @index.abs)
      end

      def symbol(reciprocal=false)
        @unit.symbol + index_as_string(reciprocal)
      end

      def label(reciprocal=false)
        @unit.label + index_as_string(reciprocal)
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

      def measures
        dimensions.describe
      end

      def is_base_quantity_si_unit?
        @unit.is_base_quantity_si_unit?
      end

      def is_base_unit?
        @unit.is_base_unit?
      end
      
      def is_benchmark_unit?
        @unit.is_benchmark_unit?
      end

      def is_si_unit?
        @unit.is_si_unit?
      end
      
      def is_non_si_unit?
        @unit.is_non_si_unit?
      end

      def is_prefixed_unit?
        @unit.is_prefixed_unit?
      end

      def is_derived_unit?
        @unit.is_derived_unit?
      end

      def initialize_copy(source)
        instance_variable_set("@unit", @unit.clone)
      end

      private

      # Returns a string representation of the unit index, formatted according to
      # the global superscript configuration.
      #
      # The index value can be overridden by specifying as an argument.
      #
      def formatted_index(index=nil)
        index = "^#{index.nil? ? @index : index}"
        Unit.use_superscript_characters? ? index.with_superscript_characters : index
      end

      def index_as_string(reciprocal=false)
        if reciprocal == true
          @index == -1 ? "" : formatted_index(@index * -1)
        else
          @index.nil? || @index == 1 ? "" : formatted_index
        end
      end

      def name_to_power(string,index)
        name = string.clone
        case index
        when 1 then name
        when 2 then "square #{name}"
        when 3 then "cubic #{name}"
        else
          ordinal = ActiveSupport::Inflector.ordinalize(index)
          name << " to the #{ordinal} power"
        end
      end
    end
  end
end