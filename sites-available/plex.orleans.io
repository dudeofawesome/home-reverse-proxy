upstream plex_upstream {
  server host.docker.internal:32400;
}

map $http_upgrade $connection_upgrade {
  default upgrade;
  ''      close;
}

server {
  server_name plex.orleans.io;

  listen 4443 ssl http2;
  listen [::]:4443 ssl http2;

  include snippets/ssl-settings.conf;

  proxy_buffering off;

  client_max_body_size 20M;

  location / {
    resolver 127.0.0.11 valid=30s;
    set $upstream plex_upstream;

    proxy_pass https://$upstream;
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
