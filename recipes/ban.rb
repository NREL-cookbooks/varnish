#
# Cookbook Name:: varnish
# Recipe:: ban
#
# Copyright 2012, NREL
#
# All rights reserved - Do Not Redistribute
#

include_recipe "varnish"

# A standalone script that can intract with varnishadm to only perform bans.
# This way we can allow sudo access to only this script and not the whole
# varnish admin.
template "/usr/local/bin/varnish_ban" do
  source "varnish_ban.erb"
  mode "0755"
end
