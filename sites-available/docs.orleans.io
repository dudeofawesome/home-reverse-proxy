upstream docs_websocket {
  server collabora:9980;
}

map $http_upgrade $connection_upgrade {
  default upgrade;
  ''      close;
}

server {
  server_name docs.orleans.io;

  listen 4443 ssl; # default_server;
  listen [::]:4443 ssl;

  include snippets/ssl-settings.conf;

  proxy_buffering off;

  location / {
    resolver 127.0.0.11 valid=30s;
    set $upstream collabora:9980;
    proxy_pass https://$upstream;
    proxy_set_header Host $host;
    proxy_redirect http:// https://;
    proxy_http_version 1.1;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection $connection_upgrade;
  }

  include snippets/certbot-well-known.conf;
}

