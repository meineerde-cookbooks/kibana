default['kibana']['repository'] = 'git://github.com/rashidkpc/Kibana.git'
default['kibana']['revision'] = 'kibana-ruby'
default['kibana']['force_deploy'] = false

# can be one of init, runit, apache, nginx
default['kibana']['init_style'] = 'init'


default['kibana']['server_name'] = node['ipaddress']
default['kibana']['server_port'] = 80

default['kibana']['apache_template'] = "apache.conf.erb"
default['kibana']['apche_cookbook'] = "kibana"

#############################################################################
# CONFIGURATION
# See https://github.com/rashidkpc/Kibana/blob/kibana-ruby/KibanaConfig.rb
# for a description of the configuration values

# These two settings are only relevant for running Kibana standalone
default['kibana']['config']['KibanaPort'] = 5601
default['kibana']['config']['KibanaHost'] = "0.0.0.0"

default['kibana']['config']['Type'] = ''
default['kibana']['config']['Per_page'] = 50
default['kibana']['config']['Timezone'] = 'user'
default['kibana']['config']['Time_format'] = 'mm/dd HH:MM:ss'
default['kibana']['config']['Default_fields'] = ['@message']
default['kibana']['config']['Default_operator'] = 'OR'
default['kibana']['config']['Analyze_limit'] = 2000
default['kibana']['config']['Analyze_show'] = 25
default['kibana']['config']['Rss_show'] = 25
default['kibana']['config']['Export_show'] = 2000
default['kibana']['config']['Export_delimiter'] = ','
default['kibana']['config']['Filter'] = ''
default['kibana']['config']['Smart_index'] = true
default['kibana']['config']['Smart_index_pattern'] = ['logstash-%Y.%m.%d']
default['kibana']['config']['Smart_index_limit'] = 150
default['kibana']['config']['Facet_index_limit'] = 1

# You probably don't want to touch anything below this line
# unless you really know what you're doing

default['kibana']['config']['Primary_field'] = '_all'
default['kibana']['config']['Default_index'] = '_all'
default['kibana']['config']['Disable_fullscan'] = false
default['kibana']['config']['Allow_iframed'] = false
default['kibana']['config']['Fallback_interval'] = 900
