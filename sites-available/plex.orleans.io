upstream plex_websocket {
  server host.docker.internal:32400;
}

map $http_upgrade $connection_upgrade {
  default upgrade;
  ''      close;
}

server {
  server_name plex.orleans.io;

  listen 4443 ssl; # default_server;
  listen [::]:4443 ssl;

  include snippets/ssl-settings.conf;

  proxy_buffering off;

  location / {
    proxy_pass https://host.docker.internal:32400;
    proxy_set_header Host $host;
    proxy_redirect http:// https://;
    proxy_http_version 1.1;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection $connection_upgrade;
  }

  include snippets/certbot-well-known.conf;
}

