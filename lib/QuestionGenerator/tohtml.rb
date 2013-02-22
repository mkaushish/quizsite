#!/usr/bin/env ruby

module ToHTML
  PREFIX = "qbans_"
  
  SYMBOL={:equals => '=',
          :notequals => '!='
          }


  def ToHTML.add_prefix(s)
    s.gsub(/^(?!#{ToHTML::PREFIX})/, ToHTML::PREFIX)
  end

  def ToHTML.rm_prefix(s)
    s.sub(/^#{ToHTML::PREFIX}/, "")
  end

  def ToHTML.prefix_for_tohtml(s)
    add_prefix(s)
  end

  def ToHTML.prefix_for_questionbase(s)
    rm_prefix(s)
  end

  class HTMLObj
    attr_accessor :tags
    # This method is passed a solution hash and a response hash, and must test whether
    # the part the solution and response hashes which represent this problem are correct
    def correct?(solution, response)
    end

    def partial
      "single/#{self.class.to_s.split("::")[1].downcase}"
    end

    # use the problem view for the anwer - not true for input fields
    def answer_view?() false ; end

    # potentailly display both the correct and incorrect version in the answer
    def contains_response_and_soln?() false ; end
  end

  class MultiHTMLObj
    # This method is passed a solution hash and a response hash, and must test whether
    # the part the solution and response hashes which represent this problem are correct
    def correct?(solution, response)
      raise "subclasses of MultiHTMLObj must implement correct?!"
    end
    
    def partial
      "multi/#{self.class.to_s.split("::")[1].downcase}"
    end

    def answer_view?() false ; end
    def contains_response_and_soln?() false ; end
  end

  # MULTIOBJS: objects with multiple HTMLObjs
  class Fraction < MultiHTMLObj
    attr_accessor :num, :den, :intpart

    # The initializer normally takes in two HTMLObj's for the top and bottom part, but there are two exceptions
    # if num/den is a string, initialize will assume you want a TextField with that name
    # if num/den is a Fixnum, initialize will assume you want a TextLabel of the number on top
    def initialize(num, den, intpart=nil)
      @num = init_part num
      @den = init_part den
      @intpart = init_part intpart
      raise "Fraction must be passed a numerator in it's constructor" if @num.nil?
      raise "Fraction must be passed a denomenator in it's constructor" if @den.nil?
    end

    def hasinput?
      !(@num.is_a?(ToHTML::TextLabel) && @num.is_a?(ToHTML::TextLabel) &&
        (@intpart.nil? || @intpart.is_a?(ToHTML::TextLabel)))
    end

    def addintpart(intpart)
      @intpart = init_part intpart
    end

    def correct?(solution, response)
      [ @intpart, @num, @den ].map { |elt| elt.nil? || elt.correct?(solution, response) }.reduce(:&)
    end

    private

    def init_part(elt)
      if elt.is_a?(Fixnum) 
        return ToHTML::TextLabel.new(elt)
      elsif elt.is_a?(String)
        return ToHTML::TextField.new(elt)
      elsif elt.is_a? HTMLObj
        return elt
      else
        return nil
      end
    end
  end

  # Will display a text field, and give the user the option of adding more text fields for more answers
  #
  # The name of each field in the stored hash will be "#{name}#{x}, where x is the input field number (can be arbitrary if the user
  # add's fields in the wrong order)
  class MultiTextField < MultiHTMLObj
    attr_reader :name, :num

    # params:
    #   * name => prefix, like everything else in this module
    #   * num  => starting number of html fields (should be a fixnum >= 1)
    # will display num TextFields with the option of adding more
    def initialize(name, num = 1)
      @name = ToHTML::add_prefix name
      @num = num
    end
    def answer_view?() true ; end

    def each_name
      @num.times do |i|
        yield "#{name}_#{i}"
      end
    end

    def each_orig_field
      each_name { |fieldname| yield TextField.new(fieldname) }
    end

    # iterates over the keys of the hashes that are valid names for this MultiTextField
    # does this in order
    # at each iteration returns a TextField of the the name given
    def each_field
      each_name do |fieldname|
        yield SubTextField.new(fieldname)
      end
    end

    def length_from_hash(hash)
      @num = hash_to_arr(hash).length
    end

    # iterates over all the possible field names for this mutlitextfield
    # NOTE this WILL be an infinite loop, so you HAVE to break out of it
    def each_poss_field
      each_poss_name do |fieldname|
        yield SubText.new(fieldname)
      end
    end

    def each_poss_name(hash = nil)
      i = 0
      while true
        name = "#{@name}_#{i}"
        break if !hash.nil? && hash[name].nil?
        yield name
        i += 1
      end
    end

    def is_name(tfname)
      ToHTML::rm_prefix(tfname) =~ /^#{name}_[0-9]+$/
    end

    def hash_to_arr(hash)
      return hash[@name] if(hash[@name].is_a? Array)
      ret = []
      each_poss_name do |field|
        break if hash[field].nil?
        ret << hash[field]
      end
      return ret
    end

    def correct?(solution, response)
      hash_to_arr(solution).sort == hash_to_arr(response).sort
    end
  end

  # Produces an HTML table of TextFields by default, although you can later set them to be
  # any HTMLObj
  #
  # If we call TableField.new("ans",2,3), the format will be as follows
  # +---------+---------+---------+
  # | ans_0_0 | ans_0_1 | ans_0_2 |
  # +---------+---------+---------+
  # | ans_1_0 | ans_1_1 | ans_1_2 |
  # +---------+---------+---------+
  #
  # where ans_i_j is by default a TextField at row i, column j, 0 based indexing
  #
  class TableField < MultiHTMLObj
    attr_reader :name, :nrows, :ncols, :table

    def initialize(name, rows, cols)
      @name = name
      @nrows = rows
      @ncols = cols
      @table = Array.new(rows) { Array.new(cols) { nil } }
    end

    # sets the field at row,col to val.  If val is a string, makes a new textlabel for val
    # FAIL SILENTLY! TODO fix this somehow
    def set_field(row, col, val)
      if val.is_a?(HTMLObj) || val.is_a?(Fraction)
        @table[row][col] = val
      elsif val.is_a?(String)
        @table[row][col] = TextLabel.new(val)
      end
    end

    #TODO allow to specify the top row and left row as labels/headers of the table

    def get_field(row, col)
      if @table[row][col].nil?
        TextField.new("#{@name}_#{row}_#{col}")
      else
        @table[row][col]
      end
    end

    def each_field
      @nrows.times do |row|
        @ncols.times do |col|
          yield get_field(row, col)
        end
      end
    end

    def each_column(row)
      @ncols.times do |col|
        yield get_field(row, col)
      end
    end

    def correct?(solution, response)
      each_field do |field|
        return false unless field.correct?(solution, response)
      end
      true
    end
  end

  class AddingField < MultiHTMLObj
    attr_reader :name, :num1, :num2, :sign
    def initialize(name, num1, num2, sign)
      @name = ToHTML::add_prefix name
      @num1=num1
      @num2=num2
      @sign=sign
    end
    def correct?(solution, response)
      return solution[@name]==response[@name]
    end
  end 

  class InlineBlock < MultiHTMLObj
    attr_reader :text
    def initialize(*args)
      if args[0].is_a?(Array)
        @text = args[0]
      else
        @text = args
      end

      @text.map! { |e| e.is_a?(String) ? TextLabel.new(e) : e }
    end

    def correct?(solution, response)
      @text.map { |t| t.correct?(solution,response) }.reduce(:&)
    end
  end

  class TallyMarksField < MultiHTMLObj
    attr_reader :name, :obs, :init, :edit
    def initialize(name, obs, init)
      @name=ToHTML::add_prefix name
      @obs=obs
      @init=init
      @edit="edit"
    end
    def correct?(solution, response)
      obs.length.times do |i|
        curn=@name+"_#{i}"
        return false unless solution[curn]==response[curn]
      end
      return true
    end
  end

  class TallyMarksLabel < TallyMarksField
    def partial
      "multi/tallymarksfield"
    end
    def initialize(name, obs, init)
      super(name, obs, init)
      @edit="noedit"
    end
    def correct?(solution, response)
      return true
    end
  end

  class BarGraphField < MultiHTMLObj
    attr_reader :name, :obs, :init, :edit, :divs, :editdivs
    def initialize(name, obs, init, varhsh)
      @name=ToHTML::add_prefix name
      @obs=obs
      @init=init
      @edit="edit"
      @editdivs=varhsh["editdivs"]
      @divs=varhsh["divs"]
    end
    def correct?(solution, response)
      obs.length.times do |i|
        curn=@name+"_#{i}"
        return false unless solution[curn]==response[curn]
      end
      return true
    end
  end

  class BarGraphLabel < BarGraphField
    def partial
      "multi/bargraphfield"
    end
    def initialize(name, obs, init, varhsh)
      super(name, obs, init, varhsh)
      @edit="noedit"
    end
    def correct?(solution, response)
      return true
    end
  end

  class InpNumberLine < MultiHTMLObj
    attr_reader :name, :val, :bigdiv
    def initialize(name, val, bigdiv)
      @name=ToHTML::add_prefix name
      @val=val
      @bigdiv=bigdiv
    end
    def correct?(solution, response)
      $stderr.puts solution[@name]
      $stderr.puts "*"*100
      $stderr.puts response[@name]
      solution[@name]==response[@name] 
    end
  end
  class MovNumberLine < MultiHTMLObj
    attr_reader :name, :val, :bigdiv
    def initialize(name, val, bigdiv)
      @name=ToHTML::add_prefix name
      @val=val
      @bigdiv=bigdiv
    end
    def correct?(solution, response)
      $stderr.puts solution[@name]
      $stderr.puts "*"*100
      $stderr.puts response[@name]
      solution[@name]==response[@name] 
    end
  end

  class TextTable < TableField
    def partial
      "multi/tablefield"
    end
    def initialize(table)
      @table = table.map { |row| row.map { |elt| TextLabel.new(elt) } }
      @nrows = table.length
      @ncols = table[0].length
    end
  end
  class RomanTable < TableField
    def partial
      "multi/tablefield"
    end
    def initialize(table)
      @table = table.map { |row| row.map { |elt| RomanLabel.new(elt) } }
      @nrows = table.length
      @ncols = table[0].length
    end
  end

  class TextLabel < HTMLObj
    def initialize(string)
      @string = string.to_s
    end

    def to_s
      @string
    end

    def correct?(solution, response)
      true
    end
  end
  class RomanLabel < HTMLObj
    def initialize(string)
      @string = string.to_s
    end

    def to_s
      @string
    end

    def correct?(solution, response)
      true
    end
  end

  class InputField < HTMLObj
    attr_reader :name

    def initialize(name)
      @name = ToHTML::add_prefix name
    end

    def fromhash(response)
      # the second part of the || is mostly for testing
      # Hopefully we shouldn't be getting many misses anyway
      response[@name] || response[ToHTML::rm_prefix @name]
    end

    def self.fromhash(name, response)
      response[ToHTML::add_prefix name] || response[name]
    end

    def correct?(solution, response)
      solution[name] == response[name]
    end

    def answer_view?() true ; end
  end

  class PermutationDrag < InputField
    attr_reader :name, :items
    # Either:
    #   PermutationDrag.new(name, item1, item2, ...)
    #   PermutationDrag.new(name, [item1, item2, ...])
    #   Fixnums/Strings can be moved, symbols have fixed positions
    def initialize(*args)
      @name = ToHTML::add_prefix args.shift

      if args[0].is_a?(Array)
        @items = args[0]
      else
        @items = args
      end
    end

    def fixed?(i)
      @items[i].is_a?(Symbol) ? "fixed" : nil
    end

    def items_from(response)
      if !response[@name].nil?
        return response[name].split(',')
      else
        return Array.new(@items.length) do |i|
          response["#{@name}_#{i}"]
        end
      end
    end

    def correct?(solution, response)
      items_from(solution) == items_from(response)
    end
  end
  
  class PermutationDisplay < PermutationDrag
    def initialize(*args)
      super(*args)
    end
    def correct?(solution, response)
      true
    end
  end

  class Dropdown < InputField
    attr_reader :fields

    def initialize(name, *args)
      super(name)
      if args[0].is_a? Array
        @fields = args[0]
      else
        @fields = args
      end
    end

    def char_length
      @fields.inject(0) { |max, s| (s.length > max) ? s.length : max }
    end
  end

  class Checkbox < InputField
    attr_reader :label

    def initialize(name, label)
      super(name)
      @label = label.to_s
    end

    def correct?(solution, response)
      $stderr.puts "#{name}, #{solution[@name]}, #{response[@name]}"
      (solution[@name].nil? == response[@name].nil?)
    end
  end
  class Commabox < InputField

    def initialize(name)
      super(name)
    end

    def correct?(solution, response)
      solution[name]==response[name]
    end
  end

  class RadioButton < InputField
    attr_accessor :fields

    def initialize(name, *args)
      super(name)
      if args[0].is_a? Array
        @fields = args[0]
      else
        @fields = args
      end
    end
    def contains_response_and_soln?() true ; end
  end

  class TextField < InputField
    attr_reader :label, :maxlen
    def initialize(name, text = "", maxlen=1000)
      super(name)
      @label = text.to_s
      @maxlen=maxlen
    end

    def char_length(arg)
      len = 20
      if arg.is_a? QuestionBase
        ans = arg.prefix_solve[@name]
      elsif arg.is_a? Hash
        ans = arg[@name]
      elsif arg.respond_to? :problem
        ans = arg.problem.prefix_solve[@name]
      end

      len = ans.length unless ans.nil?

      return [6, @maxlen+1].min if len < 6
      (len / 3 + 1) * 3
    end
  end
  
  
  # As you can see, this is just a textfield, with an overwritten fromhash method
  # the point is that in the solve hash you can do
  # { "mtfield" => [1,2,3] }
  # and Subtextfield.new("mtfield_0").fromhash(blah.solve) => 1
  # and TODO this logic could probably be moved into MultiTextField itself...
  class SubTextField < TextField
    def partial
      "single/textfield"
    end

    def fromhash(hash)
      return hash[@name] unless hash[@name].nil?

      # This is to allow the convention of defining the solution for a MultiTextField as an array
      # love me my lookaheads
      name_num = @name.split(/_(?=[0-9]+$)/)
      return hash[name_num[0]][name_num[1]]
    end
  end
end
