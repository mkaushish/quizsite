#!/usr/bin/env ruby
require_relative '../grade6'

include ToHTML
include Geometry

module Chapter4
  def Chapter4.pointsOnLine(m, b, startx, endx, num_points, start_name = "A")
    name = start_name.dup
    x_inc = (endx - startx) / (num_points + 1) # + endpoints

    Array.new(num_points) do |i|
      x = startx + x_inc * (i + 1) # i_0 = first end point
      y = m*x + b
      name.next! unless i == 0
      NPoint.new(x, y, name.dup, (1.0/m))
    end
  end

  #
  # Chapter 4.1 exercises
  # 
  class NameLine < QuestionWithExplanation
    def self.type
      "Indentify Lines"
    end
    attr_accessor :l, :points
    def initialize
      length = rand(50) + 100
      endpoints = SmallGeoDisplay.randCenterLine(length)
      @l = InfLine.new(*endpoints)
      m, b = *(@l.toSlopeInt)

      num_points = 3 + (length / 125) # 125 = avg length
      start_letter = ["A", "E", "U", "W"].sample
      @points = Chapter4::pointsOnLine(m, b, @l.x1, @l.x2, num_points)
    end

    def text
      num_lines = @points.length * (@points.length - 1)
      [
        TextLabel.new("Name the line in all possible (#{num_lines}) ways"),
        SmallGeoDisplay.new(@l, *@points),
        MultiTextField.new("ans")
      ]
    end

    def solve
      {
        "ans" => @points.map { |p| p.name }.permutation(2).to_a.map { |a| a.join("") }
      }
    end

    def explain
      [
        Subproblem.new([
          TextLabel.new("A line is named after 2 points on it, and the order doesn't matter.  Therefore you can call the following line any of these names: { #{solve["ans"].join(", ")} }"),
          SmallGeoDisplay.new(@l1, *@points)
          ], {} )
      ]
    end
  end

  class NameRay
    def initialize
      length = rand(50) + 100
      endpoints = SmallGeoDisplay.randCenterLine(length)
      @l = Ray.new(*endpoints)
      m, b = *(@l.toSlopeInt)
      
      num_points = 3 + (length / 125) # 125 = avg length
      start_letter = ["A", "E", "U", "W"].sample
      @points = Chapter4::pointsOnLine(m, b, @l.x1, @l.x2, num_points)
    end
  end

  # which point is an intersection of a line
  class NameIntPoints
      length = rand(50) + 50
      endpoints = SmallGeoDisplay.randCenterLine(length)
  end

  # is a point on a given line/ray?
  class PointOnLine
  end

  #
  # Chapter 4.2 exercises
  #

  # is a curve open or closed?
  class OpenClosedCurves
  end

  #
  # Chapter 4.3 exercises
  #
  class NameAngles < QuestionWithExplanation
    attr_accessor :points, :lines
    def self.type
      "Identify Angles"
    end

    def initialize
      cx, cy = *(SmallGeoDisplay.center)
      numpoints = rand(2) + 4
      dists = Array.new(numpoints) { (SmallGeoDisplay.width/6) + rand(SmallGeoDisplay.width / 6) }
      @lines, @points = *(SmallGeoDisplay::polygonAtCenterWithPoints("A", dists))
    end

    def solve
      angle_names = Array.new(@points.length) do |i|
        j = (i + 1) % @points.length
        k = (j + 1) % @points.length
        "#{@points[i].name}#{@points[j].name}#{@points[k].name}"
      end

      { "ans" => angle_names }
    end

    def preprocess(name, response)
      ret = response.upcase
      # Angles can be written in either order, so we'll standardize it
      ret.reverse! if ret.reverse < ret
      ret
    end

    def text
      [ 
        TextLabel.new("Give a name for each of the angles in the following drawing"),
        SmallGeoDisplay.new(*@lines, *@points),
        MultiTextField.new("ans")
      ]
    end

    def explain
      angle_names = solve["ans"]
      i = rand(@points.length)
      pname = @points[(i+1) % @points.length].name
      angle = angle_names[i]
      [ 
        Subproblem.new( [
          TextLabel.new("Angles are named after the three points that define them.  The point at the center of the angle (the vertex) is always in the middle of the angle name, but the other ones don't matter.  That means that the angle centered on point #{pname} could be called either #{angle} or #{angle.reverse}.  When going through and naming all the angles, make sure each point is in the middle in exactly one of the names.  One way of writing all the names is { #{angle_names.join(", ")} }"),
          SmallGeoDisplay.new(*@lines, *@points)
        ], {} )
      ]
    end
  end

  #
  # Chapter 4.4 exercises
  #
  class NameTriangles < QuestionWithExplanation
    def self.type
      "Identify Triangles"
    end
    attr_accessor :lines
    def initialize
      start_letter = ["A", "C", "U", "X"].sample
      dists = Array.new(3) { (SmallGeoDisplay.width/6) + rand(SmallGeoDisplay.width / 6) }
      @lines, @points = *(SmallGeoDisplay::polygonAtCenterWithPoints(start_letter, dists))
    end

    def solve
      ans = @points.map { |p| p.name }.sort.join("")
      { "ans1" => ans, "ans2" => ans.reverse }
    end

    def correct?(params)
      a1, a2 = *(QuestionBase.vars_from_response("ans1", "ans2", params))
      a1.upcase!
      a2.upcase!
      return false if a1 == a2
      return false unless a1.split("").sort == soln["ans1"].upcase.split("")
      return false unless a2.split("").sort == soln["ans1"].upcase.split("")
      return true
    end

    def text
      [
        TextLabel.new("Give 2 different names for this triangle"),
        SmallGeoDisplay.new(*@lines, *@points),
        TextField.new("ans1"),
        TextField.new("ans2")
      ]
    end

    def explain
      tnames = @points.map { |p| p.name }.permutation.to_a.map { |a| a.join("") }
      [ 
        Subproblem.new( [
          TextLabel.new("Triangles are named after the three points that define them, and the order doesn't matter.  This is because no matter what order you name the points in, you can count them off going in a cycle around the triangle! The full list of ways to write the name of this triangle is { #{tnames.join(", ")} }"  ),
          SmallGeoDisplay.new(*@lines, *@points)
        ], {} )
      ]
    end
  end

  #
  # Just taken from the end
  #
  class DefVertices < QuestionWithExplanation
    def self.type
      "Identify Vertices"
    end
    attr_accessor :points, :lines, :num_verts
    def initialize
      num_sides = 3 + rand(4);
      dists = Array.new(num_sides) { (SmallGeoDisplay.width/6) + rand(SmallGeoDisplay.width / 6) }
      @lines, @points = *(SmallGeoDisplay::polygonAtCenterWithPoints("A", dists))
      @num_verts = 1 + rand(num_sides - 2)
    end

    def text
      verts = @num_verts > 1 ? "vertices" : "vertex"
      geodisp = SmallGeoDisplay.new(@lines)
      geodisp.startTool("select")
      [
        TextLabel.new("Click on #{@num_verts} #{verts} on the following diagram"),
        geodisp
      ]
    end

    def solve
      {
        "selectedshapes" => Shape.encode_a(@points.sample(@num_verts))
      }
    end

    def correct?(params)
      selected = SmallGeoDisplay::selectedShapes(params)
      return false if selected.length != @num_verts

      points = @points.clone
      selected.each do |point|
        i = points.index point
        return false if i.nil?
        points[i] = nil # make sure they don't click the same one twice, though
                        # technically they shouldn't be able to
      end
      true
    end

    def explain
      [
        SubLabel.new("A vertex is defined as the meeting point of a pair of sides.  On a polygon like you see below, it's basically a corner.  Try the problem again with this definition in mind!"),
        self
      ]
    end
  end

  class DefAdjacentSides < QuestionWithExplanation
    def self.type
      "Identify Adjacent Sides"
    end
    def initialize
      num_sides = 5 + rand(3);
      dists = Array.new(num_sides) { (SmallGeoDisplay.width/6) + rand(SmallGeoDisplay.width / 6) }
      @lines, @points = *(SmallGeoDisplay::polygonAtCenterWithPoints("A", dists))
    end

    def text
      geodisp = SmallGeoDisplay.new(@lines)
      geodisp.startTool("select")
      [
        TextLabel.new("Click on two adjacent sides on the following polygon"),
        geodisp
      ]
    end

    def solve
      i = rand(@lines.length)
      j = (i + 1) % @lines.length
      {
        "selectedshapes" => Shape.encode_a([@lines[i], @lines[j]])
      }
    end

    def correct?(params)
      selected = SmallGeoDisplay::selectedShapes(params)
      return false if selected.length != 2
      i = @lines.index(selected[0])
      j = @lines.index(selected[1])
      return false if i.nil? || j.nil?
      return ((i - j) % @lines.length == 1) || ((j - i) % @lines.length == 1)
    end

    def explain
      [
        SubLabel.new("Remember that adjacent edges are ones that are next to each other.  The real definition is that they \"share a common end point.\"  With this in mind, try the problem again:"),
        self
      ]
    end
  end

  class DefAdjacentVertices < QuestionWithExplanation
    def self.type
      "Identify Adjacent Vertices"
    end
    def initialize
      num_sides = 5 + rand(3);
      dists = Array.new(num_sides) { (SmallGeoDisplay.width/6) + rand(SmallGeoDisplay.width / 6) }
      @lines, @points = *(SmallGeoDisplay::polygonAtCenterWithPoints("A", dists))
    end

    def text
      geodisp = SmallGeoDisplay.new(@lines)
      geodisp.startTool("select")
      [
        TextLabel.new("Click on two adjacent vertices on the following polygon"),
        geodisp
      ]
    end

    def solve
      i = rand(@lines.length)
      j = (i + 1) % @lines.length
      # TODO figure out what this does, take labels off points
      {
        "selectedshapes" => Shape.encode_a([@points[i], @points[j]])
      }
    end

    def correct?(params)
      selected = SmallGeoDisplay::selectedShapes(params)
#      puts selected.inspect
      return false if selected.length != 2
      i = @points.index(selected[0])
      j = @points.index(selected[1])
      return false if i.nil? || j.nil?
      return ((i - j) % @lines.length == 1) || ((j - i) % @lines.length == 1)
    end

    def explain
      [
        SubLabel.new("Remember that adjacent vertices are end points to the same line segment.  With this in mind, try the problem again:"),
        self
      ]
    end
  end

  class DefDiagonal < QuestionWithExplanation
    def self.type
      "Identify Diagonals"
    end
    def initialize
      num_sides = 5 + rand(3)
      dists = Array.new(num_sides) { (GeometryField.width/6) + rand(GeometryField.width / 6) }
      @lines, @points = *(GeometryField::polygonAtCenterWithPoints("A", dists))
    end

    def solve 
      point_i = rand(@points.length)
      { "geometry" => Line.new(@points[point_i], @points[ (point_i + 2) % @points.length ] ).encode }
    end

    def text
      [
        TextLabel.new("Draw a diagonal on the following polygon"),
        GeometryField.new(@lines)
      ]
    end

    def correct?(response)
      shapes = GeometryField.shapesFromResponse(response)
      lines = shapes.select { |s| s.is_a?(Line) }
      lines.each do |line|
        p1i = @points.index(line.p1)
        next if p1i.nil?

        p2i = @points.index(line.p2)
        next if p2i.nil?

        return true if (p2i - p1i) % @points.length > 1 && (p1i - p2i) % @points.length > 1
      end
      false
    end

    def explain
      [
        Subproblem.new([
          TextLabel.new("A diagonal is a line between 2 non-adjacent vertices on a polygon.  Remember that a vertex (plural vertices) is just a corner, and non-adjacent just means they're not next to each other. See an example below"),
          GeometryDisplay.new(*@lines, Shape.decode(solve["geometry"]))
        ], {} )
      ]
    end
  end

  class DefPolygon < QuestionWithExplanation
    def self.type
      "Draw Polygon"
    end
    def initialize(numpoints, name)
      @numpoints = numpoints
      @name = name
    end

    def text
      [
        TextLabel.new("Draw a #{@name} on the canvas below"),
        GeometryField.new()
      ]
    end

    def solve
      lines = GeometryField::polygonAtCenter(@numpoints)
      { "geometry" => Shape.encode_a(lines) }
    end

    def correct?(response)
      lines = GeometryField::shapesFromResponse(response).uniq
      lines.each { |l| return false unless l.is_a?(Line) }
      return false if lines.length != @numpoints
      return Geometry::formPolygon?(lines)
    end

    def explain
      [
        Subproblem.new([
          TextLabel.new("A #{@name} is a polygon with #{@numpoints} sides.  Here's an example below!"),
          SmallGeoDisplay.new(SmallGeoDisplay::polygonAtCenter(@numpoints))
        ], {} )
        # TODO add in example problem - this will require modifying next_subproblem.js.erb
      ]
    end
  end

  class DefQuadrilateral < DefPolygon
    def self.type
      "Draw Quadrilateral"
    end
    def initialize
      super(4, "quadrilateral")
    end
  end

  class DefTriangle < DefPolygon
    def self.type
      "Draw Triangle"
    end
    def initialize
      super(3, "triangle")
    end
  end

  PROBLEMS = [
    Chapter4::NameLine,
    Chapter4::NameAngles,
    Chapter4::NameTriangles,
    Chapter4::DefVertices,
    Chapter4::DefAdjacentSides,
    Chapter4::DefAdjacentVertices,
    Chapter4::DefDiagonal,
    Chapter4::DefTriangle,
    Chapter4::DefQuadrilateral
  ]
end
