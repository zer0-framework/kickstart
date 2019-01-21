.PHONY: all fmt fmt-php fmt-js fmt-css packages routes build migrate test restart-services clean
LIST_ENV = dev prod
ENV = $(shell cat .env 2>/dev/null)
ifeq ($(filter $(ENV),$(LIST_ENV)),)
$(error Empty/wrong ENV. List of allowed values: $(LIST_ENV))
endif

all: packages fmt routes build test restart-services
fmt: fmt-php fmt-js fmt-css
fmt-php:
ifeq ($(ENV), dev)
	./cli/vendor/bin/php-cs-fixer fix src
	./cli/vendor/bin/php-cs-fixer fix libraries
endif

fmt-js:
ifeq ($(ENV), dev)
	prettier  --loglevel warn --single-quote  --write "public/js/**.js"
endif
fmt-css:
ifeq ($(ENV), dev)
	prettier --loglevel warn --write "public/css/**.css"
endif

packages: packages-composer packages-yarn
packages-composer:
	composer install
	cd cli && composer install

packages-yarn:
	yarn --dev

routes:
	echo $(ENV) > .env
	./vendor/bin/cli i18n build
	./vendor/bin/cli http build-all
	sudo service nginx reload

build:
	@@echo '------------------------------------------------'
	@@echo ENV = $(ENV)
	@@echo '------------------------------------------------'
	echo $(ENV) > .env

	mkdir -p dist migrations templates_c
	rm -f templates_c/*

ifeq ($(ENV), dev)
	BUNDLE=main npm run bundle-dev
	BUNDLE=admin npm run bundle-dev
else
	BUNDLE=main npm run bundle
	BUNDLE=admin npm run bundle
endif
	date +%s > .build-timestamp

test:
	./cli/vendor/bin/fastest -x phpunit.xml "./cli/vendor/bin/phpunit {};"

migrate:
	./cli/vendor/bin/phinx migrate

dry-migrate:
	./cli/vendor/bin/phinx migrate --dry-run

restart-services:
	vendor/bin/sockjs-server restart
	vendor/bin/queue-worker restart

clean:
	rm -rf dist node_modules vendor templates_c
