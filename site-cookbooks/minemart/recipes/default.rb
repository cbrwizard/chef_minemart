# fixes locales
bash "fix_locales" do
  user "root"
  code <<-EOH
    sudo locale-gen en_US ru_RU.UTF-8
    dpkg-reconfigure locales
  EOH
end

#postgresql
package "postgresql-9.1"
package "libpq-dev"
package "postgresql-contrib"

# redis
package "tcl8.5"
package "redis-server"

#install main gems
gem_package "rails" do
  version "4.0.0"
end
gem_package 'capistrano' do
  version '2.15'
end
gem_package 'bundler'
gem_package 'passenger' do
  version node['nginx']['passenger']['version']
end
package 'nodejs'
package 'libcurl4-openssl-dev'

# set up nginx
# creates logs
%w(public logs).each do |dir|
  directory "#{node.app.web_dir}/#{dir}" do
    owner node.user.name
    mode "0755"
    recursive true
  end
end

# adds nginx.conf
template "#{node.nginx.dir}/sites-available/#{node.app.name}.conf" do
  source "nginx.conf.erb"
  mode "0644"
end

# turns on website
nginx_site "#{node.app.name}.conf" do
  cookbook "minemart"
  template 'nginx.conf.erb'
  action :enable
end

# adds test index.html
cookbook_file "#{node.app.web_dir}/public/index.html" do
  source "index.html"
  mode 0755
  owner node.user.name
  action :create_if_missing
end

# adds memory for install stuff
bash "add_swap" do
  user "minemart"
  code <<-EOH
    sudo fallocate -l 1024m /var/spool/swap
    sudo mkswap /var/spool/swap
    sudo swapon /var/spool/swap
  EOH
end

# dependencies for opencv
['libmagickwand-dev', 'libopencv-dev', 'build-essential', 'checkinstall', 'cmake', 'pkg-config', 'yasm', 'libtiff4-dev', 'libjpeg-dev', 'libjasper-dev', 'libavcodec-dev', 'libavformat-dev', 'libswscale-dev', 'libdc1394-22-dev', 'libxine-dev', 'libgstreamer0.10-dev', 'libgstreamer-plugins-base0.10-dev', 'libv4l-dev', 'python-dev', 'python-numpy', 'libtbb-dev', 'libqt4-dev', 'libgtk2.0-dev', 'qt5-default',  'qttools5-dev-tools' ].each do |apt|
  package apt do
    action :upgrade
    options "--force-yes"
  end
end

# downloads and installs opencv
bash "download_opencv" do
  not_if {::File.exists?("/home/#{node.user.name}/opencv-#{node.opencv.version}/build")}
  cwd "/home/#{node.user.name}"
  code <<-EOH
    wget -O OpenCV-#{node.opencv.version} #{node.opencv.url} && tar -zxf OpenCV-#{node.opencv.version} && cd opencv-#{node.opencv.version} && mkdir build
  EOH
end

bash "install_opencv" do
  not_if system("pkg-config --modversion opencv") == node.opencv.version
  cwd "/home/#{node.user.name}/opencv-#{node.opencv.version}1/build"
  code <<-EOH
    cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D WITH_TBB=ON -D BUILD_NEW_PYTHON_SUPPORT=ON -D WITH_V4L=ON -D BUILD_EXAMPLES=ON -D WITH_QT=ON -D WITH_OPENGL=ON .. && make && sudo make install && sudo sh -c 'echo "/usr/local/lib" > /etc/ld.so.conf.d/opencv.conf' &&  sudo ldconfig
  EOH
end