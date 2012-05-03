
module Grade6ops
  MAX_ROMANNUM = 3999
  MIN_ROMANNUM = 20
  OPS = [:+, :-, :*, :/]

  def Grade6ops.divgen(div)
    odds=rand(2)
    return div*(rand(1000)+1000) if odds==0
    return rand(20000)+1000
  end
  
  def Grade6ops.factors(primes)
    factors = []
    for i in 0..(2**primes.length-1) do
      factor = 1
      for j in 0...primes.length do
        factor *= primes[j] if ((2**j) & i) > 0
      end
      factors << factor
    end
    factors.uniq.sort
  end

  # gen a random digit with a greater than average weighted chance to be 0
  def Grade6ops.w_rand_dig(p_zero = 0.33)
    p_nonzero = 1.0 - p_zero
    int_range = (9.0/p_nonzero).to_i
    ret = rand(int_range) + 1
    ret = 0 if ret >= 10
    ret
  end

  # gen a random digit that isn't zero
  def Grade6ops.rand_nonzero
    rand(9) + 1
  end

  # generate a number with a random number of digits, each save the first with ~= p_zero chance of being 0
  def Grade6ops.rand_num(p_zero = 0.43, minlen = 7, maxlen = 8)
    len = minlen + rand(maxlen + 1 - minlen)
    tmp = Array.new(len).map { w_rand_dig(p_zero) }
    tmp[0] = rand_nonzero
    tmp.join.to_i
  end

  def Grade6ops.random_elt(*args)
    args[rand(args.length)]
  end

  def Grade6ops.random_operation
    OPS[rand(OPS.length)] 
  end
  def Grade6ops.euclideanalg(a,b)
    x=a.to_i
    y=b.to_i
    if x<y
      w=x
      x=y
      y=w
    end
    while y != 0
      r = x % y
      x = y
      y = r
    end
    x=-x if x<0 && (a>0 || b>0)
    return x
  end

  def Grade6ops::asfractions(num, den, sig)
    #sig is whether each is addition or subtraction. size is one less than num and den
    prod=den.reduce(:*)
    nsum=num[0]*(prod/den[0])

    for i in 1...den.length
      nsum+=sig[i-1]*num[i]*(prod/den[i])
    end
    hcf=1
    if nsum>prod
      hcf=Grade6ops::euclideanalg(nsum,prod)
    else
      hcf=Grade6ops::euclideanalg(prod,nsum)
    end
    return {:num => nsum/hcf,
      :den => prod/hcf}
  end
  class RegShapes
    attr_accessor :side
    attr_reader :numsides
    def initialize(numsides, side=nil)
      @numsides=numsides
      @side=side
    end  
    def perimeter()
      @side*@numsides
    end
    def area()
      #Only square for now
      return @side**2 if @numsides==4
    end
  end
  class Rectangle
    attr_accessor :width, :length
    def initialize(width, length)
      @width=width
      @length=length
    end
    def perimeter()
      2*(width+length)
    end
    def area()
      width*length
    end
  end
  class Triangle
    attr_accessor :s1, :s2, :s3
    def initialize(s1,s2,s3)
      @s1=s1
      @s2=s2
      @s3=s3
    end
    def perimeter
      s1+s2+s3
    end
  end

  class Isoceles
    attr_accessor :eqside, :oside
    def initialize(eq,ot)
      @eqside=eq
      @oside=ot
    end
    def perimeter()
      2*@eqside+@oside
    end
  end

      
end

class Fixnum
  @@intNumeralNames = 
    { 1 => "one",
      2 => "two",
      3 => "three",
      4 => "four",
      5 => "five",
      6 => "six",
      7 => "seven",
      8 => "eight",
      9 => "nine",
      10 => "ten",
      11 => "eleven",
      12 => "twelve",
      13 => "thirteen",
      14 => "fourteen",
      15 => "fifteen",
      16 => "sixteen",
      17 => "seventeen",
      18 => "eighteen",
      19 => "nineteen",
      20 => "twenty",
      30 => "thirty",
      40 => "forty",
      50 => "fifty",
      60 => "sixty",
      70 => "seventy",
      80 => "eighty",
      90 => "ninety",
      100 => "hundred",
      1000 => "thousand",
      1000000 => "million",
      1000000000 => "billion",
      1000000000000 => "trillion" }

  @@indNumeralNames = 
    { 1 => "one",
      2 => "two",
      3 => "three",
      4 => "four",
      5 => "five",
      6 => "six",
      7 => "seven",
      8 => "eight",
      9 => "nine",
      10 => "ten",
      11 => "eleven",
      12 => "twelve",
      13 => "thirteen",
      14 => "fourteen",
      15 => "fifteen",
      16 => "sixteen",
      17 => "seventeen",
      18 => "eighteen",
      19 => "nineteen",
      20 => "twenty",
      30 => "thirty",
      40 => "forty",
      50 => "fifty",
      60 => "sixty",
      70 => "seventy",
      80 => "eighty",
      90 => "ninety",
      100 => "hundred",
      1000 => "thousand",
      100000 => "lakh",
      10000000 => "crore",
      1000000000 => "arab" }

  def to_international
    to_numeral(@@intNumeralNames, :int_tens?, :int_hund?)
  end

  def to_indian
    to_numeral(@@indNumeralNames, :ind_tens?, :ind_hund?)
  end

  def int_commas
    # TODO this shouldn't make a number start with a comma
    to_s.reverse.gsub(/([0-9]{3})/, '\1,').reverse
  end

  def ind_commas
    # TODO this shouldn't make a number start with a comma
    return to_s if to_i < 1000
    under_thousand = to_s[-3..-1]
    over_thousand = to_s[0...-3].reverse.gsub(/([0-9]{2}(?!$))/, '\1,').reverse
    "#{over_thousand},#{under_thousand}"
  end

  def has_big_numeral(digit_count, numerals)
    rev_s = to_s.reverse
    return true unless rev_s[digit_count] == "0"

    num = 10**digit_count
    for i in (digit_count+1)...(digit_count+3)
      return false unless numerals[(10**i)] == nil
      return true unless rev_s[i] == "0"
    end
    false
  end

  def gen_rule
    number=to_i
    len=number.to_s.length
    div=10**(len-1)
    est=(number/div)*div
    if number-est<(est+div)-number
      return est
    else return est+div
    end
  end

  def round(rd=-1)
    return gen_rule if rd==-1
    number=to_i
    div=10**rd
    est=(number/div)*div
    if number-est<(est+div)-number
      return est
    else return est+div
    end
  end

  @@roman=
    {1 => "I",
      4 => "IV",
      5 => "V",
      9 => "IX",
      10 => "X",
      40 => "XL",
      50 => "L",
      90 => "XC",
      100 => "C",
      400 => "CD",
      500 => "D",
      900 => "CM",
      1000 => "M"}

  def to_roman
    number = to_i     
    rom=""
    @@roman.keys.sort{ |a,b| b <=> a }.each do |n|
      while number >= n
        number = number-n
        rom= rom +@@roman[n]
      end
    end
    return rom
  end

  private

  def to_numeral(numerals, ten, hund)
    number = to_s
    wordrep_acc = [numerals[(number[-1]).to_i]]
    digit_count = 1
    number_digits_reversed = number.chop.reverse

    number_digits_reversed.chars.each_with_index do |digit, index|
      # if we're in the thousands, lakh, crore, etc, add that in, UNLESS there are 2-3 0's up next
      if digit_count >= 3 && numerals[(10**(digit_count.to_i))] != nil
        if has_big_numeral(digit_count, numerals)
          wordrep_acc << numerals[(10**(digit_count.to_i))]
        end
      end

      # now process the actual digit's name
      unless digit == "0"
        digit_as_number = Integer(digit)
        prev_digit = number_digits_reversed[index - 1]

        # elsif we are in one of the 10's slots in the indian system of numeration
        if Fixnum.send(ten, digit_count)
          if digit_as_number == 1 # we are going to do a teen
            lookup_num = Integer("#{digit}#{prev_digit}")
            if prev_digit == "0"
              wordrep_acc << numerals[lookup_num]
            else
              wordrep_acc[-1] = numerals[lookup_num]
            end
          else # we are going to do a twenty something or thirtysomething or whatever
            wordrep_acc << numerals[digit_as_number*10]
          end

          # elsif we are in one of the 100's slots
        elsif Fixnum.send(hund, digit_count)
          wordrep = "#{numerals[digit_as_number]} #{numerals[100]}"
          wordrep += " and" if prev_digit != "0" || number_digits_reversed[index - 2] != "0"
          wordrep_acc << wordrep

          # else we are essentially in a one's slot
        else 
          wordrep_acc << numerals[digit_as_number]
        end

      end
      digit_count += 1
    end
    ret = wordrep_acc.reverse.join(" ")

    # TODO make a better solution to this shit of having and at the end
    # of some numbers: eg:
    # "ninety million six hundred and five thousand five hundred and"
    ret.sub(/\s+and\s*$/, "").strip
  end

  def self.ind_tens?(digit_count)
    (digit_count >= 4 && digit_count % 2 == 0) || (digit_count == 1)
  end

  def self.int_tens?(digit_count)
    (digit_count - 1) % 3 == 0
  end

  def self.int_hund?(digit_count)
    digit_count % 3 == 2
  end

  def self.ind_hund?(digit_count)
    digit_count == 2 || digit_count == 9
  end
end

class String
  @@roman=
    {"M" => 1000,
      "CM" => 900,
      "D" => 500,
      "CD" => 400,
      "C" => 100,
      "XC" => 90,
      "L" => 50,
      "XL" => 40,
      "X" => 10,
      "IX" => 9,
      "V" => 5,
      "IV" => 4,
      "I" => 1}

  def to_arabic
    number=to_s
    reply = 0
    for key, value in @@roman
      while number.index(key) == 0
        reply += value
        number.slice!(key)
      end
    end
    reply
  end
end
