
class String

  def standardize!
    self.downcase.gsub(" ","_").to_sym
  end

  def standardize
    new_string = self.clone
    new_string.standardize!
  end

  def to_power(power)
    return self if power == 1
    self + "^#{power}"
  end
  
end

class Symbol

  def standardize!
    self.to_s.standardize!
  end

  def standardize
    self.to_s.standardize
  end

end

class Numeric

  def method_missing(method, *args, &block)
    if unit = Unit.for(method.to_s)
      Quantify::Quantity.new self, unit
    else
      raise NoMethodError, "Undefined method `#{method}` for #{self}:#{self.class}"
    end
  end

end