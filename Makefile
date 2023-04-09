#REVISION_HASH := $(shell git rev-parse --quiet --short HEAD)
BUILDROOT := "/YaCAM/build/buildroot-2016.02"

build:
	# Command designed to be run outside the container
	docker build -t yacam/yacam:latest .
