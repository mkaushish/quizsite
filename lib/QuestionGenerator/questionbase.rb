#!/usr/bin/env ruby
require_relative 'tohtml'

#TODO Ignore commas for all numbers (unless required)

class QuestionBase
  @@type = nil
  ######################################################
  # METHODS YOU MUST OVERRIDE WHEN DEFINING A SUBCLASS #
  ######################################################

  # returns a solution to the problem in the form of a hash: each key should correspond to
  # the name of an InputField object's name
  # EX: if text contains just one input field: TextField("ans"), and the answer to the problem is 30
  # soln should be {"ans" => 30}
  # 
  # note: the answer should be the correct class: eg if the question is 1000 + 2000 then the answer must
  # be 3000 (ie a Fixnum), but if it's "add commas to 3000", the answer should be "3,000" (ie a String)
  # note: don't bother memoizing this function: soln is a memoized version which calls this the first thim it's called
  def solve
    raise "solve must be defined in any class that extends QuestionBase"
  end

  # returns an array of HTMLObj's which will be converted to display the question and
  # answer fields in the rails app
  def text
    raise "text must be defined in any class that extends QuestionBase"
  end

  # Returns the shortest description of the problem type, which will be displayed in areas such as
  # the problem history.  PLEASE override this
  def self.type
    return to_s.split("::")[1] 
  end

  def has_notepad?() true ; end

  #############################################################
  # METHODS YOU MAY WISH TO OVERRIDE WHEN DEFINING A SUBCLASS #
  #############################################################

  # does preprocessing for the variable called "name", with the response "response"
  # should be implemented in subclasses when necessary
  #
  # eg - suppose one of our InputFields (responses) is a TextField named "ans" that is supposed to be a written number.
  # I will accept both "one thousand and five hundred" and "one thousand five hundred".  In fact, I don't think the "ands"
  # really matter, so I don't want to look at them at all.  Therefore I define this preprocess method:
  # def preprocess(name, response)
  #    return super(name, response) unless name == "ans"
  #    super(name, response.gsub(/\s+and\s+/i, " "))
  # end 
  #
  def preprocess(name, response)
    # remove commas (they are annoying in numbers) and spaces
    if response.is_a?(String) && (ToHTML::rm_prefix(name) != "geometry")
      return response.strip.downcase.gsub(/,/, "").gsub(/\s+/, " ").gsub(/^\+/, "")
    end
                             
    return response.to_s
  end

  # tests the answer given by the student against the answer given by solve
  # response will be a hash of the form
  #        "varname" => "response to var"
  # where "varname" is the name you passed the input field, and "response to var" is 
  # whatever the user put into the input field
  # NOTE: correct? MUST be overriden if you have a GeometryField in your question
  def correct?(response)
    postsolution = prefix_solve # memoized version is already preprocessed
    postresponse = preprocess_hash(response)

    text.map { |elt| 
      elt.correct?(postsolution, postresponse) }.inject(:&)
  end

  ##############################################################################################
  # METHODS THAT YOU SHOULD HAVE NO REASON TO OVERRIDE WHEN DEFINING A SUBCLASS, SO JUST DON'T #
  ##############################################################################################
  def type
    return self.class.type # all instances of a class have the same type
  end

  # used to call preprocess on all the keys of the response hash, and avoid name issues
  def preprocess_hash(response)
    ret = {}
    response.each do |key, value|
      name = ToHTML::prefix_for_questionbase key

      # this is just for convenience in writing solve methods:
      # instead of num_1 => blah, num_2 => blah, num_3 => blah
      # just write num => [blah, blah, blah]
      if value.is_a? Array
        value.length.times do |i|
          ret["#{key}_#{i}"] = preprocess("#{name}_#{i}", value[i])
        end
      else
        ret[key] = preprocess(name, value)
      end
    end
    ret
  end

  # stores the response from solve, in case solve didn't already do this, so the hash is only created once
  def soln
    @soln ||= preprocess_hash(solve)
  end

  # makes a new hash from the solve hash, which has the same prefixes the rails response hash will pass
  def prefix_solve
    return @prefix_soln unless @prefix_soln.nil?

    @prefix_soln = {}
    soln.each_key { |key| @prefix_soln[ToHTML::add_prefix(key)] = soln[key] }
    @prefix_soln
  end

  # returns an array of the named variables
  def vars
    @vars ||= soln.keys
    @vars
  end

  def get_useful_response(params)
    response = {}
    prefix_solve.each_key { |key| response[key] = params[key] }
    response
  end

  # Usage
  #   QuestionBase.vars_from_response(vname1, vname2, ..., params)
  #     => [ value1, value2, ... ]
  # unless there's only one vname, then it will just return
  #     => value
  # For an example, see chapter4 / NameTriangles
  def self.vars_from_response(*args)
    return nil unless args.length >= 2
    params = args.slice!(-1)

    return params[ToHTML::add_prefix args[0]] if args.length == 1
    args.map { |name| params[ToHTML::add_prefix name] }
  end
end

class QuestionWithExplanation < QuestionBase
  # explain:
  # returns an array QuestionBases - it might be easiest to define these on the fly as Subproblems.
  # in the view, we will require each subproblem to be completed correctly before moving on to the next problem
  def explain  
    raise "classes which extend QuestionWithExplanation must define an explain method"
  end

  def explanation
    @explanation ||= explain
  end
end

# This is here to definite a problem on the fly - just pass in the hash for solve and the array for text
# The difference between a subproblem and defining your own class to extend Qbase, is just that all subproblems
# will have the class "Subproblem", and can't by default override methods like "correct?"
class Subproblem < QuestionBase
  def initialize(text, soln={})
    # can't name this soln, because some preprocessing goes on there
    @mysoln = soln
    @text = text
  end

  def text
    @text
  end

  def solve
    @mysoln
  end

  def id
    ""
  end
end

class SubLabel < Subproblem
  def initialize(labeltext)
    super( [ ToHTML::TextLabel.new(labeltext) ], {} )
  end

  def self.type
    "Explanation"
  end

  def solve ; {} ; end
end

class CustomProblem < Subproblem
  def initialize(name, text, soln)
    @name = name
    super(text, soln)
  end

  def self.type ; "Custom Problem" ; end
  def type ; @name ; end
end

class CustomProblemText < CustomProblem
  def initialize(name, text, soln)
    mytext = [ ToHTML::TextLabel.new(text),
              ToHTML::TextField.new('ans') ]
    mysoln = {'ans' => soln}
    super(name, mytext, mysoln)
  end
end

class CustomProblemMCQ < CustomProblem
  # resps should be an array of the choices in the answer
  # the 0th element of resps should be the correct answer!
  def initialize(name, text, resps)
    mysoln = {'ans' => resps[0]}
    mytext = [ ToHTML::TextLabel.new(text),
               ToHTML::RadioButton.new('ans', resps.shuffle.shuffle) ]
    super(name, mytext, mysoln)
  end
end