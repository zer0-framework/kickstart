# Инструкция

## Подготовка сервера
Для работы требуется Nginx, PHP-FPM и composer.

В Ubuntu их можно разом установить так:
```
sudo add-apt-repository ppa:ondrej/php
sudo apt install nginx php7.2-fpm php7.2-opcache php-xml php-yaml php-mbstring php-dev libevent-dev php-pear composer make php-curl php-pgsql
sudo pecl install event 
echo 'extension=event.so' | sudo tee -a /etc/php/7.2/cli/conf.d/20-event.ini
echo "extension=event.so" | sudo tee -a /etc/php/7.2/fpm/conf.d/20-event.ini
```

Установим NPM и Yarn:
```
curl -sL https://deb.nodesource.com/setup_8.x | sudo bash -
sudo apt-get install -y nodejs
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update && sudo apt-get install npm yarn
```

Установим глобальные утилиты:
```
sudo yarn global add browserify watchify minifyjs prettier
sudo npm install -g uglifyify
```

Также для удобства работы в bash рекомендуется выполнить `cat .bash_profile >> ~/.bash_profile` и затем `bash`. 

## Сборка проекта

Сценарий построен с использованием на GNU Make 4+ (он же `make`).
 
### Этапы
* all: `packages fmt routes build test`
* fmt
    * fmt-php — отформатировать PHP-код
    * fmt-js — отформатировать код Javascript
    * fmt-css — отформатировавать CSS
* packages
    * packages-composer — установка пакетов через composer (composer.json)
    * packages-yarn — установка пакетов через yarn (packages.json)
* routes — генерация конфигурационного файла Nginx и файла Routes.cfg.js
* build — запустить сборку бандлов с помощью npm в зависимости от ENV.
* migrate — накатить миграции
* test — выполнить тесты 
* clean — удалить все созданные в процессе сборки файлы/папки

### Переменные
* ENV (значения _dev_, _prod_, _stage_) — содержит название текущей среды.


### Примеры
 
Запустить сборку в окружении для разработчика можно так:  `make ENV=dev`

Чтобы запустить автоматическую пересборку JS и CSS при изменении файлов: `BUNDLE=main npm run watch`,
где переменная `BUNDLE` означает название бандла (`main`, `admin`, ...).

Чтобы запустить production-сборку: `make ENV=prod`


### Настройка NGINX

Необходимо добавить nginx/server.conf в sites-enabled: 

`ln -s <КОРЕНЬ ПРОЕКТА>/nginx/server.conf /etc/nginx/sites-enabled/001-site.conf`

При необходимости подправив в нём конфигурацию upstream fpm. И перезапустить NGINX.
