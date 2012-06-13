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
  end

  class MultiHTMLObj
    # This method is passed a solution hash and a response hash, and must test whether
    # the part the solution and response hashes which represent this problem are correct
    def correct?(solution, response)
      raise "subclasses of MultiHTMLObj must implement correct?!"
    end
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
      [ @intpart, @num, @den ].each do |elt|
        return false unless elt.nil? || elt.correct?(solution, response)
      end
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
    def initialize(name, obs, init, varhsh)
      super(name, obs, init, varhsh)
      @edit="noedit"
    end
    def correct?(solution, response)
      return true
    end
  end

  class NumberLine < HTMLObj
    attr_reader :name, :lines, :points, :azoom, :zoom, :mid
    def initialize(name, lines=[], points=[], zoom=1, mid=0)
      @name=ToHTML::add_prefix name
      @lines=lines
      @points=points
      @zoom=zoom
      @mid=mid
      @azoom="edit"
    end
  end

  class TextTable < TableField
    def initialize(table)
      @table = table.map { |row| row.map { |elt| TextLabel.new(elt) } }
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
  end

  class Checkbox < InputField
    attr_reader :label

    def initialize(name, label)
      super(name)
      @label = label.to_s
    end

    def correct?(solution, response)
      return true unless solution[@name].nil? || response[@name].nil?
      solution[@name].nil? && response[@name].nil?
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
  end

  class TextField < InputField
    attr_reader :label
    def initialize(name, text = "")
      super(name)
      @label = text.to_s
    end
  end
  
  # As you can see, this is just a textfield, with an overwritten fromhash method
  # the point is that in the solve hash you can do
  # { "mtfield" => [1,2,3] }
  # and Subtextfield.new("mtfield_0").fromhash(blah.solve) => 1
  # and TODO this logic could probably be moved into MultiTextField itself...
  class SubTextField < TextField
    def fromhash(hash)
      return hash[@name] unless hash[@name].nil?

      # This is to allow the convention of defining the solution for a MultiTextField as an array
      # love me my lookaheads
      name_num = @name.split(/_(?=[0-9]+$)/)
      return hash[name_num[0]][name_num[1]]
    end
  end
end
