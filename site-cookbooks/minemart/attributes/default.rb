default[:user][:name] = "minemart"

default[:app][:name] = "minemart"
default[:app][:domain] = "cbrwizard.com"
default[:app][:web_dir] = "/home/#{user[:name]}/apps/#{app[:name]}"

default[:rvm][:user_installs] = [{
  :user => "#{user[:name]}",
  :default_ruby => "ruby-2.1.1"
}]

default[:nginx][:version] = "1.4.4"
default[:nginx][:default_site_enabled] = true
default[:nginx][:source][:modules] = [
  "nginx::http_gzip_static_module",
  "nginx::http_ssl_module",
  "nginx::http_gzip_static_module",
  "nginx::passenger"]

default[:nginx][:passenger][:version] = "4.0.37"
default[:nginx][:passenger][:ruby] = "/home/#{user[:name]}/.rvm/wrappers/#{rvm[:default_ruby]}/wrappers/ruby"
default[:nginx][:passenger][:root] = "/home/#{user[:name]}/.rvm/gems/#{rvm[:default_ruby]}/gems/passenger-#{nginx[:passenger][:version]}"

default[:opencv][:version] = "2.4.6.1"
default[:opencv][:url] = "https://github.com/Itseez/opencv/archive/#{opencv[:version]}.tar.gz"