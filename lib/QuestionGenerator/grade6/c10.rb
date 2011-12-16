require_relative '../questionbase'

require_relative '../tohtml.rb'
include ToHTML

module Chapter10
	REGULARSHAPES= ["point", "line", "equilateral triangle", "square", "regular pentagon", "regular hexagon"]
	MAXSIDE=40
	class FindPerimeterRegular
		def initialize
			@shape=Grade6ops::RegShapes.new(rand(REGULARSHAPES.length-2)+3, rand(MAXSIDE)+5)
		end

		def solve
			{"ans" => @shape.perimeter.to_s}
		end

		def explain
			[Subproblem.new([TextLabel.new("How many sides does a " + REGULARSHAPES[@shape.numsides-1] + " have?"), TextField.new("numsides")], {"numsides" => @shape.numsides.to_s}),
				Subproblem.new([TextLabel.new("Since all "+@shape.numsides.to_s+" sides of a " + REGULARSHAPES[@shape.numsides-1]+ " are equal, the perimeter is " + @shape.numsides.to_s + " multiplied by the length of the side, "+@shape.side.to_s), TextField.new("perimeter", "Perimeter")], {"perimeter" => @shape.perimeter.to_s})]
		end
		def text
			[TextLabel.new("Find the perimeter of a "+REGULARSHAPES[@shape.numsides-1] " of side " + @shape.side.to_s), TextField.new("ans")]
		end
	end

	class FindSideRegular
		def initialize
			@shape=Grade6ops::RegShapes.new(rand(REGULARSHAPES.length-2)+3, rand(MAXSIDE)+5)
		end

		def solve
			{"ans" => @shape.side.to_s}
		end

		def explain
			[Subproblem.new([TextLabel.new("How many sides does a " + REGULARSHAPES[@shape.numsides-1] + " have?"), TextField.new("numsides")], {"numsides" => @shape.numsides.to_s}),
				Subproblem.new([TextLabel.new("Since all "+@shape.numsides.to_s+" sides of a " + REGULARSHAPES[@shape.numsides-1]+ " are equal, the length of each side is the perimeter, "+@shape.perimeter.to_s + " divided by the number of sides"), TextField.new("side", "Side")], {"side" => @shape.perimeter.to_s})]
		end
		def text
			[TextLabel.new("Find the length of the side of a "+REGULARSHAPES[@shape.numsides-1] " of perimeter " + @shape.perimeter.to_s), TextField.new("ans")]
		end
	end


	class FindPerimeterRectangle
		def initialize
			@width=rand(MAXSIDE)+5
			@length=rand(MAXSIDE)+width

end




