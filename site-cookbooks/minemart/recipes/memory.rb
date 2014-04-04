# adds memory for installation stuff
bash "add_swap" do
  user "minemart"
  ignore_failure true
  code <<-EOH
    sudo fallocate -l 1024m /var/spool/swap
    sudo mkswap /var/spool/swap
    sudo swapon /var/spool/swap
  EOH
end