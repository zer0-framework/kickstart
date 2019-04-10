map $sent_http_content_type $expires {
  default                   off;
  ~image/                   max;
  ~video/                   max;
  ~audio/                   max;
  text/css                  max;
  application/javascript    max;
  application/font-woff     max;
}
server {
    set $projectDir "<?php echo ZERO_ROOT; ?>";
    root $projectDir/public;

<?php echo $indentStr(file_get_contents(__DIR__ . '/listen.usr.conf'), 1); ?>
<?php echo $indentStr(file_get_contents(__DIR__ . '/is-mobile.conf'), 1); ?>

    #auth_basic           "restricted area";
    #auth_basic_user_file $projectDir/nginx/.htpasswd;

    server_name <?php echo $config->server_name; ?>;
    error_log  /var/log/nginx/error_<?php echo $config->server_name; ?>.log notice;
    access_log  /var/log/nginx/access_<?php echo $config->server_name; ?>.log;

    default_type  application/octet-stream;

    charset utf-8;
    gzip on;
    gzip_types text/plain text/css application/json application/javascript \
     text/xml application/xml application/xml+rss text/javascript application/x-javascript;
    client_max_body_size 200m;

    expires $expires;

    sendfile on;
    tcp_nopush off;

    add_header X-Frame-Options SAMEORIGIN;
    add_header X-XSS-Protection "1; mode=block";

    error_page 403 /error/403;
    error_page 404 /error/404;
    error_page 405 /error/405;
    error_page 500 /error/500;

    location = /robots.txt {return 200 "User-agent: *\nDisallow: /\n";}

    location ~ /\. {
        deny all;
    }

    location /img/ {
        alias $projectDir/public/img/;
        try_files $uri /error/404;
    }

    location /css/ {
        alias $projectDir/public/css/;
        try_files $uri /error/404;
    }

    location /fonts/ {
        alias $projectDir/public/fonts/;
        try_files $uri /error/404;
    }

    location /js/ {
        alias $projectDir/public/js/;
        try_files $uri /error/404;
    }

    location /lib/ {
        alias $projectDir/public/lib/;
        try_files $uri /error/404;
    }

    location /storage/ {
        alias /storage/;
    }

    location /dist/node_modules/ {
        alias $projectDir/node_modules/;
        try_files $uri /error/404;
    }

    location /dist/ {
        alias $projectDir/dist/;
        try_files $uri /error/404;
    }

    location /dist/public/ {
        alias $projectDir/public/;
        try_files $uri /error/404;
    }


<?php echo $indentStr($routesGenerator->generate('fastcgi_param IS_MOBILE $mobile;'), 1); ?>
}
