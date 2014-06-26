# pg and redis ip allow tasks

ruby_block "allow redis connection" do
  block do
    file = Chef::Util::FileEdit.new("/etc/redis/redis.conf")
    file.insert_line_if_no_match(/#
#
# access for certain user server
bind 127.0.0.1 10.129.209.205/,
                               "#
#
# access for certain user server
bind 127.0.0.1 10.129.209.205")
    file.write_file
  end
end


ruby_block "allow pg connection" do
  block do
    file = Chef::Util::FileEdit.new("/etc/postgresql/9.1/main/pg_hba.conf")
    file.insert_line_if_no_match(/host    all             all             10.129.209.0\/24          md5/,
                               "host    all             all             10.129.209.0\/24          md5")
    file.write_file
  end
end


ruby_block "allow pg connection from all sources" do
  block do
    file = Chef::Util::FileEdit.new("/etc/postgresql/9.1/main/postgresql.conf")
    file.insert_line_if_no_match(/#
    #
    # access for all addresses
    listen_addresses = '*'/,
                               "#
#
# access for all addresses
listen_addresses = '*'")
    file.write_file
  end
end