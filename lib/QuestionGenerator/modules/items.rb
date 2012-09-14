module Items
  class Item
    def self.price(n = 1, m = 0)
      return "Rs #{n * (self.unit_price + m)}"
    end

    private

    def self.unit_price
      return 0
    end
  end

  class Tomato < Item
    def self.unit_price() 8 end
    def self.write(n) "#{n} kg of tomatoes" end
    def self.pluralize() "tomatoes" end
  end

  class Pencil < Item
    def self.unit_price() 2 end

    def self.write(n) 
      if n == 1
        return "1 pencil"
      else
        return "#{n} pencils"
      end
    end

    def self.pluralize() "pencils" end
  end

  class Pen < Item
    def self.unit_price() 8 end

    def self.write(n) 
      if n == 1
        return "1 pen"
      else
        return "#{n} pens"
      end
    end

    def self.pluralize() "pens" end
  end

  ITEMS = [
    Tomato,
    Pen, Pencil
  ]

  def self.generate(n = 1)
    return ITEMS.sample(n)
  end
end
