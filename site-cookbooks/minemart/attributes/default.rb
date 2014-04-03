default[:app][:name] = "minemart"
default[:app][:domain] = "cbrwizard.com"
default[:app][:web_dir] = "/var/data/www/apps/minemart"

default[:rvm][:user_installs] = [{
  :user => 'minemart',
  :default_ruby => "ruby-2.0.0-p353"
}]

default[:user][:name] = "minemart"

default[:nginx][:version] = "1.4.4"
default[:nginx][:default_site_enabled] = true
default[:nginx][:source][:modules] = [
  "nginx::http_gzip_static_module",
  "nginx::http_ssl_module",
  "nginx::http_gzip_static_module" ]
default[:nginx][:passenger][:version] = "4.0.37"