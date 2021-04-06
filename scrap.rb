require "nokogiri"
require "open-uri"

url = "https://greta-code-pizza.github.io/topsails/"
html = URI.open(url)
app = Nokogiri::HTML(html)
