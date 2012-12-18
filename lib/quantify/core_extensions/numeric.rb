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
    return super if (method == :to_str || method == :to_ary || method == :to_hash)
    begin
      Quantify::Quantity.new self, method.to_s
    rescue Exception
      super
    end
  end
end
