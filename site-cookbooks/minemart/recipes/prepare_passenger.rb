# installs passenger gem before nginx configures it
gem_package 'passenger' do
  version node['nginx']['passenger']['version']
end