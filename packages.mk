_clean:
	rm -rf out/$(BUILD_DIR)
	mkdir -p out/$(BUILD_DIR)/control
	mkdir -p out/$(BUILD_DIR)/data

_download_bins:
	@BLOCKY_VERSION="v0.26.2" && \
	FILENAME=blocky_$${BLOCKY_VERSION}_Linux_arm64.tar.gz && \
	TARGET_URL=https://github.com/0xERR0R/blocky/releases/download/$$BLOCKY_VERSION/$$FILENAME && \
	rm -f out/blocky.tar.gz && \
	rm -rf out/blocky && \
	mkdir -p out/blocky && \
	curl -L -o out/blocky.tar.gz "$$TARGET_URL" && \
	tar -xzf out/blocky.tar.gz -C out/blocky

_conffiles:
	mkdir -p out/$(BUILD_DIR)/control
	cp common/ipk/conffiles out/$(BUILD_DIR)/control/conffiles
	@if [[ "$(BUILD_DIR)" == "openwrt" ]]; then \
		sed -i -E "s#/opt/#/#g" out/$(BUILD_DIR)/control/conffiles; \
	fi

_control:
	echo "Package: blocky-keenetic" > out/$(BUILD_DIR)/control/control
	echo "Version: $(VERSION)" >> out/$(BUILD_DIR)/control/control
	echo "License: MIT" >> out/$(BUILD_DIR)/control/control
	echo "Section: net" >> out/$(BUILD_DIR)/control/control
	echo "URL: https://github.com/lastbyte32/blocky-keenetic" >> out/$(BUILD_DIR)/control/control
	echo "Architecture: $(ARCH)" >> out/$(BUILD_DIR)/control/control
	echo "Description: Fast and lightweight DNS proxy as ad-blocker for local network with many features" >> out/$(BUILD_DIR)/control/control
	echo "" >> out/$(BUILD_DIR)/control/control

_scripts:
	mkdir -p out/$(BUILD_DIR)/control
	cp common/ipk/postinst out/$(BUILD_DIR)/control/postinst
	cp common/ipk/prerm out/$(BUILD_DIR)/control/prerm
	@if [[ "$(BUILD_DIR)" == "openwrt" ]]; then \
		sed -i -E "s#/opt/#/#g" out/$(BUILD_DIR)/control/postinst; \
		sed -i -E "s#/opt/#/#g" out/$(BUILD_DIR)/control/prerm; \
	fi

_binary:
	mkdir -p out/$(BUILD_DIR)/data$(ROOT_DIR)/usr/bin
	@if [ -f out/blocky/blocky ]; then \
		cp out/blocky/blocky out/$(BUILD_DIR)/data$(ROOT_DIR)/usr/bin/blocky; \
		chmod +x out/$(BUILD_DIR)/data$(ROOT_DIR)/usr/bin/blocky; \
	else \
		echo "Error: Binary file not found. Running _download_bins again..."; \
		make _download_bins; \
		cp out/blocky/blocky out/$(BUILD_DIR)/data$(ROOT_DIR)/usr/bin/blocky; \
		chmod +x out/$(BUILD_DIR)/data$(ROOT_DIR)/usr/bin/blocky; \
	fi

_startup:
	mkdir -p out/$(BUILD_DIR)/data$(ROOT_DIR)/etc/init.d
	@if [[ "$(BUILD_DIR)" == "openwrt" ]]; then \
		cp etc/init.d/blocky-keenetic out/$(BUILD_DIR)/data$(ROOT_DIR)/etc/init.d/blocky-keenetic; \
		chmod +x out/$(BUILD_DIR)/data$(ROOT_DIR)/etc/init.d/blocky-keenetic; \
	else \
		cp etc/init.d/S99blocky out/$(BUILD_DIR)/data$(ROOT_DIR)/etc/init.d/S99blocky; \
		chmod +x out/$(BUILD_DIR)/data$(ROOT_DIR)/etc/init.d/S99blocky; \
	fi

_ipk:
	make _clean

	# control.tar.gz
	make _conffiles
	make _control
	make _scripts
	cd out/$(BUILD_DIR)/control; tar czvf ../control.tar.gz .; cd ../../..

	# data.tar.gz
	mkdir -p out/$(BUILD_DIR)/data$(ROOT_DIR)/var/log
	mkdir -p out/$(BUILD_DIR)/data$(ROOT_DIR)/var/run
	mkdir -p out/$(BUILD_DIR)/data$(ROOT_DIR)/etc/blocky

	# Копируем базовый конфиг
	cp etc/blocky/config.yml out/$(BUILD_DIR)/data$(ROOT_DIR)/etc/blocky/config.yml

	make _binary
	make _startup

	cd out/$(BUILD_DIR)/data; tar czvf ../data.tar.gz .; cd ../../..

	# ipk
	echo 2.0 > out/$(BUILD_DIR)/debian-binary
	cd out/$(BUILD_DIR); \
	tar czvf ../$(FILENAME) control.tar.gz data.tar.gz debian-binary; \
	cd ../..

packages:
	@echo "Use 'make all' or 'make aarch64' to build packages"
