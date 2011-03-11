class String

  def standardize
    self.gsub("_"," ")
  end

  def to_power index
    name = self.clone
    case index
    when 1 then name
    when 2 then name << " squared"
    when 3 then name << " cubed"
    else
      ordinal = ActiveSupport::Inflector.ordinalize index
      name << " to the #{ordinal} power"
    end
  end
   
end

class Symbol

  def standardize
    self.to_s.standardize
  end
  
end


class Numeric

  # Syntactic sugar for defining instances of the Quantity class.
  #
  # Enables quantities to be specified by using unit names, symbols or JScience
  # labels as argments on Numeric objects, e.g.
  #
  #   1.5.metre      is equivalent to Quantity. new 1.5, :metre
  #
  #   1000.t         is equivalent to Quantity. new 1000, :t
  #
  def method_missing(method, *args, &block)
    if unit = Unit.for(method.to_s)
      Quantify::Quantity.new self, unit
    else
      raise NoMethodError, "Undefined method `#{method}` for #{self}:#{self.class}"
    end
  end

end