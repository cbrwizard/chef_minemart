# installs passenger gem
gem_package 'passenger' do
  version node['nginx']['passenger']['version']
end
package 'nodejs'
package 'libcurl4-openssl-dev'

execute "install nginx with passenger" do
  command "rvmsudo passenger-install-nginx-module"
end