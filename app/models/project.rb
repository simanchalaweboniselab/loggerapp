class Project < ActiveRecord::Base
  attr_accessible :name

  validates :name, :presence => true, :uniqueness => true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  def create_file(host,username, password,log_path, key, pwd)
    File.open("#{Rails.root}/public/encrypt/#{self.name}/rubynetco", "w+") do |f|
      f.write("require 'rubygems' \nrequire 'net/ssh' \nNet::SSH.start('#{host}', '#{username}', :password => '#{password}') do |ssh|\n   result = ssh.exec('#{log_path}')\n   puts result\nend\n\n\n\n");
    end
    File.open("#{Rails.root}/public/encrypt/#{self.name}/decrunlog.rb", "w+") do |f|
      f.write("\nbegin\n  gem 'crypt19'\nrescue LoadError\n  system('sudo gem install crypt19')\n  Gem.clear_paths\nend\nrequire 'rubygems'\nrequire 'crypt/blowfish'\n key = "+'"'+"#{key}" +'"'+"\nbegin\n"+'file = File.open("rubynetco.enc", "r")'+"\n  contents = file.read\n  blowfish = Crypt::Blowfish.new(key)\n  eval blowfish.decrypt_string(contents)\nrescue Exception => e\n  "+'puts "Something Went Wrong!!!"'+"\n  puts e\nend")
    end
    File.open("#{Rails.root}/public/encrypt/#{self.name}/log.rb", "w+") do |f|
      f.write("\nbegin\n  gem 'crypt19'\nrescue LoadError\n  system('sudo gem install crypt19')\n  Gem.clear_paths\nend\nrequire 'rubygems'\nrequire 'crypt/blowfish'\n key = "+'"'+"#{pwd}" +'"'+"\nbegin\n"+'file = File.open("decrunlog.rb.enc", "r")'+"\n  contents = file.read\n  blowfish = Crypt::Blowfish.new(key)\n  eval blowfish.decrypt_string(contents)\nrescue Exception => e\n  "+'puts "Something Went Wrong!!!"'+"\n  puts e\nend")
    end
  end

end
