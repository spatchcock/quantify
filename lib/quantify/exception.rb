module Quantify
  module Exceptions

    class QuantityParseError < Exception
    end

    class InvalidObjectError < Exception
    end

    class InvalidUnitError < Exception
    end

    class InvalidDimensionError < Exception
    end

    class InvalidPhysicalQuantityError < Exception
    end

    class InvalidArgumentError < Exception
    end
    
  end
end