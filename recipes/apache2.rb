include_recipe "kibana::default"
include_recipe "passenger_apache2::mod_rails"

kibana_dir = "#{node['logstash']['basedir']}/kibana"
web_app node['kibana']['server_name'] do
  template node['kibana']['apache_template']
  cookbook node['kibana']['apache_cookbook']

  docroot "#{kibana_dir}/current/public"
  server_port node['kibana']['server_port']
end

if File.exists?("#{kibana_dir}/current")
  d = resources(:deploy_revision => "Kibana")
  d.restart_command "touch \"#{kibana_dir}/current/tmp/restart.txt\""
end

execute "restart Kibana" do
  command "touch \"#{kibana_dir}/current/tmp/restart.txt\""
  action :nothing
  subscribes :run, resources(:template => "#{kibana_dir}/shared/KibanaConfig.rb")
end
