require_relative '../questionbase'
require_relative '../tohtml'
require_relative '../modules/names'
require_relative '../modules/units'
require_relative '../modules/items'

include ToHTML

module MyChapter12
  def self.gen_irreducibly_ratio
    n = rand(12) + 1
    m = rand(12) + 1
    r = Rational(n,m)

    [r.numerator, r.denominator]
  end

  def self.gen_ratio
    # generate the irreducible ratio, and multiply both nums by a coefficient
    # this way we get variety, while guaranteeing it's not too weird a number
    c = [2,3,4,5,6,7,8,9,10,12,15,20,25,50,100, 200, 500, 1000].sample
    MyChapter12.gen_irreducibly_ratio.map { |x| x * c }
  end
  
  class DefRatio < QuestionWithExplanation # {{{
    def self.type
      "What's a ratio?"
    end

    def initialize(n = nil, m = nil)
      @bob, @jen = Names::generate 2
      @item = Items::generate
      @swap_order = [true, false].sample

      unless n.nil? || m.nil?
        @n = n
        @m = m
      else
        @n, @m = MyChapter12::gen_ratio
      end
    end

    def text
      start = "#{@bob} has #{@item.write(@n)}, while #{@jen} has #{@item.write(@m)}."
      if @swap_order
        start = "#{@jen} has #{@item.write(@m)}, while #{@bob} has #{@item.write(@n)}."
      end

      return  [
        TextLabel.new(start),
        TextLabel.new("Find the ratio of #{@bob}'s #{@item.pluralize} to #{@jen}'s?"),
        InlineBlock.new(
          TextField.new("n"),
          TextLabel.new(":"),
          TextField.new("m"),
        )
      ]
    end

    def solve
      r = Rational(@n, @m)
      { "n" => r.numerator, "m" => r.denominator }
    end

    def explain
      r = Rational(@n, @m)
      [
        SubLabel.new("Ratios are when we compare things with division/multiplication.  An example of a ratio is when we say the sun is 400 times bigger than the moon, we are really saying that the ratio of the sun's size to the moon's size is 400 to 1, or 400:1.  We find that ratio by dividing the sun's diameter by the moon's."),
        SubLabel.new("This is more useful than saying that the sun's diameter is 1.4 million km greater than the moon's, because when we hear that we don't know how big the moon is."),
        SubLabel.new("With ratios, order matters.  Saying the sun is 400 times the diameter of the moon is way different from saying the moon is 400 times bigger than the sun, right?"),
        SubLabel.new("We find ratio's by dividing one quantity by the other, but it doesn't always work out perfectly.  For instance, the ratio of the earth's diameter to the moon's is 7:2, because the earths diameter divided by the moon's is about 7/2!"),
        SubLabel.new("Ok, enough about the moon.  One ratio of #{@bob}'s #{@item.write(@n)} to #{@jen}'s #{@item.write(@m)} is just #{@n}:#{@m}.  The most reduced one is #{r.numerator}:#{r.denominator}")
      ]
    end

    def correct?(response)
      n, m = QuestionBase.vars_from_response("n", "m", response)
      Rational(n, m) == Rational(@n, @m)
    end
  end
  # }}}

  class RatiosAndUnits < QuestionWithExplanation
    def self.type() "Ratios and units" end

    def initialize(a = nil, b = nil)
      @types = Units.generate_types 4
      @units = @types.map { |type| type.units.sample }
      @unit = @units[0]
      @units << @unit
      @units.shuffle!.shuffle!

      @nums = Array.new(@units.length) { |i| MyChapter12::gen_ratio[0] }
    end

    def text
      ret = [ TextLabel.new("Which of the following quantities can be compared?") ]

      @units.length.times do |i|
        ret << Checkbox.new("#{i}", "#{@nums[i]} #{@units[i]}")
      end

      ret
    end

    def solve
      # Get the indices of the correct answers
      indices = []
      @units.each_index do |i|
        indices << i if @units[i] == @unit
      end

      Hash[ indices.map{ |i| i.to_s }.zip([true, true]) ]
    end

    def explain
      new_text = text.insert(0, TextLabel.new("Ratios don't really make sense when you compare things of different units, just like you couldn't say 1 liters is 5 times bigger than 20 centimeters.  Try again and pick the ones with the same unit"))

      [ Subproblem.new(new_text, soln) ]
    end
  end

  class RatiosAndUnitConversions < QuestionBase
  def self.type() "Ratios and unit conversions" end
  end

  PROBLEMS = [
    DefRatio,
    RatiosAndUnits
  ]
end
