require_relative '../questionbase'
require_relative '../tohtml'
require_relative '../modules/names'
require_relative '../modules/units'
require_relative '../modules/items'

include ToHTML

module MyChapter12
  COEFFICIENTS = [2,3,4,5,6,7,8,9,10,12,15,20,25,50,100, 200, 500, 1000]

  def self.gen_irreducible_ratio
    n = rand(12) + 1
    m = rand(12) + 1
    r = Rational(n,m)

    [r.numerator, r.denominator]
  end

  def self.gen_ratio
    # generate the irreducible ratio, and multiply both nums by a coefficient
    # this way we get variety, while guaranteeing it's not too weird a number
    c = COEFFICIENTS.sample
    MyChapter12.gen_irreducible_ratio.map { |x| x * c }
  end

  def self.ratio_field(name)
    InlineBlock.new(TextField.new("#{name}_a"), 
                    TextLabel.new(" : "),
                    TextField.new("#{name}_b")
                   )
  end

  module C12Initializers # {{{
    # these are static methods, because I think it will make their use more clear.
    def init_bob_and_jen(options)
      names = Names::generate(2)
      @bob = options[:bob] || names[0]
      @jen = options[:jen] || names[1]
    end

    # options you can supply: :ratios, :c1, :c2, :p
    def init_proportion(options)
      a, b = options[:ratios] || MyChapter12.gen_irreducible_ratio # the ratio used in the proportion
      coeffs = COEFFICIENTS.sample(2)
      c1        = options[:c1] || coeffs[0]  # :c1 => the coefficient the first ratio is multiplied by
      c2        = options[:c2] || coeffs[1]  # :c2 => the coefficient the second ratio is multiplied by
      @p = options[:p] || [ a * c1, b * c1, a * c2, b * c2 ] # :p overrides all other options
    end
  end # }}}

  class GetEquivalentFraction < QuestionWithExplanation # {{{
    def self.type() "Get the equivalent fraction" end

    # NOTE you can't set b to 0 here, it'll throw an exception
    def initialize(a = nil, b = nil)
      if a.nil? || b.nil? || b == 0
        @a, @b = MyChapter12.gen_ratio
      else
        @a, @b = a, b
      end
    end

    def text
      [
        TextLabel.new("Get the fration which represents the ratio #{@a} : #{@b}"),
        Fraction.new("a", "b")
      ]
    end

    def solve()
      r = Rational(@a, @b)
      { "a" => r.numerator, "b" => r.denominator } 
    end

    def correct?(response)
      a, b = QuestionBase.vars_from_response("a", "b", response).map { |s| s.to_i }
      return false if b == 0
      Rational(a.to_i, b.to_i) == Rational(@a, @b)
    end

    def explain
      a, b = Rational(@a, @b).numerator, Rational(@a, @b).denominator
      @item = Items.generate
      [
        SubLabel.new("When turning a ratio into a fraction the important thing is to remember that the first part goes on top, and the second part goes on the bottom."),
        SubLabel.new("You can remember this if you just think of an example: if the ratio of boys to girls is #{@a} : #{@b}, then that means that there are #{@a}/#{@b} times as many boys as girs. Reducing this fraction isn't strictly necessary, but we'll do it anyway because fractions and ratios like to be in their lowest form."),
        Chapter7::ReduceFractions.new(@a, @b)
      ]
    end
  end # }}}
  
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
        # The length of the moon * 400 = the length of the sun * 1
        # therefore the lenght of the sun / the lenght of the moon = 400 / 1
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

  class RatioToFractionOfTotal < QuestionWithExplanation # {{{
    def self.type() "Turn a ratio into a fraction of the total" end

    def initialize(a = nil, b = nil, options = {})
      if a.nil? || b.nil?
        @a, @b = MyChapter12.gen_ratio
      else
        @a, @b = a, b
      end

      names = Names.generate(2)
      @bob = options[:bob] || names[0]
      @jen = options[:jen] || names[1]
      @item = options[:item] || Items.generate
    end

    def text
      [
        TextLabel.new("If the ratio of #{@bob}'s #{@item.s} to #{@jen}'s is #{@a} : #{@b}, what fraction of the total does #{@bob} have?"),
        Fraction.new("a", "b")
      ]
    end

    def solve
      r = Rational(@a, @a + @b)
      { "a" => r.numerator, "b" => r.denominator }
    end

    def explain
      r = Rational(@a, @a + @b)
      [
        Subproblem.new( [ 
            TextLabel.new("Since #{@bob} and #{@jen} have #{@item.s} at a #{@a} : #{@b} ratio, that means for every (#{@a} + #{@b}) owned by the two of them, #{@bob} has #{@a}.  Now calculated the reduced form of the fraction of the total #{@item.s} owned by #{@bob}:"),
            InlineBlock.new( Fraction.new(@a, TextLabel.new("#{@a} + #{@b}")), " = ", Fraction.new("a", "b") ) 
          ],
          soln
        )
      ]
    end
  end # }}}

  class ReduceRatio < QuestionWithExplanation # {{{
    def self.type() "Lowest forms of ratios" end
    
    def initialize(a = nil, b = nil)
      if a.nil? || b.nil?
        @a, @b = MyChapter12.gen_ratio
      else
        @a, @b = a, b
      end
    end

    def solve
      r = Rational(@a,@b)
      {"ans_a" => r.numerator, "ans_b" => r.denominator}
    end

    def text
      [
        TextLabel.new("Reduce the ratio #{@a} : #{@b} to it's lowest form"),
        MyChapter12.ratio_field("ans")
      ]
    end

    def explain
      r = Rational(@a,@b)
      [
        SubLabel.new("Every ratio has a <b>lowest form</b>, which is the smallest equivalent ratio.  To get the lowest form of a ratio, just convert it to a fraction and reduce it"),
        GetEquivalentFraction.new(@a, @b),
        Chapter7::ReduceFractions.new(@a, @b),
        SubLabel.new("Therefore the lowest form of the ratio #{@a} : #{@b} is #{r.numerator} : #{r.denominator}")
      ]
    end
  end # }}}

  class RatiosAndTotals < QuestionWithExplanation # {{{
    attr_accessor :bob, :jen, :item
    def self.type() "Find the quantities from a ratio and a total" end

    # t is the total quanty (Fixnum)
    # r is the ratio        (Rational)
    def initialize(t = nil, r = nil)
      if t.nil? || r.nil?
        @r = Rational(*MyChapter12.gen_irreducible_ratio)
        @t = (@r.numerator + @r.denominator) * COEFFICIENTS.sample
      else
        @t, @r = t, r
      end

      @item = Items.generate
      @bob, @jen = Names.generate(2)
    end

    def num() @r.numerator end
    def den() @r.denominator end
    def coeff() @t / (num + den) end

    def solve
      { "a" => num * coeff, "b" => den * coeff }
    end

    def text
      [
        TextLabel.new("#{@bob} and #{@jen} have #{@item.write(@t)} in total, and the ratio of " +
          "#{@bob}'s #{@item.pluralize} to #{@jen}'s is #{num} : #{den}. Complete the following: "),
        InlineBlock.new("#{@bob} owns ", TextField.new("a"), "#{@item.pluralize}"),
        InlineBlock.new("#{@jen} owns ", TextField.new("b"), "#{@item.pluralize}")
      ]
    end

    def explain
      r = Rational(num, num + den)
      [
        SubLabel.new("To find quantities given a ratio and a total, start off by finding the " +
          "fraction of each quantity to the total.  Then multiply that fraction by the total. " +
          "We'll start with #{@bob}"),
        RatioToFractionOfTotal.new(num, den, {:bob => @bob, :jen => @jen, :item => @item}),
        SubLabel.new("That fraction is also a ratio: the ratio of #{@bob}'s #{@item.pluralize} to " +
          "#{@bob} and #{@jen}'s #{@item.pluralize}.  Therefore #{@bob} has " + 
          "#{Rational(@r.numerator, @r.numerator + @r.denominator)} of the total"),
        Subproblem.new([ InlineBlock.new(
          Fraction.new(r.numerator, r.denominator), " \u00D7 ", @item.write(@t), #\u00D7 => unicode mult symbol
          " = ", TextField.new("ans"), @item.pluralize) ],
          { "ans" => soln["a"] } ),
        Subproblem.new([
          TextLabel.new("Now that we know that #{@bob} has #{@item.write(soln["a"])}, we can find out "+
              "how many #{@jen} has by subtracting #{@bob}'s amount from the total."),
          InlineBlock.new("#{@t} - #{soln["a"]} = ", TextField.new("ans")) ],
          { "ans" => soln["b"] } )
      ]
    end
  end # }}}

  class RatiosAndUnits < QuestionWithExplanation # {{{
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
  end # }}}

  class RatiosAndUnitConversions < QuestionBase
    def self.type() "Ratios and unit conversions" end
  end

  module EquivalentRatiosMethods # {{{
    def correct?(response)
      r = Rational(@a, @b)

      resps = Array.new(@num_ratios) { |i| QuestionBase.vars_from_response("#{i}_a", "#{i}_b", response).map { |s| s.to_i } }
      correct = true

      # TODO set soln in correct?
      # for each response
      @num_ratios.times do |i|
        a, b = resps[i]
        # make sure it's not the number listed
        correct &= (a != @a) && (b != @b)

        # make sure it's right
        correct &= Rational(a,b) == r

        # make sure they don't repeat themselves on other answers
        # this works because negative indices work like you'd expect them to in ruby
        (1...@num_ratios).each { |j| correct &= (a != resps[i-j][0]) && (b != resps[i-j][1]) }
        return false unless correct
      end
      true
    end

    def solve
      r = Rational(@a, @b)
      r_a = r.numerator
      r_b = r.denominator

      # set the solution coefficients to be the first available ones, which are easiest
      # the students to calculate
      coeffs = (1..@num_ratios).to_a

      # make sure our coefficient isn't in the list of solution coefficients, 
      # and swap it out if it is
      c = @a / r_a
      if c <= @num_ratios
        coeffs[c] = @num_ratios
        coeffs.sort!
      end

      ret = {}
      @num_ratios.times do |i|
        ret["#{i}_a"] = r_a * coeffs[i]
        ret["#{i}_b"] = r_b * coeffs[i]
      end
      ret
    end
  end # }}}

  class EquivalentRatiosHelper < QuestionBase # {{{
    include EquivalentRatiosMethods

    def self.type() "Name equivalent ratios" end

    def initialize(a, b, num_ratios)
      @a, @b, @num_ratios = a, b, num_ratios
    end

    def text
      Array.new(@num_ratios) { |i| MyChapter12.ratio_field(i.to_s) }
    end
  end # }}}

  class EquivalentRatios < QuestionWithExplanation # {{{
    include EquivalentRatiosMethods

    def self.type() "Name equivalent ratios" end

    def initialize(a = nil, b = nil, num_ratios = nil)
      if a.nil? || b.nil?
        @a, @b = MyChapter12.gen_ratio
      else
        @a, @b = a, b
      end
      @num_ratios = num_ratios || 2 + rand(2)
    end

    def text
      txt = [
        TextLabel.new("Name #{@num_ratios} ratios equivalent to #{@a} : #{@b}")
      ] + Array.new(@num_ratios) { |i| MyChapter12.ratio_field(i.to_s) }
    end

    def explain
      [
        SubLabel.new("A ratio is kind of like a fraction, because they both compare things by division.  Each ratio has a lowest form just like each fraction does. Any multiple of that lowest form is equivalent to any other multiple of it.  So we'll start by finding the lowest form of #{@a} : #{@b}, and then we'll just pick numbers to multiply that by"),
        ReduceRatio.new(@a, @b),
        SubLabel.new("Now we can choose any numbers to multiply our base form ratio by, and we'll get a new ratio that's equivalent to our original.  Any number will do, so you should choose ones that are easy to multiply by, like 1, 2, 10, 20, or even 100!"),
        EquivalentRatiosHelper.new(@a, @b, @num_ratios)
      ]
    end
  end # }}}

  class FillInEquivRatios < QuestionWithExplanation # {{{
    include C12Initializers
    def self.type
      "Complete the equivalent ratio"
    end

    def initialize(options = {})
      init_proportion(options)

      @missing_i = options[:missing_i] || rand(4) # the index in the proportion the student will be asked for
    end

    def solve
      {"ans" => @p[@missing_i]}
    end

    def text
      final_ratio = [ TextLabel.new(@p[0].to_s), TextLabel.new(" : "), TextLabel.new(@p[1].to_s), 
                      TextLabel.new(" :: "),
                      TextLabel.new(@p[2].to_s), TextLabel.new(" : "), TextLabel.new(@p[3].to_s) ]
      final_ratio[@missing_i * 2] = TextField.new("ans")

      [ 
        TextLabel.new("Fill in the blank to make the ratios equivalent and the statement true:"),
        InlineBlock.new(final_ratio)
      ] 
    end
    
    def explain
      p = @p.clone
      p[@missing_i] = "_"
      f_s = ["first", "second"]
      known = (@missing_i > 1) ? @p[0..1] : @p[2..3]
      uk = (@missing_i <= 1) ? @p[0..1] : @p[2..3] # unknown
      rat = [Rational(*uk).numerator, Rational(*uk).denominator]
      [
        SubLabel.new("Completing the equivalent ratios: #{p[0]} : #{p[1]} :: #{p[2]} : #{p[3]}"),
        SubLabel.new("The easiest way to complete an equivalent set of ratios is to find the lowest form of the ratios. " +
          "Then you just find the number you need to multiply both sides by for the answer.  In this problem, we don't have " + 
          "the full #{f_s[@missing_i/2]} ratio, so we have to use the #{f_s[@missing_i/2 - 1]}"),
        ReduceRatio.new(*known),
        Subproblem.new(
          [ TextLabel.new("Now we have to find the coefficient of the second ratio.  We know the #{f_s[@missing_i % 2 - 1]} part " +
              "of the incomplete ratio is #{uk[@missing_i % 2 - 1]}, and we know that the #{f_s[@missing_i % 2 - 1]} part " +
              "of the reduced ratio is #{rat[@missing_i % 2 - 1]}.  Therefore the coefficient is: "
            ),
            InlineBlock.new( 
              Fraction.new(uk[@missing_i % 2 - 1], rat[@missing_i % 2 - 1]),
              " = ",
              TextField.new("ans") ) ],
          { "ans" => (uk[0] / rat[0]) } ),
        Subproblem.new(
          [ TextLabel.new("Finally, we multiply the coefficient we found in the last step by the " +
              " #{f_s[@missing_i % 2]} part of the reduced ratio to find the missing #{f_s[@missing_i % 2]} part!"),
            TextField.new("ans", "#{uk[0] / rat[0]} \u00D7 #{rat[@missing_i % 2]} = ") ],
          {"ans" => @p[@missing_i]} ),
        Subproblem.new([TextLabel.new("And voila, the completed set of equivalent ratios:"),
                       TextLabel.new("#{@p[0]} : #{@p[1]} :: #{@p[2]} : #{@p[3]}") ], {} )
      ]
    end
  end # }}}

  PROPORTION_EXP = SubLabel.new("We say that 4 numbers are \"in proportion\" if the ratio of the first 2 is equivalent to the ratio of the second 2.")

  class CompleteTheProportion < QuestionWithExplanation # {{{
    include C12Initializers
    def self.type() "Complete the proportion" end

    def initialize(options = {})
      init_proportion(options)
      @missing_i = options[:missing_i] || rand(4) # the index in the proportion the student will be asked for
    end

    def solve
      {"ans" => @p[@missing_i]}
    end

    def text
      proportion = @p.map { |e| ["#{e}", ", "] }.flatten
      proportion.pop # take of trailing ,
      proportion[@missing_i * 2] = TextField.new("ans")
      [
        TextLabel.new("Complete the proportion:"),
        InlineBlock.new(proportion)
      ]
    end

    def explain
      proportion = @p.clone
      proportion[@missing_i] = "_"
      [
        PROPORTION_EXP,
        SubLabel.new("So completing the proportion of #{proportion.join(", ")} is equivalent to the following problem:"),
        FillInEquivRatios.new({:p => @p, :missing_i => @missing_i})
      ]
    end
  end # }}}

  class PriceProportions < QuestionWithExplanation # {{{
    include C12Initializers

    def self.type() "Prices in proportion" end

    def initialize(options= {})
      init_bob_and_jen(options)
      @modifier = options[:modifier] || (rand(2) - rand(2)) # -1, 0, 0, or 1 with equal prob
      @item = options[:item] || Items.generate
      @bob_n, @jen_n = options[:ratio] || MyChapter12.gen_ratio # number of items bob and jen bought
    end

    def bob_p() @item.price(@bob_n) end
    def jen_p() @item.price(@jen_n, @modifier) end

    def text
      [
        TextLabel.new("#{@bob} and #{@jen} went to the market to buy #{@item.s}."),
        TextLabel.new("#{@bob} bought #{@item.write(@bob_n)} for Rs #{bob_p}."),
        TextLabel.new("#{@jen} bought #{@item.write(@jen_n)} for Rs #{jen_p}."), 
        TextLabel.new("Did #{@bob}'s #{@item.s} cost the same amount as #{@jen}'s #{@item.s}?"),
        RadioButton.new("ans", "Yes", "No")
      ]
    end

    def solve
      { "ans" => (@modifier == 0) ? "Yes" : "No" }
    end

    def explain
      ret = [
        SubLabel.new("To figure out if #{@bob} and #{@jen}'s #{@item.s} cost the same price, let's take a look at a couple ratios. " +
         "First, the ratio of #{@item.s} #{@ob} bought to those #{@jen} bought:"),
        ReduceRatio.new(@bob_n, @jen_n),
        SubLabel.new("Now let's take a look at the ratio of the prices:"),
        ReduceRatio.new(bob_p, jen_p),
      ]

      if @modifier == 0
        ret.concat([
          SubLabel.new("So we can now say that #{@item.write(@bob_n)} : #{@item.write(@jen_n)} :: " +
            "#{bob_p} : #{jen_p}, or that the numbers #{@bob_n}, #{@jen_n}, #{bob_p}, #{jen_p} form a proportion."),
          SubLabel.new("What this means is that the ratio of the #{@item.pluralize} = the ratio of their cost! That means "+
            "that #{@bob} and #{@jen} bought their #{@item.s} at the same rate.")
        ])
      else
        ret << SubLabel.new("So the ratio of the prices isn't equivalent to the ratio of the #{@item.pluralize}.  That means that" +
            " #{@bob} and #{@jen} didn't buy their #{@item.s} at the same rate!")
      end
      ret
    end
  end # }}}

  class PricePerUnit < QuestionWithExplanation # {{{
    def self.type() "Calculating Unit Prices" end

    def initialize(options = {})
      @a = options["a"] || MyChapter12.gen_ratio[0]
      @item = options["item"] || Items.generate
      # price_mod is added to the base price/unit of the item
      @price_mod = options["price_mod"] || rand(2) - rand(2) 
    end

    def text
      [
        TextLabel.new("Find the unit price of #{@item.s}, if #{@item.write(@a)} cost Rs #{@item.price(@a,@price_mod)}"),
        TextField.new("ans", "Rs per #{@item.singular}")
      ]
    end

    def solve
      { "ans" => @item.price(1, @price_mod) }
    end

    def explain
      [
        SubLabel.new("The unit price is the cost of one unit of #{@item.s}, or in this case just #{@item.write(1)}."),
        Subproblem.new(
          [ TextLabel.new("So just divide the price (Rs #{@item.price(@a, @price_mod)}), by the number of #{@item.pluralize} (#{@a})"),
            TextField.new("ans", "Rs per #{@item.singular}")
          ], solve ),
        SubLabel.new("Check out how the unit cost is like a ratio - it's like the ratio of the price to the number of items... But wait, this violates the rule that ratios have to share units! It's really just a fraction that we can use for conversions ")
      ]
    end
  end # }}}

  class UnitaryCompareSize < QuestionWithExplanation # {{{
    def self.type() "Prices with the Unitary Method" end

    def initialize(options = {})
      @a, @b = options["ratio"] || MyChapter12.gen_ratio
      @item = options["item"] || Items.generate
      # price_mod is added to the base price/unit of the item
      @price_mod = options["price_mod"] || rand(2) - rand(2) 
    end

    def text
      [
        TextLabel.new("If #{@item.write(@a)} cost Rs #{@item.price(@a, @price_mod)}, how much do #{@item.write(@b)} cost?"),
        TextField.new("ans", "Rs ")
      ]
    end

    def solve
      { "ans" => @item.price(@b, @price_mod) }
    end

    def explain
      [
        SubLabel.new("One way we could find out how much #{@item.write(@b)} cost would be to complete the proportion they would form, but sometimes that can be tough to do in your head, so there's actually an easier way which we call the Unitary Method."),
        SubLabel.new("The Unitary Method is finding the value of one \"unit\", and then you can use that to get the value how ever many units you want."),
        PricePerUnit.new({"a" => @a, "item" => @item, "price_mod" => @price_mod}),
        Subproblem.new(
          [ TextLabel.new("Now it's easy to calculate the price of any amount of #{@item.s} - just multiply the number of units by the price per unit.  If you have #{@item.write("n")}, then you can find the price with"),
            InlineBlock.new(
              "#{@item.write("n")} \u00D7 ", 
              Fraction.new(@item.price(1,@price_mod), TextLabel.new(@item.write(1))),
              "= the price in Rs of #{@item.write("n")}"
            ),
            TextLabel.new("Now find the price of #{@item.write(@b)}"),
            TextField.new("ans", "Rs")
        ], solve )
      ]
    end
  end # }}}

  PROBLEMS = [
    DefRatio,
    GetEquivalentFraction,
    ReduceRatio,
    RatioToFractionOfTotal,
    RatiosAndTotals,
    RatiosAndUnits,
    EquivalentRatios,
    FillInEquivRatios,
    CompleteTheProportion,
    PriceProportions,
    UnitaryCompareSize
  ]
end
