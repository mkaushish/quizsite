module Items
  class Item
    def self.price(n = 1, m = 0)
      return n * (self.unit_price + m)
    end

    def self.write(n)
      if(n == 1)
        return "1 #{self.singular}"
      else
        return "#{n} #{self.pluralize}"
      end
    end

    private

    def self.unit_price
      return 0
    end

    def self.s
      return self.pluralize
    end
  end

  class Tomato < Item
    def self.unit_price() 8 end
    def self.pluralize() "kg of tomatoes" end
    def self.singular() "kg of tomatoes" end
    def self.s() "tomatoes" end
  end

  class Pencil < Item
    def self.unit_price() 2 end
    def self.singular() "pencil" end
    def self.pluralize() "pencils" end
  end

  class Pen < Item
    def self.unit_price() 8 end
    def self.singular() "pen" end
    def self.pluralize() "pens" end
  end

  ITEMS = [
    Tomato,
    Pen, Pencil
  ]

  def self.generate(n = 1)
    return ITEMS.sample if n == 1
    ITEMS.sample(n)
  end
end
