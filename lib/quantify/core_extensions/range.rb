if RUBY_VERSION < "1.9"
  class Range
	alias :cover? include?
  end
end