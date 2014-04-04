default[:app][:name] = "minemart"
default[:app][:domain] = "cbrwizard.com"
default[:app][:web_dir] = "/var/data/www/apps/minemart"

default[:rvm][:user_installs] = [{
  :user => 'minemart',
  :default_ruby => "ruby-2.1.1"
}]

default[:user][:name] = "minemart"

default[:nginx][:version] = "1.4.4"
default[:nginx][:default_site_enabled] = true
default[:nginx][:source][:modules] = [
  "nginx::http_gzip_static_module",
  "nginx::http_ssl_module",
  "nginx::http_gzip_static_module",
  "nginx::passenger"]
default[:nginx][:passenger][:version] = "4.0.37"
default[:nginx][:passenger][:ruby] = "/home/minemart/.rvm/wrappers/ruby-2.1.1/ruby"
default[:nginx][:passenger][:root] = "/home/minemart/.rvm/gems/ruby-2.1.1/gems/passenger-4.0.37"

default[:opencv][:version] = "2.4.6.1"