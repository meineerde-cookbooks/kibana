include_recipe "kibana::default"
include_recipe "passenger_apache2"

kibana_dir = "#{node['logstash']['basedir']}/kibana"
web_app node['kibana']['server_name'] do
  template "apache.conf.erb"
  cookbook "kibana"

  docroot "#{kibana_dir}/current/public"
  server_port node['kibana']['server_port']
end

if File.exists?("#{kibana_dir}/current")
  d = resources(:deploy_revision => "Kibana")
  d.restart_command "touch \"#{kibana_dir}/current/tmp/restart.txt\""
end