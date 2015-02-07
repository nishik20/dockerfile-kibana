#!/usr/bin/env bash

ES_HOST=${ES_PORT_9200_TCP_ADDR:-localhost}
ES_PORT=${ES_PORT_9200_TCP_PORT:-9200}
ES_SCHEME=${ES_SCHEME:-http}

cat << EOF > /opt/kibana/config.js
define(['settings'],
function (Settings) {
  "use strict";

  return new Settings({
    elasticsearch: window.location.protocol + "//" + window.location.hostname + ":" + window.location.port,
    default_route: "/dashboard/file/logstash.json",
    kibana_index: "kibana-int",
    panel_names: ["histogram", "map", "pie", "table", "filtering", "timepicker", "text", "fields", "hits", "dashcontrol", "column", "derivequeries", "trends", "bettermap", "query", "terms"]
  });
});
EOF

cat << EOF > /etc/nginx/conf.d/kibana.conf
server {
  listen  0.0.0.0:80;

  server_name  kibana.localhost localhost.localdomain;
  access_log  /var/log/nginx/kibana.localhost.access.log;

  location / {
    root  /opt/kibana;
    index  index.html  index.htm;
  }

location ~ ^/_aliases$ {
    proxy_pass $ES_SCHEME://$ES_HOST:$ES_PORT;
    proxy_read_timeout 90;
  }
  location ~ ^/.*/_aliases$ {
    proxy_pass $ES_SCHEME://$ES_HOST:$ES_PORT;
    proxy_read_timeout 90;
  }
  location ~ ^/_nodes$ {
    proxy_pass $ES_SCHEME://$ES_HOST:$ES_PORT;
    proxy_read_timeout 90;
  }
  location ~ ^/.*/_search$ {
    proxy_pass $ES_SCHEME://$ES_HOST:$ES_PORT;
    proxy_read_timeout 90;
  }
  location ~ ^/.*/_mapping$ {
    proxy_pass $ES_SCHEME://$ES_HOST:$ES_PORT;
    proxy_read_timeout 90;
  }
  location ~ ^/_cluster/health$ {
    proxy_pass $ES_SCHEME://$ES_HOST:$ES_PORT;
    proxy_read_timeout 90;
  }

  # password protected end points
  location ~ ^/kibana-int/dashboard/.*$ {
    proxy_pass $ES_SCHEME://$ES_HOST:$ES_PORT;
    proxy_read_timeout 90;
  }
  location ~ ^/kibana-int/temp.*$ {
    proxy_pass $ES_SCHEME://$ES_HOST:$ES_PORT;
    proxy_read_timeout 90;
  }
}
EOF

nginx -c /etc/nginx/nginx.conf -g 'daemon off;'
