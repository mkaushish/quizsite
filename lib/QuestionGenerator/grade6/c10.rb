require_relative '../questionbase'

require_relative '../tohtml.rb'
include ToHTML

module Chapter10
	REGULARSHAPES= ["point", "line", "equilateral triangle", "square", "regular pentagon", "regular hexagon"]
	MAXSIDE=40
	class FindPerimeterRegular < QuestionWithExplanation
		def initialize(nsides=rand(REGULARSHAPES.length-2)+3, side=rand(MAXSIDE)+5)
			@shape=Grade6ops::RegShapes.new(nsides, side)
		end

		def solve
			{"ans" => @shape.perimeter.to_s}
		end

		def explain
			[Subproblem.new([TextLabel.new("How many sides does a " + REGULARSHAPES[@shape.numsides-1] + " have?"), TextField.new("numsides")], {"numsides" => @shape.numsides.to_s}),
				Subproblem.new([TextLabel.new("Since all "+@shape.numsides.to_s+" sides of a " + REGULARSHAPES[@shape.numsides-1]+ " are equal, the perimeter is " + @shape.numsides.to_s + " multiplied by the length of the side, "+@shape.side.to_s), TextField.new("perimeter", "Perimeter")], {"perimeter" => @shape.perimeter.to_s})]
		end
		def text
			[TextLabel.new("Find the perimeter of a "+REGULARSHAPES[@shape.numsides-1] + " of side " + @shape.side.to_s), TextField.new("ans")]
		end
	end

	class FindSideRegular < QuestionWithExplanation
		def initialize(nsides=rand(REGULARSHAPES.length-2)+3, side=rand(MAXSIDE)+5)
			@shape=Grade6ops::RegShapes.new(nsides, side)
		end

		def solve
			{"ans" => @shape.side.to_s}
		end

		def explain
			[Subproblem.new([TextLabel.new("How many sides does a " + REGULARSHAPES[@shape.numsides-1] + " have?"), TextField.new("numsides")], {"numsides" => @shape.numsides.to_s}),
				Subproblem.new([TextLabel.new("Since all "+@shape.numsides.to_s+" sides of a " + REGULARSHAPES[@shape.numsides-1]+ " are equal, the length of each side is the perimeter, "+@shape.perimeter.to_s + " divided by the number of sides"), TextField.new("side", "Side")], {"side" => @shape.perimeter.to_s})]
		end
		def text
			[TextLabel.new("Find the length of the side of a "+REGULARSHAPES[@shape.numsides-1] + " of perimeter " + @shape.perimeter.to_s), TextField.new("ans")]
		end
	end


	class FindPerimeterRectangle < QuestionWithExplanation  
		def initialize(length=nil, width=nil)
      if(length!=nil)
        @width=width
        @length=length
      else
			@width=rand(MAXSIDE)+5
			@length=rand(MAXSIDE)+@width
      end
    end
    def solve
      {"ans" => ((@width+@length)*2).to_s}
    end
    def explain
      [SubLabel.new("The perimeter of a rectangle is double the width plus double the length"), PreG6::Multiplication.new(2, @width), PreG6::Multiplication.new(2, @length), PreG6::Addition.new([2*@width, 2*@length])]
    end
    def text
      [TextLabel.new("Find the perimeter of a rectangle of width #{@width} and length #{@length}"), TextField.new("ans")]
    end
  end
	class FindAreaRectangle < QuestionWithExplanation
		def initialize(length=nil, width=nil)
      if(length!=nil)
        @width=width
        @length=length
      else
			@width=rand(MAXSIDE)+5
			@length=rand(MAXSIDE)+@width
      end
    end
    def solve
      {"ans" => @width*@length}
    end
    def explain
      [SubLabel.new("The area of a rectangle is the width multiplied by the length"), PreG6::Multiplication.new(@width, @length)]
    end
    def text
      [TextLabel.new("Find the area of a rectangle of width #{@width} and length #{@length}"), TextField.new("ans")]
    end
  end
  NOUN=["table-top", "garden", "field", "football field", "farm", "room"]
  class AreaRectWord < FindAreaRectangle
    def initialize
      super()
      @wh=NOUN.sample
    end
    def text
      [TextLabel.new("Find the area of a rectangular #{@wh} of width #{@width} and length #{@length}"), TextField.new("ans")]
    end
  end
  class PeriRectWord < FindPerimeterRectangle
    def initialize
      super()
      @wh=NOUN.sample
    end
    def text
      [TextLabel.new("Find the perimeter of a rectangular #{@wh} of width #{@width} and length #{@length}"), TextField.new("ans")]
    end
  end
  PROBLEMS=[Chapter10::FindPerimeterRegular, Chapter10::FindSideRegular, Chapter10::FindPerimeterRectangle, Chapter10::PeriRectWord, Chapter10::FindAreaRectangle, Chapter10::AreaRectWord]
end




