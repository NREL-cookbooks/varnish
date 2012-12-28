# Cookbook Name:: varnish
# Recipe:: default
# Author:: Joe Williams <joe@joetify.com>
# Contributor:: Patrick Connolly <patrick@myplanetdigital.com>
#
# Copyright 2008-2009, Joe Williams
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "iptables::http"
include_recipe "iptables::https"
include_recipe "yum::varnish"

directory "/srv/log/varnish" do
  recursive true
  owner "root"
  group "root"
  mode 0755
end

execute "mv /var/log/varnish/* /srv/log/varnish/; rm -rf /var/log/varnish" do
  not_if { ::File.symlink?("/var/log/varnish") }
end

link "/var/log/varnish" do
  to "/srv/log/varnish"
end

package "varnish"

template "#{node['varnish']['dir']}/default.vcl" do
  source "default.vcl.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :reload, "service[varnish]"
end

template node['varnish']['default'] do
  source "custom-default.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :restart, "service[varnish]"
end

template node['varnish']['ncsa']['default'] do
  source "sysconfig_varnishncsa.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :restart, "service[varnishncsa]"
end

# The init.d script seems to fail to start unless the storage directory already
# exists. So make sure any instance-specific directories exist.
storage_dir = File.dirname(node[:varnish][:storage_file])
storage_dir.gsub!("$INSTANCE", node[:varnish][:instance])
directory storage_dir do
  recursive true
  owner "root"
  group "root"
  mode 0755
end

# Even if storage_file is changed, Varnish seems to demand that
# /var/lib/varnish/INSTANCE exist before it will boot.
directory "/var/lib/varnish/#{node[:varnish][:instance]}" do
  recursive true
  owner "root"
  group "root"
  mode 0755
end

logrotate_app "varnish" do
  path ["/var/log/varnish/*.log"]
  frequency "daily"
  rotate 90
  create "644 root root"
  cookbook "varnish"
end

service "varnish" do
  supports :restart => true, :reload => true
  action [ :enable, :start ]
end

service "varnishlog" do
  supports :restart => true, :reload => true
  action [ :enable, :start ]
end

service "varnishncsa" do
  supports :restart => true, :reload => true
  action [ :enable, :start ]
end
