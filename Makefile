#!make
include .env
export

.PHONY: all fmt fmt-php fmt-js fmt-css packages routes i18n build backend frontend devtools-dump migrate test restart-services clean
LIST_ENV = dev prod
ifeq ($(filter $(ENV),$(LIST_ENV)),)
$(error Empty/wrong ENV. List of allowed values: $(LIST_ENV))
endif

all: packages fmt build restart-services
fmt: fmt-php fmt-js fmt-css
fmt-php:
ifeq ($(ENV), dev)
	./cli/vendor/bin/php-cs-fixer fix src
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

backend: i18n routes devtools-dump

i18n:
	./vendor/bin/cli i18n build

routes:
	./vendor/bin/cli http build-all

devtools-dump:
	composer du
	./vendor/bin/cli devtools dump

frontend:
	mkdir -p dist migrations compiled/templates_c
	rm -f compiled/templates_c/*

ifeq ($(ENV), dev)
	BUNDLE=main npm run bundle-dev
	#BUNDLE=admin npm run bundle-dev
else
	BUNDLE=main npm run bundle
	#BUNDLE=admin npm run bundle
endif
	echo "BUILD_TS=$(shell date +%s)" > .env.build

test:
	./cli/vendor/bin/fastest -x phpunit.xml "./cli/vendor/bin/phpunit {};"

migrate:
	./cli/vendor/bin/phinx migrate

dry-migrate:
	./cli/vendor/bin/phinx migrate --dry-run

restart-services:
	sudo vendor/bin/sockjs-server restart
	sudo vendor/bin/queue-worker restart

clean:
	rm -rf dist node_modules vendor compiled
