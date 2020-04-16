map $http_upgrade $connection_upgrade {
  default upgrade;
  ''      close;
}

server {
  server_name public.oc.orleans.io;

  listen 4443 ssl; # default_server;
  listen [::]:4443 ssl;

  include snippets/ssl-settings.conf;

  location / {
    root /var/public-www/;

    sendfile off;
  }

  include snippets/certbot-well-known.conf;
}

