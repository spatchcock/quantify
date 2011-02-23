
module Quantify
  module Unit
    class Compound < Base

      def initialize(units=[])
        @base_units = []
        units.each do |unit|
          add_unit unit
        end
      end
      
      def add_unit(unit,index=1)
        # add unit to @base_units
      end

      def rationalize_base_units
        # rationalise unit powers
      end

      def convert_base_unit(base_unit,to_unit)
        # change all unit Xs to unit Ys
      end

    end
  end
end
