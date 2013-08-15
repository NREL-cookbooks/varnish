case platform
when "debian","ubuntu"
  set['varnish']['dir']     = "/etc/varnish"
  set['varnish']['default'] = "/etc/default/varnish"
  set['varnish']['log']['default'] = "/etc/default/varnishlog"
  set['varnish']['ncsa']['default'] = "/etc/default/varnishncsa"
when "redhat", "centos", "fedora", "scientific"
  set['varnish']['dir']     = "/etc/varnish"
  set['varnish']['default'] = "/etc/sysconfig/varnish"
  set['varnish']['log']['default'] = "/etc/sysconfig/varnishlog"
  set['varnish']['ncsa']['default'] = "/etc/sysconfig/varnishncsa"
end

default['varnish']['version'] = "2.1"

default['varnish']['start'] = 'yes'
default['varnish']['nfiles'] = 131072
default['varnish']['memlock'] = 82000
default['varnish']['instance'] = node['fqdn']
default['varnish']['listen_address'] = ''
default['varnish']['listen_port'] = 6081
default['varnish']['vcl_conf'] = 'default.vcl'
default['varnish']['vcl_source'] = 'default.vcl.erb'
default['varnish']['vcl_cookbook'] = nil
default['varnish']['secret_file'] = '/etc/varnish/secret'
default['varnish']['admin_listen_address'] = '127.0.0.1'
default['varnish']['admin_listen_port'] = '6082'
default['varnish']['user'] = 'varnish'
default['varnish']['group'] = 'varnish'
default['varnish']['ttl'] = '120'
default['varnish']['thread_pools'] = '2'
default['varnish']['min_threads'] ='5'
default['varnish']['max_threads'] = '500'
default['varnish']['thread_timeout'] = '300'
default['varnish']['storage'] = 'file'
# Don't use /var/lib/varnish:
# https://www.varnish-software.com/static/book/Tuning.html#the-shared-memory-log
default['varnish']['storage_file'] = '/tmp/varnish/$INSTANCE/varnish_storage.bin'
default['varnish']['storage_size'] = '1G'

default['varnish']['backend_host'] = 'localhost'
default['varnish']['backend_port'] = '8080'
default['varnish']['backend_first_byte_timeout'] = '60s'

default['varnish']['shm_log_size'] = '80m'
# Seems to need to be at least double the size of shm_log_size so restarts can
# occur without errors.
default['varnish']['shm_tmpfs_size'] = '200m'
default['varnish']['cli_timeout'] = 10
default['varnish']['http_req_hdr_len'] = 8192
default['varnish']['internal_networks'] = ['"localhost"']
