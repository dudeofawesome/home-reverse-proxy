upstream analytics_upstream {
  server matomo:80;
}

map $http_upgrade $connection_upgrade {
  default upgrade;
  ''      close;
}

server {
  server_name analytics.orleans.io data.flawlessexecution.gg data.orleans.io;

  listen 4443 ssl http2;
  listen [::]:4443 ssl http2;

  include snippets/ssl-settings.conf;

  proxy_buffering off;

  location / {
    resolver 127.0.0.11 valid=30s;
    set $upstream analytics_upstream;
    proxy_pass http://$upstream;
    proxy_set_header Host $host;
    proxy_redirect http:// https://;
    proxy_http_version 1.1;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection $connection_upgrade;
    include snippets/hsts-settings.conf;
  }

  location /m.php {
    if ($args ~* (.*)(aname=)(.*)) {
      set $args $1action_name=$3;
      rewrite ^(.*)$ $1;
    }
    if ($args ~* (.*)(ocidsite=)(.*)) {
      set $args $1idsite=$3;
      rewrite ^(.*)$ $1;
    }

    resolver 127.0.0.11 valid=30s;
    set $upstream analytics_upstream;
    proxy_pass http://$upstream/matomo.php$is_args$args;
    proxy_set_header Host $host;
    proxy_redirect http:// https://;
    proxy_http_version 1.1;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection $connection_upgrade;
    include snippets/hsts-settings.conf;
  }

  location /m.js {
    resolver 127.0.0.11 valid=30s;
    set $upstream analytics_upstream;
    proxy_pass http://$upstream/matomo.js$is_args$args;
    proxy_set_header Host $host;
    proxy_redirect http:// https://;
    proxy_http_version 1.1;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection $connection_upgrade;
    include snippets/hsts-settings.conf;
  }

  include snippets/certbot-well-known.conf;
}

