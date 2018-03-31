upstream plex_websocket {
  server 10.0.0.100:32400;
}

map $http_upgrade $connection_upgrade {
  default upgrade;
  ''      close;
}

server {
  server_name plex.orleans.io;

  listen 4443 ssl; # default_server;
  listen [::]:4443 ssl;

  ssl on;
  ssl_certificate /etc/letsencrypt/live/oc.orleans.io/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/oc.orleans.io/privkey.pem;
  ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
  ssl_ciphers "EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH:!aNULL:!eNULL:!EXPORT:!DES:!MD5:!PSK:!RC4";
  ssl_prefer_server_ciphers on;
  ssl_session_cache shared:SSL:10m;

  proxy_buffering off;

  location / {
    proxy_pass https://localhost:32400;
    proxy_set_header Host $host;
    proxy_redirect http:// https://;
    proxy_http_version 1.1;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection $connection_upgrade;
  }
}

