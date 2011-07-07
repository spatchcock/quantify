
require 'quantify'

describe String do

  describe "applying superscripts" do

    it "should replace 2s with superscripts" do
      "kg^2".with_superscript_characters.should eql "kg²"
    end

    it "should replace 3s with superscripts" do
      "kg^3".with_superscript_characters.should eql "kg³"
    end

    it "should not replace 4s with superscripts" do
      "kg^4".with_superscript_characters.should eql "kg^4"
    end

    it "should not replace larger numbers starting with 2 with superscripts" do
      "kg^25".with_superscript_characters.should eql "kg^25"
    end

    it "should replace multiple 2s and 3s with superscripts" do
      "kg^3 m^2 K^2".with_superscript_characters.should eql "kg³ m² K²"
    end

    it "should replace multiple 2s and 3s with superscripts except negatives or larger numbers" do
      "kg^3 bq^-2 m^2 K^2 A^2500".with_superscript_characters.should eql "kg³ bq^-2 m² K² A^2500"
    end

  end

  describe "removing superscripts" do

    it "should replace superscripts with 2s" do
      "kg²".without_superscript_characters.should eql "kg^2"
    end

    it "should replace superscripts with 3s" do
      "kg³".without_superscript_characters.should eql "kg^3"
    end

    it "should replace multiple superscripts with 2s and 3s" do
      "kg³ m² K²".without_superscript_characters.should eql "kg^3 m^2 K^2"
    end

    it "should replace multiple superscripts with 2s and 3s except negatives or larger numbers" do
      "kg³ bq^-2 m² K² A^2500".without_superscript_characters.should eql "kg^3 bq^-2 m^2 K^2 A^2500"
    end

  end

end

