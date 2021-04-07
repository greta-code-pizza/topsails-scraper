require "nokogiri"
require "open-uri"
require "pry"
require "sqlite3"

url = "https://greta-code-pizza.github.io/topsails/"
html = URI.open(url)
app = Nokogiri::HTML(html)
db = SQLite3::Database.new("yachtDB.db")


# class YachtSanitizer
#   def initialize(:label, :price)
#     return unless valid?(label, price)

#     @label = label
#     @price = price
#   end

#   def call
#     {

#     }
#   end

#   def valid?(label, price)
#     # ...
#   end
# end

class YachtSanitizer
end

class Yacht
  CONDITIONS = {
    "bon" => 0,
    "très bon" => 1,
    "excellent" => 2 
  }
end

yachts = app.css('.card-boat')

yachts.each do |yacht|
  label = yacht.css("h4").children.text

  price = yacht.css(".price").children.text
  price = price.split("€").first.tr(' ', '').to_i

  properties = yacht.css(".property")

  # year = yacht.css(".property:nth-child(3) .badge").text
  # year = properties.first.text.strip[-4..-1]
  year = properties.first.css('.badge').text

  # delete_suffix("m") meilleur que .text[0..-2]
  loa = properties[1].css('.badge').text[0..-2].to_f
  boa = properties.last.css('.badge').text.delete_suffix("m").to_f

  condition = yacht.css(".card-text")

  # condition_key = condition.children.text.split("en").last.split("état").first.strip
  condition_key = 
    ["très bon", "bon", "excellent"].find do |k| 
      condition.children.text.include?(k) 
    end

  # condition.children.text.include?("très bon")
  condition_val = Yacht::CONDITIONS[condition_key]

  data = {
    "label" => label,
    "price" => price,
    "year" => year,
    "loa" => loa,
    "boa" => boa,
    "condition" => condition_val
  }

  db.execute("INSERT OR IGNORE INTO yacht VALUES (:label, :price, :year, :loa, :boa, :condition)", data)
end 


# binding.pry