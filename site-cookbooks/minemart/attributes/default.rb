default[:user][:name] = "minemart"

default[:app][:name] = "minemart"
default[:app][:domain] = "cbrwizard.com"
default[:app][:web_dir] = "/home/#{user[:name]}/apps/#{app[:name]}"

default[:rvm][:user_installs] = [{
  :user => "#{user[:name]}",
  :default_ruby => "ruby-2.1.1"
}]

default[:passenger][:version] = "4.0.37"
default[:passenger][:ruby] = "/home/#{user[:name]}/.rvm/wrappers/#{rvm[:default_ruby]}/wrappers/ruby"
default[:passenger][:root] = "/home/#{user[:name]}/.rvm/gems/#{rvm[:default_ruby]}/gems/passenger-#{passenger[:version]}"

default[:opencv][:version] = "2.4.6.1"
default[:opencv][:url] = "https://github.com/Itseez/opencv/archive/#{opencv[:version]}.tar.gz"