#
# Deploys node & nginx
#

include:
  - avahi
  - nginx
  - mongodb
  - nvmnode

{% from "utils/users.sls" import skeleton %}
{% from "nvmnode/macros.sls" import nvmnode %}
{% from "nginx/macros.sls" import nginxsite %}


{% set short_name = pillar['project']['short_name'] -%}
{% set home = "/home/vagrant" -%}
{% set project = home + "/domains/" + short_name -%}
{% set appdir = home + "/domains/" + short_name + "/www" -%}
{% set app_user = "vagrant" -%}
{% set app_group = "vagrant" -%}

{{ skeleton(app_user, 1000, 1000, remove_groups=False) }}


{{ nginxsite(short_name, app_user, app_group,
             template="salt://nginx/files/proxy-upstream.conf",
             server_name="_",
             create_root=False,
             root='app',
             defaults={
              'port': 3000,
              'try_files': '$uri @upstream'
             })
}}

{{ nvmnode(short_name, app_user, app_group,
                 defaults={},
                 node_packages=['-g express', '-g forever'],
                 node_version='0.10.29',
                 custom=None) }}
# vim: set ft=yaml ts=2 sw=2 sts=2 et ai :
