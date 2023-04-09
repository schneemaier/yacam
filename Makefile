#REVISION_HASH := $(shell git rev-parse --quiet --short HEAD)
BUILDROOT := "/yacam/build/buildroot-2016.02"

build:
	# Command designed to be run outside the container
	cp ./Dockerfile.build ./Dockerfile
	docker build -t yacam/yacam:latest .

lbuild:
        # Command designed to be run outside the container
	cp ./Dockerfile.lbuild ./Dockerfile
        docker build -t yacam/yacam:latest .
	# after build the local development environment can be used
	#  docker compose up
	#  docker exec -it yacam-builder-1 bash



