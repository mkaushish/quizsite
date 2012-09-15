module Units
  TYPES = {
    "length" => [ ["mm", Rational(1,1000)],  
                  ["cm", Rational(1,100)],
                  ["m",  Rational(1,1)],
                  ["km", Rational(1000,1)] ],

    "time"   => [ ["ms", Rational(1,1000)],
                  ["s", Rational(1,1)] ],

    "volume" => [ ["ml", Rational(1,1000)], 
                  ["l", Rational(1,1)] ],

    "mass"   => [ ["mg", Rational(1,1000)],  
                  ["g", Rational(1,1)],
                  ["kg", Rational(1000,1)] ],

    "currency" => [ ["Rs", Rational(1,1)] ]
  }

  def self.generate(n = 1)
    return UNITS.sample if n == 1
    UNITS.sample(n)
  end

  class Unit
    # returns the UnitType that the unit measures: eg. length, volume
    def measures
      @measures
    end

    # returns the number of primary units fit in this one.  For length, the primary unit is
    # a meter, so for cm this would be (1/100). and for km this would be (1000/1) 
    # 
    # returns a Rational
    def modifier
      @modifier
    end

    def convert(n, other)
      unless other.measures == measures
        raise "#{to_s} measures #{measures}, and #{other} measures #{other.measures}, so they can't be converted"
      end

      # n km * 1000 (m / km) / (1 / 100) (m / cm) / = 1000 * 100 * n cm // correct
      modifier / other
    end

    # gives the name of the Unit
    def to_s() @name end

    def initialize(measures, name, modifier)
      @measures = measures
      raise 'first argument should be a UnitType object representing what the unit measures' unless @measures.is_a?(UnitType)

      @name = name
      raise 'second argument should be a String representing the name' unless @name.is_a?(String)

      @modifier = modifier
      raise 'third argument should be a Rational representing the conversion ratio' unless @modifier.is_a?(Rational)
    end
  end

  class UnitType
    attr_accessor :units
    def initialize(name)
      @name = name
    end

    def add_unit(name, modifier)
      @units ||= [] 

      unit = Unit.new(self, name, modifier)
      @units << unit
      unit
    end

    def to_s() @name end

    def self.construct_from_TYPES

      types
    end
  end

  def self.unit_types
    return @unit_types unless @unit_types.nil?

    @unit_types = []
    TYPES.each_key do |measures|
      type = UnitType.new(measures)
      @unit_types << type

      TYPES[measures].each do |unit|
        type.add_unit(*unit)
      end
    end

    @unit_types
  end

  def self.units
    @units ||= @unit_types.map { |t| t.units }.flatten
  end

  def self.generate_units(n = 1)
    return Units.units.sample if n == 1

    Units.units.sample(n)
  end

  def self.generate_types(n = 1)
    return Units.unit_types.sample if n == 1

    Units.unit_types.sample(n)
  end
end
