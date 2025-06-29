_repo-clean:
	rm -rf out/_pages/$(BUILD_DIR)
	mkdir -p out/_pages/$(BUILD_DIR)

_repo-copy:
	cp "out/$(FILENAME)" "out/_pages/$(BUILD_DIR)/"

	@if [[ -n "$(FILENAME_APK)" ]]; then \
		cp "out/$(FILENAME_APK)" "out/_pages/$(BUILD_DIR)/"; \
	fi

_repo-html:
	echo '<html><head><title>blocky-keenetic repository</title></head><body>' > out/_pages/$(BUILD_DIR)/index.html
	echo '<h1>Index of /$(BUILD_DIR)/</h1><hr>' >> out/_pages/$(BUILD_DIR)/index.html
	echo '<pre>' >> out/_pages/$(BUILD_DIR)/index.html
	echo '<a href="../">../</a>' >> out/_pages/$(BUILD_DIR)/index.html
	echo '<a href="Packages">Packages</a>' >> out/_pages/$(BUILD_DIR)/index.html
	echo '<a href="Packages.gz">Packages.gz</a>' >> out/_pages/$(BUILD_DIR)/index.html
	echo '<a href="$(FILENAME)">$(FILENAME)</a>' >> out/_pages/$(BUILD_DIR)/index.html
	echo '</pre>' >> out/_pages/$(BUILD_DIR)/index.html
	echo '<hr></body></html>' >> out/_pages/$(BUILD_DIR)/index.html

_repo-index:
	echo '<html><head><title>blocky-keenetic repository</title></head><body>' > out/_pages/index.html
	echo '<h1>Index of /</h1><hr>' >> out/_pages/index.html
	echo '<pre>' >> out/_pages/index.html
	echo '<a href="aarch64/">aarch64/</a>' >> out/_pages/index.html
	echo '</pre>' >> out/_pages/index.html
	echo '<hr></body></html>' >> out/_pages/index.html

_repository:
	make _repo-clean
	make _repo-copy

	echo "Package: blocky-keenetic" > out/_pages/$(BUILD_DIR)/Packages
	echo "Version: $(VERSION)" >> out/_pages/$(BUILD_DIR)/Packages
	echo "Depends: libc" >> out/_pages/$(BUILD_DIR)/Packages
	echo "License: MIT" >> out/_pages/$(BUILD_DIR)/Packages
	echo "Section: net" >> out/_pages/$(BUILD_DIR)/Packages
	echo "Architecture: $(ARCH)" >> out/_pages/$(BUILD_DIR)/Packages
	echo "Filename: $(FILENAME)" >> out/_pages/$(BUILD_DIR)/Packages
	echo "Size: $(shell wc -c out/$(FILENAME) | awk '{print $$1}')" >> out/_pages/$(BUILD_DIR)/Packages
	echo "SHA256sum: $(shell sha256sum out/$(FILENAME) | awk '{print $$1}')" >> out/_pages/$(BUILD_DIR)/Packages
	echo "Description: Fast and lightweight DNS proxy as ad-blocker for local network with many features" >> out/_pages/$(BUILD_DIR)/Packages
	echo "" >> out/_pages/$(BUILD_DIR)/Packages

	gzip -k out/_pages/$(BUILD_DIR)/Packages

	@make _repo-html

repo-aarch64:
	@make \
		BUILD_DIR=aarch64 \
		ARCH=aarch64-3.10 \
		FILENAME=blocky-keenetic_$(VERSION)_aarch64-3.10.ipk \
		_repository

repository: repo-aarch64 _repo-index