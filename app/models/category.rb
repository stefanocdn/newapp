class Category < ActiveRecord::Base
  attr_accessible :name

  has_many :categorizations
  has_many :lessons, through: :categorizations


  def self.tokens(query)
  categories = where("name ilike ?", "%#{query}%")
    if categories.empty?
      [{id: "<<<#{query}>>>", name: "New: \"#{query}\""}]
    else
      categories
    end
  end

  def self.ids_from_tokens(tokens)
    tokens.gsub!(/<<<(.+?)>>>/) { create!(name: $1).id }
    tokens.split(',')
  end
end
