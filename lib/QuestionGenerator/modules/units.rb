module Units
  TYPES = {
    "length" => ["mm", "cm", "m", "km"],
    "time"   => ["ms", "s"],
    "volume" => ["ml", "l"],
    "mass"   => ["mg", "g", "kg"]
  }

  class Unit
    def measurement
      raise "method not implemented"
    end

    def convert(other)
      raise "method not implemented"
    end

    def to_s
      raise "method not implemented"
    end
  end
end
