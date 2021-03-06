# Composer configuration
PHP := $(shell command -v php || which php || echo php)
COMPOSER := $(shell command -v composer.phar || which composer.phar || command -v composer2 || which composer2 || command -v composer || which composer || echo composer)
COMPOSER_VENDOR_DIR := $(shell $(COMPOSER) config vendor-dir || echo vendor)
COMPOSER_AUTOLOAD := $(shell echo "$(COMPOSER_VENDOR_DIR)/autoload.php")

# Install vendor dependencies.
$(COMPOSER_VENDOR_DIR) $(COMPOSER_AUTOLOAD): | composer.lock $(COMPOSER)
	$(COMPOSER) install

# Ensure one can always require 'vendor'
vendor: | $(COMPOSER_AUTOLOAD)

# Local application dependencies.
$(COMPOSER): | $(PHP)

# Update the lock file if the package file has changed.
composer.lock: composer.json | $(COMPOSER)
	$(COMPOSER) update && touch $@

public:: vendor
install:: vendor
