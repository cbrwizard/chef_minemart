# installs passenger gem
gem_package 'passenger'
package 'nodejs'
package 'libcurl4-openssl-dev'

execute "install nginx with passenger" do
  not_if {::File.exists?("/opt/nginx/conf/nginx.conf")}
  command "passenger-install-nginx-module --auto --auto-download --prefix=/opt/nginx"
end

# adds nginx conf file
template "/opt/nginx/conf/nginx.conf" do
  user 'minemart'
  source "nginx.conf.erb"
  mode 0440
end