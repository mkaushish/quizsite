require_relative '../questionbase.rb'

describe "QuestionBase" do
  describe "default preprocess" do
    it "should remove commas" do
      hash = {"ans" => "1,2,3"}
      newhash = QuestionBase.new.preprocess_hash(hash)
      newhash["ans"].should == "123"
    end

    it "should strip whitespace on the outside" do
      hash = {"ans" => "    1,2,3   "}
      newhash = QuestionBase.new.preprocess_hash(hash)
      newhash["ans"].should == "123"
    end

    it "should downcase everything" do
      hash = {"ans" => "   HelLO,   "}
      newhash = QuestionBase.new.preprocess_hash(hash)
      newhash["ans"].should == "hello"
    end

    it "should flatten out any arrays in the solution" do
      hash = {"arr" => [1,2,3,4]}
      newhash = QuestionBase.new.preprocess_hash(hash)
      4.times do |i|
        newhash["arr_#{i}"].should_not be_nil
      end
    end
  end
end

