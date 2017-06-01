#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root or use sudo" 
   exit 1
fi

if [ "$#" -ne 1 ]
then
  echo "You need to pass the logged in username."
  exit 1
fi

echo "Removing default nginx configuration."
rm -rf /etc/nginx/sites-enabled/default
rm -rf /etc/nginx/sites-available/default
echo "Removal done."
echo "Configuring NGINX with $1 user..."
echo 'upstream kolibri {
    server 127.0.0.1:8080;
}

server {

    listen 8008;

    location /static {
        alias   /home/'$1'/.kolibri/static;
    }


    location /content {
        alias   /home/'$1'/.kolibri/content/;
    }

    location /favicon.ico {
        empty_gif;
    }

    location / {
        proxy_set_header Host $http_host;
        proxy_set_header X-Scheme $scheme;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_pass http://kolibri;
        error_page 502 = @502;
    }

    location @502 {
        types { }
        default_type "text/html";
        return 502 "
        <BR>
        <H1>Kolibri might be busy - wait a few moments and then reload this page
        <BR><BR>
        <H2>If kolibri is still busy, get help from the system administrator
        <H3>Error code: nginx 502 Bad Gateway (maybe the kolibri webserver is not working correctly)";
    }

}' > /etc/nginx/sites-enabled/default
echo 'upstream kolibri {
    server 127.0.0.1:8080;
}

server {

    listen 8008;

    location /static {
        alias   /home/'$1'/.kolibri/static/;
    }

    location /content {
        alias   /home/'$1'/.kolibri/content/;
    }

    location /favicon.ico {
        empty_gif;
    }

    location / {
        proxy_set_header Host $http_host;
        proxy_set_header X-Scheme $scheme;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_pass http://kolibri;
        error_page 502 = @502;
    }

    location @502 {
        types { }
        default_type "text/html";
        return 502 "
        <BR>
        <H1>kolibri might be busy - wait a few moments and then reload this page
        <BR><BR>
        <H2>If kolibri is still busy, get help from the system administrator
        <H3>Error code: nginx 502 Bad Gateway (maybe the kolibri webserver is not working correctly)";
    }

}' > /etc/nginx/sites-available/default
echo "Nginx is configured with $1 user..."

service nginx start
