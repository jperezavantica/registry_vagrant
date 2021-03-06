# default path
Exec {
  path => ["/usr/bin", "/bin", "/usr/sbin", "/sbin", "/usr/local/bin", "/usr/local/sbin"]
}

include bootstrap
class {
  orcid_base::baseapps:
    enable_google_authenticator => false
}

include orcid_base::common_libs

user { "orcid_tomcat":
  ensure  => present,
  uid  => '7006',
  shell  => '/bin/bash',
  home  => '/home/orcid_tomcat',
  managehome => true,
  password => '$6$ZHUQRrIW.9iTAJ0Z$9vyWYor7k6SwxWvra5osKjZyuqHN30tQQJJFsrbDQkwfN1z1eRG7LUJUK6krOIWlCLCR9G05tA5pXfS4CPsyO/',
}

file { "/home/orcid_tomcat":
  ensure  => directory,
  owner => orcid_tomcat,
  group => orcid_tomcat,
  require => User["orcid_tomcat"],
}

class { 'orcid_java': }

notify { "config file is ${orcid_config_file}": }

class {
  orcid_tomcat:
    orcid_config_file => $orcid_config_file,
    tomcat_catalina_opts => '-Xmx2000m -XX:MaxPermSize=512m
-Dfile.encoding=utf-8 
-Dsolr.solr.home=/home/orcid_tomcat/bin/tomcat/webapps/orcid-solr-web/solr 
-Dsolr.data.dir=/home/orcid_tomcat/data/orcid-solr 
-Dorg.apache.tomcat.util.buf.UDecoder.ALLOW_ENCODED_SLASH=true
',
    require => [Class["orcid_java"], User["orcid_tomcat"]],
	archive_old_logs_cmd => "python /home/orcid_tomcat/scripts/delete_old_logs/delete_old_logs.py -delete 45"
}

include orcid_maven
include orcid_deployment
include orcid_python
class {
   orcid_jenkins:
      is_vagrant => true,
}
