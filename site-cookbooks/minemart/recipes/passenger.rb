# installs passenger

rvm_shell "passenger gem" do
  user node.user.name
  code "gem install passenger -v 4.0.40"
end

rvm_shell "passenger_module" do
  not_if {::File.exists?("/opt/nginx/conf/nginx.conf")}
  user node.user.name
  code "rvmsudo passenger-install-nginx-module --auto --auto-download --prefix=/opt/nginx"
end

execute "add nginx launch script" do
  command "wget -O init-deb.sh http://library.linode.com/assets/660-init-deb.sh && sudo mv init-deb.sh /etc/init.d/nginx && sudo chmod +x /etc/init.d/nginx && sudo /usr/sbin/update-rc.d -f nginx defaults"
end

# adds nginx conf file
template "/opt/nginx/conf/nginx.conf" do
  source "nginx.conf.erb"
  mode 0440
end