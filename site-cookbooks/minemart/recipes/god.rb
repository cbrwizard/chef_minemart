# installs god

rvm_shell "god gem" do
  user node.user.name
  code "gem install god"
end

rvm_shell "create rvm wrapper" do
  user node.user.name
  code "rvm wrapper #{node.app.ruby} boot god"
end

# adds god init file
template "/etc/init.d/god" do
  source "godInit.erb"
  mode 0771
end

execute "prepare log file for god" do
  not_if {::File.exists?("/var/log/god.log")}
  command "sudo touch /var/log/god.log && sudo mkdir /opt/god"
end

execute "prepare startup for god" do
  not_if {::File.exists?("/opt/god/master.conf")}
  command "sudo chmod +x /etc/init.d/god && sudo update-rc.d -f god defaults"
end

# adds god config file
template "/opt/god/master.conf" do
  source "godConfig.erb"
  mode 0440
end
