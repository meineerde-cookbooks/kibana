#
# Cookbook Name:: kibana
# Recipe:: default
#
# Copyright 2012, Holger Just
#

include_recipe "logstash"
include_recipe "git"
include_recipe "build-essential"

gem_package "bundler"

if Chef::Config[:solo]
  es_server_ip = node['logstash']['elasticsearch_ip']
else
  es_server_results = search(:node, "roles:#{node['logstash']['elasticsearch_role']} AND chef_environment:#{node.chef_environment}")
  unless es_server_results.empty?
    es_server_ip = es_server_results.map{|node| node['ipaddress']}
  else
    es_server_ip = node['logstash']['elasticsearch_ip']
  end
end

kibana_config = node['kibana']['config'].to_hash
kibana_config['Elasticsearch'] = Array(es_server_ip).collect{|ip| "#{ip}:9200"}

kibana_dir = "#{node['logstash']['basedir']}/kibana"
[kibana_dir, "#{kibana_dir}/shared"].each do |dir|
  directory dir do
    owner node['logstash']['user']
    group node['logstash']['group']
    mode '0755'
    recursive true
  end
end

%w[tmp logs].each do |dir|
  directory "#{kibana_dir}/shared/#{dir}" do
    owner node['logstash']['user']
    group node['logstash']['group']
    mode '0750'
    recursive true
  end
end

template "#{kibana_dir}/shared/KibanaConfig.rb" do
  source "KibanaConfig.rb.erb"
  owner node['logstash']['user']
  group node['logstash']['group']
  mode "0755"
  variables :config => kibana_config
end

deploy_revision "Kibana" do
  repository node['kibana']['repository']
  revision node['kibana']['revision']

  user node['logstash']['user']
  group node['logstash']['group']

  deploy_to kibana_dir

  action node['kibana']['force_deploy'] ? :force_deploy : :deploy

  symlinks({
   "tmp" => "tmp",
   "log" => "log"
  })
  symlink_before_migrate({
    "KibanaConfig.rb" => "KibanaConfig.rb"
  })

  before_migrate do
    execute "bundle install" do
      cwd release_path
      user 'root'
      group 'root'
    end
  end

  notifies :restart, "service[kibana]"
end

case node['kibana']['init_style']
when "init"
  template "/etc/init.d/kibana" do
    source "kibana.init.erb"
    owner "root"
    group "root"
    mode "0755"

    notifies :restart, "service[kibana]"
  end

  service "kibana" do
    supports :restart => true, :status => true
    action [:enable, :start ]
  end
when "runit"
  include_recipe "runit"

  runit_service "kibana" do
    action [ :enable, :start ]
  end
when "apache"
  service "kibana" do
    action [ :disable ]
    only_if { File.exists? "/etc/init.d/kibana" }
  end

  include_recipe "passenger_apache2"

  web_app node['kibana']['server_name'] do
    template "apache.conf.erb"
    cookbook "kibana"

    docroot "#{kibana_dir}/current/public"
    server_port node['kibana']['server_port']
  end
else
  raise "unknown init style #{node['kibana']['init_style']}"
end