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


# adds memory for passenger
execute "increase_memory" do
  command 'sudo dd if=/dev/zero of=/swap bs=1M count=1024 && sudo mkswap /swap && sudo swapon /swap'
end

#install main gems
gem_package "rails" do
  version "4.0.0"
end
gem_package 'capistrano'
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

## dependencies for opencv
#['libmagickwand-dev', 'libopencv-dev', 'build-essential', 'checkinstall', 'cmake', 'pkg-config', 'yasm', 'libtiff4-dev', 'libjpeg-dev', 'libjasper-dev', 'libavcodec-dev', 'libavformat-dev', 'libswscale-dev', 'libdc1394-22-dev', 'libxine-dev', 'libgstreamer0.10-dev', 'libgstreamer-plugins-base0.10-dev', 'libv4l-dev', 'python-dev', 'python-numpy', 'libtbb-dev', 'libqt4-dev', 'libgtk2.0-dev', 'qt5-default',  'qttools5-dev-tools' ].each do |apt|
#  package apt do
#    action :upgrade
#    options "--force-yes"
#  end
#end

## downloads and installs opencv
#bash "download_opencv" do
#  not_if {::File.exists?("/home/#{node.user.name}/opencv-2.4.6.1/build")}
#  cwd "/home/#{node.user.name}"
#  code <<-EOH
#    wget -O OpenCV-2.4.6.1 http://sourceforge.net/projects/opencvlibrary/files/opencv-unix/2.4.6.1/opencv-2.4.6.1.tar.gz/download && tar -zxf OpenCV-2.4.6.1 && cd opencv-2.4.6.1 && mkdir build
#  EOH
#end
#
#bash "install_opencv" do
#  not_if system("pkg-config --modversion opencv") == "2.4.6.1"
#  cwd "/home/#{node.user.name}/opencv-2.4.6.1/build"
#  code <<-EOH
#    cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D WITH_TBB=ON -D BUILD_NEW_PYTHON_SUPPORT=ON -D WITH_V4L=ON -D BUILD_EXAMPLES=ON -D WITH_QT=ON -D WITH_OPENGL=ON .. && make && sudo make install && sudo sh -c 'echo "/usr/local/lib" > /etc/ld.so.conf.d/opencv.conf' &&  sudo ldconfig
#  EOH
#end