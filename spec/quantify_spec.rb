require 'quantify'
include Quantify

describe Quantify do

  it "should initialize superscript format" do
    Quantify.use_superscript_characters?.should be_true
  end

  it "should set superscript usage to true" do
    Quantify.use_superscript_characters=true
    Quantify.use_superscript_characters?.should be_true
  end

  it "should set superscript usage to false" do
    Quantify.use_superscript_characters=false
    Quantify.use_superscript_characters?.should be_false
  end

end