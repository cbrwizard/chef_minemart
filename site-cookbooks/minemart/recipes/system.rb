# adds memory for installation stuff
bash "add_swap" do
  ignore_failure true
  code <<-EOH
    sudo fallocate -l 1024m /var/spool/swap
    sudo mkswap /var/spool/swap
    sudo swapon /var/spool/swap
  EOH
end

# fixes locales
# @todo: make it launch only once
bash "fix_locales" do
  user "root"
  code <<-EOH
    sudo locale-gen en_US ru_RU.UTF-8
    dpkg-reconfigure locales
  EOH
end

# adds github to list of knows hosts
ssh_known_hosts_entry 'github.com'

# sets default ruby
rvm_default_ruby "ruby-2.1.1"