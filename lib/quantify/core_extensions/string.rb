# encoding: UTF-8
class String

  def with_superscript_characters
    self.gsub(/\^2\b/,"²").gsub(/\^3\b/,"³")
  end

  def without_superscript_characters
    self.gsub(/¹\b/,"").gsub(/²\b/,"^2").gsub(/³\b/,"^3")
  end
  
  def remove_underscores
    self.gsub("_"," ")
  end

  def words
    split(/\s+/)
  end

  def word_count
    words.size
  end

  def starts_with_number?
    (/\A([\d\s.,]+)/i).match(self) ? true : false
  end

  def to_quantity
    Quantify::Quantity.parse(self)
  end
  alias :to_q :to_quantity

end
