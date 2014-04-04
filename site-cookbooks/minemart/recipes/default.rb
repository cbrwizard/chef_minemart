# Note: user is added manually because of complicated things

# add github to list of knows hosts
ssh_known_hosts_entry 'github.com'

# fixes locales
# @todo: make it launch only once
bash "fix_locales" do
  user "root"
  code <<-EOH
    sudo locale-gen en_US ru_RU.UTF-8
    dpkg-reconfigure locales
  EOH
end

#--installs needed packages
#postgresql
package "postgresql-9.1"
package "libpq-dev"
package "postgresql-contrib"

# redis
package "tcl8.5"
package "redis-server"

#--installs main gems
gem_package 'bundler'
gem_package "rails" do
  version "4.0.0"
end
gem_package 'capistrano' do
  version '2.15'
end

# # turns on website
# nginx_site "#{node.app.name}.conf" do
#   cookbook "minemart"
#   template 'nginx.conf.erb'
#   action :enable
# end

# dependencies for opencv
# @todo find and remove not needed packages
['libmagickwand-dev', 'libopencv-dev', 'checkinstall', 'cmake', 'yasm', 'libgstreamer0.10-dev', 'libgstreamer-plugins-base0.10-dev', 'libv4l-dev', 'python-dev', 'python-numpy', 'libtbb-dev', 'qt4-dev-tools', 'libqt4-core', 'libqt4-dev', 'libqt4-gui', 'libgtk2.0-dev'].each do |apt|
  package apt do
    action :upgrade
    options "--force-yes"
  end
end

# downloads and installs opencv
bash "download_opencv" do
  not_if {::File.exists?("/home/#{node.user.name}/opencv-#{node.opencv.version}")}
  cwd "/home/#{node.user.name}"
  code <<-EOH
    wget -O OpenCV-#{node.opencv.version} #{node.opencv.url} && tar -zxf OpenCV-#{node.opencv.version} && cd opencv-#{node.opencv.version}
  EOH
end

bash "install_opencv" do
  not_if {::File.exists?("/home/#{node.user.name}/opencv-#{node.opencv.version}/build")}
  cwd "/home/#{node.user.name}/opencv-#{node.opencv.version}"
  code <<-EOH
    mkdir build && cd build && cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D WITH_TBB=ON -D BUILD_NEW_PYTHON_SUPPORT=ON -D WITH_V4L=ON -D BUILD_EXAMPLES=ON -D WITH_QT=ON -D WITH_OPENGL=ON .. && make && sudo make install && sudo sh -c 'echo "/usr/local/lib" > /etc/ld.so.conf.d/opencv.conf' &&  sudo ldconfig
  EOH
end