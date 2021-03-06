dirname = "monit-#{node[:monit][:version]}"
arch = node['kernel']['machine'] =~ /x86_64/ ? "64" : "86"
filename = "#{dirname}-linux-x#{arch}.tar.gz"

cookbook_file "/tmp/#{filename}" do
  source filename
  owner 'root'
  group 'root'
  mode '0644'
end

execute "tar zxfv #{filename}" do
  cwd "/tmp"
  user 'root'
  group 'root'
  not_if { File.exists?("/tmp/#{dirname}") }
end

execute "cp #{dirname}/bin/monit #{node[:monit][:bin_file]}" do
  cwd "/tmp"
  user 'root'
  group 'root'
  only_if { `monit -V | grep #{node[:monit][:version]}`.empty? }
end
