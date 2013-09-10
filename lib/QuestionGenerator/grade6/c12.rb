require_relative '../questionbase'
require_relative '../tohtml'
require_relative '../modules/names'
require_relative '../modules/units'
require_relative '../modules/items'

include ToHTML

module Chapter12
  INDEX = 12
  TITLE = "Ratios"

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
    Chapter12.gen_irreducible_ratio.map { |x| x * c }
  end

  def self.ratio_field(name)
    InlineBlock.new(TextField.new("#{name}_a"), 
                    TextLabel.new(" : "),
                    TextField.new("#{name}_b")
                   )
  end

  def self.rat_eq(*args)
    ratios = []
    begin
      while(ratios.length < 2) do
        r = args.shift
        if r.is_a?(Rational)
          ratios << r
        else
          r2 = args.shift
          ratios << Rational(r, r2)
        end
      end
      return ratios[0] == ratios[1]
    rescue
      return false
    end
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
      a, b = options[:ratios] || Chapter12.gen_irreducible_ratio # the ratio used in the proportion
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
        @a, @b = Chapter12.gen_ratio
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
      b=1 if b==''
      return false if b == 0
      Chapter12::rat_eq(a.to_i, b.to_i, @a, @b)
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
        @n, @m = Chapter12::gen_ratio
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
      m=1 if m==''
      return Chapter12::rat_eq(n, m, @n, @m)
    end
  end
  # }}}

  class RatioToFractionOfTotal < QuestionWithExplanation # {{{
    def self.type() "Turn a ratio into a fraction of the total" end

    def initialize(a = nil, b = nil, options = {})
      if a.nil? || b.nil?
        @a, @b = Chapter12.gen_ratio
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
        @a, @b = Chapter12.gen_ratio
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
        Chapter12.ratio_field("ans")
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
    def self.type() "Quantities from a ratio and total" end

    # t is the total quanty (Fixnum)
    # r is the ratio        (Rational)
    def initialize(t = nil, r = nil)
      if t.nil? || r.nil?
        @r = Rational(*Chapter12.gen_irreducible_ratio)
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

      @nums = Array.new(@units.length) { |i| Chapter12::gen_ratio[0] }
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
        correct &= Chapter12::rat_eq(a, b, r)

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
      Array.new(@num_ratios) { |i| Chapter12.ratio_field(i.to_s) }
    end
  end # }}}

  class EquivalentRatios < QuestionWithExplanation # {{{
    include EquivalentRatiosMethods

    def self.type() "Name equivalent ratios" end

    def initialize(a = nil, b = nil, num_ratios = nil)
      if a.nil? || b.nil?
        @a, @b = Chapter12.gen_ratio
      else
        @a, @b = a, b
      end
      @num_ratios = num_ratios || 2 + rand(2)
    end

    def text
      txt = [
        TextLabel.new("Name #{@num_ratios} ratios equivalent to #{@a} : #{@b}")
      ] + Array.new(@num_ratios) { |i| Chapter12.ratio_field(i.to_s) }
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
      @bob_n, @jen_n = options[:ratio] || Chapter12.gen_ratio # number of items bob and jen bought
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
      @a = options["a"] || Chapter12.gen_ratio[0]
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
      @a, @b = options["ratio"] || Chapter12.gen_ratio
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

  SUNIT=["mm", "grams", "ml", "cm", "meters", "paise"]
  LUNIT=["cm", "kg", "liter", "meters", "km", "rupees"]
  UCON={"mm" => 10,
    "grams" => 1000,
    "ml" => 1000,
    "cm" => 100,
    "meters" => 1000,
    "paise" => 100}

  class FindRatioSame < QuestionWithExplanation
    def initialize
      units=Set.new(SUNIT+LUNIT)
      tm1=rand(2)
      if(tm1==0)
        @unit=" "
      else @unit=" #{units.to_a.sample} "
      end
      rat=Grade6ops::chCommPF
      if(rand(2)==0)
        tm=rat[0]
        rat[0]=rat[1]
        rat[1]=tm
      end
      @rat=rat
      @n1=rat[0].reduce(:*)
      @n2=rat[1].reduce(:*)
      @co=rat[2].reduce(:*)
    end
    def explain
      [SubLabel.new("This is essentially the same as reducing the fraction #{@n1}/#{@n2} to its lowest form"), Chapter7::ReduceFractions.new(@rat[0], @rat[1], @rat[2])]
      def solve
        {"ans1" => @n1/@co, "ans2" => @n2/@co}
      end
      def text
        [TextLabel.new("Find the ratio of #{@n1}#{@unit}to #{@n2}#{@unit}in its lowest form"), InlineBlock.new(TextField.new("ans1"), TextLabel.new(" : "), TextField.new("ans2"))]
      end
    end 
  end


  class FindRatioDiff < QuestionWithExplanation
    def initialize
      @lunit=LUNIT.sample
      @sunit=SUNIT[LUNIT.index(@lunit)]
      rat=Grade6ops::chCommPF
      if(rand(2)==0)
        tm=rat[0]
        rat[0]=rat[1]
        rat[1]=tm
      end
      @n1=rat[0].reduce(:*)
      @n2=rat[1].reduce(:*)
      @co=rat[2].reduce(:*)
      @rat=rat
      @wh=rand(2)
    end
    def explain
      [SubLabel.new("First convert to the same units. Try converting #{@n1*UCON[@sunit]} #{@sunit} to #{@lunit}"), Chapter8::UnitsDecIncrease.new(@sunit, @n1*UCON[@sunit]), Chapter12::FindRatioSame.new(@rat[0],@rat[1],@rat[2])]
      def solve
        {"ans1" => @n1/@co, "ans2" => @n2/@co}
      end
      def text
        str="#{@n1} #{@lunit} to #{@n2*UCON[@sunit]} #{@sunit}" if @wh==0
        str="#{@n1} #{@sunit} to #{@n2*UCON[@sunit]} #{@lunit}" if @wh==1
        [TextLabel.new("Find the ratio of #{str} in its lowest form"), InlineBlock.new(TextField.new("ans1"), TextLabel.new(" : "), TextField.new("ans2"))]
      end
    end
  end




	class SumRat
		def initialize(subs, nums, tot)
			@subs=subs
			@nums=nums
			@tot=tot
		end

		def str_long
			ret=[]
			for i in 0...@subs.length
				ret << "What is the ratio of the number of "+@subs[i] + " to the total number of " +@tot
				for j in 0...@subs.length
					if i!=j
						ret << "What is the ratio of the number of "+@subs[i] +" to the number of " +@subs[j]
					end
				end
			end
			ret	
		end
		def str_short
			ret=[]
			for i in 0...@subs.length
				ret << "Number of "+@subs[i] + " to the total number of " +@tot
				for j in 0...@subs.length
					if i!=j
						ret << "Number of "+@subs[i] +" to the number of " +@subs[j]
					end
				end
			end
			ret	
		end
		def solve
			ret={}
			k=0
			for i in 0...@nums.length
				ret["num"+k.to_s]=Rational(@nums[i],@nums.reduce(:+)).numerator
				ret["den"+k.to_s]=Rational(@nums[i],@nums.reduce(:+)).denominator
				k+=1
				for j in 0...@nums.length
					if i!=j
						ret["num"+k.to_s]=Rational(@nums[i],@nums[j]).numerator
						ret["den"+k.to_s]=Rational(@nums[i],@nums[j]).denominator
						k+=1
					end
				end
			end
			ret
		end
	end

	class RatioStudent < QuestionBase
		SUBS=[["girls","boys"], ["students who like cricket", "students who like football", "students who like hockey"], ["Babli saved", "Babli spent"], ["girls", "boys"]]
	  MAX=[30, 30, 2000, 2000]
    UNTS=["",""," rupees that ", ""]
	  TOT=["students", "students", "rupees", "students"]	
	  WHERE=["in the class", "in the class", "earned by Babli", "in the school"] 
		def initialize
			@ch=rand(SUBS.length)
			@wh=rand(2)
			@many=[]
			for i in 0...SUBS[@ch].length
				@many << rand(MAX[@ch])+5	
			end
			@rat=SumRat.new(SUBS[@ch],@many, TOT[@ch]+" "+WHERE[@ch])
		end
		def solve
			@rat.solve
		end
		def text
			ret=[]
			blank=rand(SUBS[@ch].length+1)
			str=""
			if blank!=SUBS[@ch].length
				str+="A total of "+@many.reduce(:+).to_s+" "+TOT[@ch]+" are " +WHERE[@ch] + ". Out of this, "
			else 
				str+="The "+@many.reduce(:+).to_s+TOT[@ch]+" "+WHERE[@ch]+" includes "  
			end
			pre=[]
			for i in 0...SUBS[@ch].length
				if i!=blank
					pre << @many[i].to_s+UNTS[@ch]+" "+SUBS[@ch][i]
				end
			end
			pre
      if pre.length > 2
#        puts "here"
			  str += pre.slice(0,pre.length-1).join(", ")+" and "+pre.last
      else str+= pre[0]
      end

			if blank!=SUBS[@ch].length
				str << ". The rest are " +SUBS[@ch][blank]
			end
			if @wh==0
				tex=@rat.str_long
			else
				tex=@rat.str_short
				str+=". Find the ratio of:"
			end
			ret << TextLabel.new(str)
			for i in 0...tex.length
        tab= TableField.new("ans", 1, 3)
        tab.set_field(0,0,TextField.new("num"+i.to_s))
        tab.set_field(0,1,TextLabel.new(":"))
        tab.set_field(0,2,TextField.new("den"+i.to_s))
        ret << tab
				ret << TextLabel.new((i+1).to_s+". "+tex[i])
				
			end
			ret		
		end
	end

	UNITS=["g","kg","m","cm","mm","km","litre","ml","sec","min", "hr", "Rupees"]
	MAXPROP=60
	class Proportion < QuestionBase
		def initialize
			@unit1=UNITS.sample
			@unit2=UNITS.sample
			@nums1=[rand(MAXPROP)+2,rand(MAXPROP)+2]
			@nums2=[@nums1[0],@nums1[1]]
			if rand(2)==0
				while @nums1[0]==@nums2[0]
					mult=rand(10)+2
					@nums2=[Rational(@nums1[0],@nums1[1]).numerator*mult , Rational(@nums1[0],@nums1[1]).denominator*mult]
				end
			else
				@nums2=[rand(MAXPROP)+2,rand(MAXPROP)+2]
			end
			@wh=rand(4)
		end
		def solve
			return {"ans" => "True"} if  Chapter12::rat_eq(@nums1[0],@nums1[1], @nums2[0],@nums2[1])
			return {"ans" => "False"}
		end
		def text
			str=[]
			if @wh==0
				str=[TextLabel.new(@nums1.join(", ")+", "+@nums2.join(", ")+ " are in proportion. True or False?")]
      elsif @wh==1
        str=[TextLabel.new(@nums1.join(":")+"::"+@nums2.join(":") + ". True or False?")]
      elsif @wh==2
        str=[TextLabel.new(@nums1[0].to_s+" "+@unit1+" : "+ @nums1[1].to_s + @unit1 +" = "+ @nums2[0].to_s+@unit2+" : "+@nums2[1].to_s + @unit2 +". True or False?")]
      elsif @wh==3
        str=[TextLabel.new(@nums1[0].to_s+" "+@unit1+" : "+ @nums1[1].to_s + @unit1 + " and "+ @nums2[0].to_s+@unit2+" : "+@nums2[1].to_s+ @unit2 +" are in proportion. True or False?")]
      end
      str << RadioButton.new("ans", ["True", "False"])
      str
    end
  end

  class UnitaryWord
    attr_accessor :wh2
    NAMES=["Babloo", "Babli"]
    VERBS=["costs", "cost", "is", "weigh", "weighs"]
    NOUNS={"costs" => [["meters", "cloth"], ["kilograms", "wheat"]],
      "cost" => [["bushels", "apples"], ["boxes", "oranges"], ["dozen bananas"]],
      "is" => [["months", "name1's rent"], ["days", "name1's salary"]],
      "weigh" => [["books"], ["apples"], ["oranges"],["bushels", "wheat"], ["planks", "wood"]]}
    VERBNOUN={"costs" => "the cost of", 
      "cost" => "the cost of",
      "weigh" => "the weight of",
      "weighs" => "the weight of",
      "is" => ["name1's rent for", "name1's salary for"]}
    UNS={"costs" => "Rs.",
      "cost" => "Rs.",
      "weigh" => "kg",
      "is" => ["Rs.","Rs."]}

    def initialize(cam,fam,mul,wh=rand(VERBS.length),wh2=nil)
      @wh=wh
      @wh2=wh2
      @wh2=rand(NOUNS[VERBS[@wh]].length) if @wh2==nil
      @cam=cam
      @fam=fam
      @mul=mul
    end
    def str
      verb=VERBS[@wh]
      no=NOUNS[verb][@wh2]
      noun=no.last
      uns=""
      uns=no.first + " of " if no.length > 1
      st=@cam.to_s+ " " + uns + noun + " " + verb
      units=UNS[verb]
      units=units[@wh2] if Array.try_convert(units)!=nil
      if units=="Rs."
        st+=" " + units + " " + ( @cam * @mul ).to_s 
      else st+=" "+(@cam*@mul).to_s+ " "+units
      end
      verbn=VERBNOUN[verb]
      verbn=verbn[@wh2] if Array.try_convert(verbn) != nil
      st+=". What is "+verbn +" "+@fam.to_s+" "+uns +noun
      name=NAMES.sample
      while st.index("name1")!=nil
        st=st.slice(0,st.index("name1")) + name + st.slice(st.index("name1")+5, st.length)
      end

      st+="?"
      st
    end
    def str_first
      verb=VERBS[@wh]
      no=NOUNS[verb][@wh2]
      noun=no.last
      uns=""
      uns=no.first + " of " if no.length > 1
      st=@cam.to_s+ " " + uns + noun + " " + verb
      units=UNS[verb]
      units=units[@wh2] if Array.try_convert(units)!=nil
      if units=="Rs."
        st+=" " + units + " " + ( @cam * @mul ).to_s 
      else st+=" "+(@cam*@mul).to_s+ " "+units
      end
      st
    end
    def str_opp
      verb=VERBS[@wh]
      no=NOUNS[verb][@wh2]
      noun=no.last
      uns=""
      uns=no.first + " of " if no.length > 1
      st=@cam.to_s+ " " + uns + noun + " " + verb
      units=UNS[verb]
      units=units[@wh2] if Array.try_convert(units)!=nil
      if units=="Rs."
        st+=" " + units + " " + ( @cam * @mul ).to_s 
      else st+=" "+(@cam*@mul).to_s+ " "+units
      end
      verbn=VERBNOUN[verb]
      verbn=verbn[@wh2] if Array.try_convert(verbn) != nil
      st+=". How many "+ uns + noun + " " + verb +" "
      if units=="Rs."
        st+= "Rs." + (@fam*@mul).to_s
      else st+= (@fam*@mult).to_s +" "+units
      end
      name=NAMES.sample
      while st.index("name1")!=nil
        st=st.slice(0,st.index("name1")) + name + st.slice(st.index("name1")+5, st.length)
      end
      st+="?"
      st
    end
  end 

  MAXUNITARY=40
  class UnitaryMethod < QuestionBase
    def initialize
      @camt=rand(MAXUNITARY)+3
      @famt=@camt
      while @famt==@camt
        @famt=rand(MAXUNITARY)+3
      end
      @mult=rand(MAXUNITARY)+3
      @txt=UnitaryWord.new(@camt, @famt, @mult)
      @ch=rand(2)
    end

    def solve
      return {"ans" => @famt*@mult} if @ch==0
      {"ans" => @famt}
    end

    def text
      str=""
      if @ch==0
        str=@txt.str
      else str=@txt.str_opp
      end
      return [TextLabel.new(str), TextField.new("ans")]
    end
  end
  COUNTRIES = ["India", "Pakistan", "Bangladesh", "China", "Afghanistan"]
  class RatioCompCostWord < QuestionBase
    def initialize
      @num1=rand(MAXUNITARY)
      @num2=rand(MAXUNITARY)
      @mult1=rand(MAXUNITARY)
      @mult2=rand(MAXUNITARY)
      @ch=rand(2)
      @txt1=UnitaryWord.new(@num1,0, @mult1, @ch)
      @txt2=UnitaryWord.new(@num2,0, @mult2, @ch, @txt1.wh2)
      @c1=COUNTRIES.sample
      @c2=@c1
      while @c1==@c2
        @c2=COUNTRIES.sample
      end
    end

    def solve
      return {"ans" => @c1} if @mult1 > @mult2
      {"ans" => @c2}
    end

    def text
      [TextLabel.new(@txt1.str_first + " in " + @c1 + ". "+@txt2.str_first + " in " + @c2 + ". Where is it more expensive per unit?"), RadioButton.new("ans", @c1, @c2)]
    end
  end

  # PROBLEMS=[ # Chapter12::FindRatioSame, 
  #     Chapter12::RatioStudent, Chapter12::Proportion, Chapter12::UnitaryMethod, Chapter12::RatioCompCostWord]

  PROBLEMS = [
    DefRatio,
    GetEquivalentFraction,
    ReduceRatio,
    RatioToFractionOfTotal,
    RatioStudent, # madhav's
    RatiosAndTotals,
    RatiosAndUnits,
    EquivalentRatios,
    FillInEquivRatios,
    CompleteTheProportion,
    PriceProportions,
    Proportion, #madhav
    UnitaryCompareSize
  ]
  
end
