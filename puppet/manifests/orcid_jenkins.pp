# default path
Exec {
  path => ["/usr/bin", "/bin", "/usr/sbin", "/sbin", "/usr/local/bin", "/usr/local/sbin"]
}

include bootstrap
include orcid_base::baseapps
include orcid_base::common_libs

# uncomment in production
# include orcid_jenkins

class {
    orcid_jenkins:
        is_vagrant => true
}