# system tasks

bash "prepare flag folder" do
  not_if {::File.exists?("/home/#{node.user.name}/flags")}
  cwd "/home/#{node.user.name}"
  code <<-EOH
     mkdir flags
  EOH
end

bash "prepare backups folder" do
  not_if {::File.exists?("/home/#{node.user.name}/backups")}
  cwd "/home/#{node.user.name}"
  code <<-EOH
     mkdir backups
  EOH
end

# adds memory for weak systems. Comment this and 2 next if not needed
bash "add_swap" do
  not_if {::File.exists?("/home/#{node.user.name}/flags/swap_added")}
  code <<-EOH
    sudo dd if=/dev/zero of=/swapfile bs=1024 count=1024k && sudo mkswap /swapfile && sudo swapon /swapfile
  EOH
end

ruby_block "add swap auto restart setting" do
  not_if {::File.exists?("/home/#{node.user.name}/flags/swap_added")}
  block do
    file = Chef::Util::FileEdit.new("/etc/fstab")
    file.insert_line_if_no_match(/\/swapfile       none    swap    sw      0       0 /,
                               "/swapfile       none    swap    sw      0       0 ")
    file.write_file
  end
end

# improves swap file speed. Comment this and next if not needed
bash "improve swap" do
  not_if {::File.exists?("/home/#{node.user.name}/flags/swap_added")}
  code <<-EOH
     echo 10 | sudo tee /proc/sys/vm/swappiness && echo vm.swappiness = 10 | sudo tee -a /etc/sysctl.conf
  EOH
end

# adds flag that swap was turned on
bash "add swap flag" do
  not_if {::File.exists?("/home/#{node.user.name}/flags/swap_added")}
  cwd "/home/#{node.user.name}/flags"
  code <<-EOH
     touch swap_added
  EOH
end

# fixes locales
bash "fix_locales" do
  not_if {::File.exists?("/home/#{node.user.name}/flags/locales_fixed")}
  user "root"
  code <<-EOH
    sudo locale-gen en_US ru_RU.UTF-8
    dpkg-reconfigure locales
  EOH
end

# adds flag that locales were fixed
bash "add locales flag" do
  not_if {::File.exists?("/home/#{node.user.name}/flags/locales_fixed")}
  cwd "/home/#{node.user.name}/flags"
  code <<-EOH
     touch locales_fixed
  EOH
end

# adds github to list of knows hosts
ssh_known_hosts_entry 'github.com'

# installs required packages
['nodejs', 'libcurl4-openssl-dev', 'openjdk-7-jdk', 'zip', 'unzip', 'Xvfb', 'p7zip-full'].each do |apt|
  package apt do
    action :upgrade
    options "--force-yes"
  end
end

bash 'install chrome webdriver' do
  not_if {::File.exists?('/usr/bin/chromedriver')}
  code <<-CODE
      wget -O /tmp/chromedriver.zip https://chromedriver.storage.googleapis.com/#{node.chromedriver.version}/chromedriver_linux64.zip
      unzip /tmp/chromedriver.zip chromedriver -d /usr/bin/
      chmod +x /usr/bin/chromedriver
      rm /tmp/chromedriver.zip
  CODE
end

# adds backup script
template "/opt/backupScript" do
  user "root"
  source "backupScript.erb"
  mode 0440
end

# gives permissions for backup script
bash "add permissions for backup script" do
  cwd "/opt"
  code <<-EOH
     sudo chmod 755 backupScript
  EOH
end

cron "launch backup script every day" do
  action :create
  minute "59"
  hour "23"
  user "minemart"
  command "/opt/backupScript"
end
