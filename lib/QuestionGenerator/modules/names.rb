module Names
  NAMES = [
    "Avnee",
    "Rahim",
    "Shari",
    "Isha",
    "Ravi",
    "Rani",
    "Kriti",
    "Kiran",
    "John",
    "Mary",
    "Raju",
    "Bhavika",
    "Vini",
    "Pooja",
    "Ashma",
    "Pankhuri",
    "Thomas",
    "Madhav",
    "Rahim",
    "Roshan",
    "Reshma",
    "Seema",
    "Anurag",
    "Manav",
    "Tushar"
  ]

  def Names.generate(n = 1)
    return NAMES.sample(n)
  end
end
