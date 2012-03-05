#!/usr/bin/env ruby
require_relative 'tohtml'

#TODO Ignore commas for all numbers (unless required)

class QuestionBase
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

  # Returns a string which will be displayed as the problem type.
  # You don't actually need to override this method: you can also just set the @type variable
  # removed, so you MUST override this method
  def self.type
    if @type.nil? 
      return to_s.split("::")[1] 
    else
      return @type
    end
  end

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
    return response.strip.downcase.gsub(/,/, "").gsub(/\s+/, " ") if response.is_a? String
    return response.to_s
  end

  # tests the answer given by the student against the answer given by solve
  # response will be a hash of the form
  #        "varname" => "response to var"
  # where "varname" is the name you passed the input field, and "response to var" is 
  # whatever the user put into the input field
  def correct?(response)
    postsolution = prefix_solve # memoized version is already preprocessed
    postresponse = preprocess_hash(response)

    text.map { |elt| elt.correct?(postsolution, postresponse) }.inject(:&)
  end

  #######################################################################################################
  # METHODS THAT YOU SHOULD HAVE NO REASON TO OVERRIDE WHEN DEFINING A SUBCLASS, SO DON'T OVERRIDE THEM #
  #######################################################################################################
  def type
    return self.class.type
  end

  def preprocess_hash(response)
    ret = {}
    response.each do |key, value|
      name = ToHTML::prefix_for_questionbase key
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

  # stores the response from solve, in case solve didn't already do this
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
end