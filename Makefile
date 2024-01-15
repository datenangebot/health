app_name=health
project_dir=$(CURDIR)/../$(app_name)
build_dir=$(CURDIR)/build/artifacts
cert_dir=$(HOME)/.nextcloud/certificates
# php_dirs=appinfo/ lib/ tests/api/
php_dirs=appinfo/ lib/
appstore_build_directory=$(CURDIR)/build/artifacts/appstore
appstore_package_name=$(appstore_build_directory)/$(app_name)

all: dev-setup build


##### Environment ####

dev-setup: clean clean-dev init

init: composer-init npm-init

composer-init:
	composer install

npm-init:
	npm install

npm-upgrade:
	npm upgrade
	npm install

npm-update:
	npm update

ci:	lint-fix lint test

##### Building #####

build: clean build-js-production assemble

appstore: init build-js-production clean-dist
	rm -rf $(appstore_build_directory)
	mkdir -p $(appstore_build_directory)
	tar cvzf $(appstore_package_name).tar.gz \
	--exclude-vcs \
	--exclude="../$(app_name)/build" \
	--exclude="../$(app_name)/tests" \
	--exclude="../$(app_name)/Makefile" \
	--exclude="../$(app_name)/*.log" \
	--exclude="../$(app_name)/phpunit*xml" \
	--exclude="../$(app_name)/composer.*" \
	--exclude="../$(app_name)/js/node_modules" \
	--exclude="../$(app_name)/js/tests" \
	--exclude="../$(app_name)/js/test" \
	--exclude="../$(app_name)/js/*.log" \
	--exclude="../$(app_name)/js/package.json" \
	--exclude="../$(app_name)/js/bower.json" \
	--exclude="../$(app_name)/js/karma.*" \
	--exclude="../$(app_name)/js/protractor.*" \
	--exclude="../$(app_name)/package.json" \
	--exclude="../$(app_name)/bower.json" \
	--exclude="../$(app_name)/karma.*" \
	--exclude="../$(app_name)/protractor\.*" \
	--exclude="../$(app_name)/.*" \
	--exclude="../$(app_name)/js/.*" \
	../$(app_name) \

appstore-local: build
	@echo "Signing…"
#	php ../server/occ integrity:sign-app \
#		--privateKey=$(cert_dir)/$(app_name).key\
#		--certificate=$(cert_dir)/$(app_name).crt\
#		--path=$(build_dir)/$(app_name)
	tar -czf $(build_dir)/$(app_name).tar.gz \
		-C $(build_dir) $(app_name)
	openssl dgst -sha512 -sign $(cert_dir)/$(app_name).key $(build_dir)/$(app_name).tar.gz | openssl base64

assemble:
	mkdir -p $(build_dir)
	rsync -a \
	--exclude=babel.config.js \
	--exclude=build \
	--exclude=composer.* \
	--exclude=CONTRIBUTING.md \
	--exclude=.editorconfig \
	--exclude=.eslintrc.js \
	--exclude=.git \
	--exclude=.github \
	--exclude=.gitignore \
	--exclude=l10n/no-php \
	--exclude=Makefile \
	--exclude=node_modules \
	--exclude=package*.json \
	--exclude=.php_cs.* \
	--exclude=phpunit*xml \
	--exclude=.scrutinizer.yml \
	--exclude=src \
	--exclude=.stylelintrc.js \
	--exclude=tests \
	--exclude=.travis.yml \
	--exclude=.tx \
	--exclude=.idea \
	--exclude=vendor \
	--exclude=webpack*.js \
	$(project_dir) $(build_dir)

build-js:
	npm run dev

build-js-production:
	npm run build

watch-js:
	npm run watch


##### Testing #####
test: test-cypress

test-api:
	phpunit --bootstrap vendor/autoload.php --testdox tests/api/

test-unit:
	composer test

test-cypress:
	./node_modules/.bin/cypress run

test-behat:
	cd ./tests/integration && ./run.sh && cd ../..

##### Linting #####

lint: lint-php lint-js lint-css lint-xml

lint-php: lint-php-lint lint-php-cs-fixer lint-php-psalm

lint-php-lint:
	# Check PHP syntax errors
	@! find $(php_dirs) -name "*.php" | xargs -I{} php -l '{}' | grep -v "No syntax errors detected"

lint-php-cs-fixer:
	# PHP Coding Standards Fixer (with Nextcloud coding standards)
	vendor/bin/php-cs-fixer fix --dry-run --diff

lint-php-psalm:
	composer psalm

lint-js:
	npm run lint

lint-css:
	npm run stylelint

lint-xml:
	# Check info.xml schema validity
	wget https://apps.nextcloud.com/schema/apps/info.xsd -P appinfo/ -N --no-verbose || [ -f appinfo/info.xsd ]
	xmllint appinfo/info.xml --schema appinfo/info.xsd --noout



##### Fix lint #####

lint-fix: lint-php-fix lint-js-fix lint-css-fix

lint-php-fix:
	vendor/bin/php-cs-fixer fix

lint-js-fix:
	npm run lint:fix

lint-css-fix:
	npm run stylelint:fix



##### Cleaning #####

clean:
	rm -rf js/
	rm -rf $(build_dir)

clean-dev:
	rm -rf node_modules
	rm -rf vendor

clean-dist:
	make clean-dev
	rm -rf ./build
	rm -rf js/vendor
	rm -rf js/node_modules
