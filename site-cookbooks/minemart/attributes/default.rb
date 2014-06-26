default[:user][:name] = "minemart"

default[:app][:name] = "minemart"
default[:app][:domain] = "cbrwizard.com"
default[:app][:ruby] = "ruby-2.1.1"

default[:rvm][:user_installs] = [{
  :user => user[:name],
  :default_ruby => app[:ruby]
}]

default[:pg][:user_name] = "minemart_admin"
default[:pg][:user_password] = "qwerty"

default[:opencv][:version] = "2.4.6.1"
default[:opencv][:url] = "https://github.com/Itseez/opencv/archive/#{opencv[:version]}.tar.gz"

default[:chromedriver][:version] = '2.10'
