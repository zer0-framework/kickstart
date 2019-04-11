# Инструкция

## Подготовка сервера
Для работы требуется Nginx, PHP-FPM и composer.

В Ubuntu их можно разом установить так:
```
sudo apt-get install -y software-properties-common
sudo add-apt-repository ppa:ondrej/php
sudo apt install -y nginx php7.3-fpm php7.3-opcache php7.3-xml php7.3-cli php7.3-yaml php7.3-mbstring php7.3-dev libevent-dev composer make pkg-config php7.3-curl php7.3-pgsql php-pear
sudo pecl install event igbinary
echo 'extension=event.so' | sudo tee -a /etc/php/7.3/cli/conf.d/20-event.ini
echo "extension=event.so" | sudo tee -a /etc/php/7.3/fpm/conf.d/20-event.ini
echo 'extension=igbinary.so' | sudo tee -a /etc/php/7.3/cli/conf.d/20-igbinary.ini
echo "extension=igbinary.so" | sudo tee -a /etc/php/7.3/fpm/conf.d/20-igbinary.ini
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
* all: `packages fmt build test`
* fmt
    * fmt-php — отформатировать PHP-код
    * fmt-js — отформатировать код Javascript
    * fmt-css — отформатировавать CSS
* packages
    * packages-composer — установка пакетов через composer (composer.json)
    * packages-yarn — установка пакетов через yarn (packages.json)
* build
    * build-backend — генерация конфигурационного файла Nginx и файла Routes.cfg.js
    * build-frontend — запустить сборку бандлов с помощью npm в зависимости от ENV.
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
