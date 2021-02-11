map $http_upgrade $connection_upgrade {
  default upgrade;
  ''      close;
}

server {
  server_name default.orleans.io;

  listen 4443 ssl http2 default_server;
  listen [::]:4443 ssl http2;

  include snippets/ssl-settings.conf;

  location / {
    return 404;

    include snippets/hsts-settings.conf;
  }

  include snippets/certbot-well-known.conf;
}

