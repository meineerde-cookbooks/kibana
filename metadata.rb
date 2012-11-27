maintainer "Holger Just"
maintainer_email "hjust@meine-er.de"
license "Apache 2.0"
description "Installs/Configures Kibana for Logstash"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version "0.0.1"

depends "git"
depends "logstash"
depends "runit"
depends "build-essential"
depends "apache2"
depends "passenger_apache2"

%w{ debian ubuntu }.each do |os|
  supports os
end
