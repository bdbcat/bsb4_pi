PLUGIN = org.opencpn.OpenCPN.Plugin.bsb4

all: build

build:
	test -d app || flatpak build-init \
	    app org.freedesktop.Sdk org.freedesktop.Platform 18.08
	flatpak-builder --force-clean app $(PLUGIN).yaml
	flatpak build-export repo app stable

install:
	flatpak install --user --reinstall -y $(CURDIR)/repo $(PLUGIN)

uninstall:
	flatpak uninstall --user $(PLUGIN)
