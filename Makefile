.PHONY: build run dev test db push scan-image rmi deploy-ecs

##
# Makefile used to build, test and (locally) run the bandiera project.
##

##
# ENVRONMENT VARIABLES
#   We use a number of environment  variables to customer the Docker image createad at build time. These are set and
#   detailed below.
##

# App name used to created our Docker image. This name is important in the context of the AWS docker repository.
APP_NAME = bandiera

# AWS account ID used to create our Docker image. This value is important in the context of the AWS docker repository.
# When executed in GoCD, AWS_ACCOUNT_ID may be set by an environment variable
AWS_ACCOUNT_ID ?= $(or $(shell aws sts get-caller-identity --output text --query "Account" 2 > /dev/null), unknown)

# A counter that represents the build number within GoCD. Used to tag and version our images.
GO_PIPELINE_COUNTER ?= unknown

# Which Rack environment will our docker image be configured to run in?
RACK_ENV ?= production

# VERSION is used to tag the Docker images
VERSION = 0.2.$(GO_PIPELINE_COUNTER)

# ECS related variables used to build our image name
ECS_CLUSTER = ecs
AWS_REGION = eu-west-1

# Tenable.io
TENABLEIO_USER ?= user # passed from an envvar in the CDP
TENABLEIO_PASSWORD ?= password # passed from an envvar in the CDP
TENABLEIO_REGISTRY = cloud.flawcheck.com
TENABLEIO_REPO = web1live

# The name of our Docker image
IMAGE = $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/$(APP_NAME)

# Container port used for mapping when running our Docker image.
CONTAINER_PORT = 5000

# Host port used for mapping when running our Docker image.
HOST_PORT = 80

# Bandiera database password
DB_PASSWORD = $(shell credstash get bandiera/db-password)

DATABASE_URL = postgres://$(DB_USERNAME):$(DB_PASSWORD)@$(DB_SERVER):5432/$(DB_DATABASE)

##
# MAKE TASKS
#   Tasks used locally and within our build pipelines to build, test and run our Docker image.
##

build: # Using the variables defined above, run `docker build`, tagging the image and passing in the required arguments.
	docker build -t $(IMAGE):$(VERSION) -t $(IMAGE):latest \
		--build-arg DATABASE_URL=$(DATABASE_URL) \
		--build-arg LOG_TO_STDOUT=$(LOG_TO_STDOUT) \
		--build-arg RACK_ENV=$(RACK_ENV) \
		--build-arg GIT_SHA="$(GO_REVISION)" \
		--build-arg GIT_TAG="$(shell git describe --tags --exact-match 2> /dev/null)" \
		.

run: # Run the Docker image we have created, mapping the HOST_PORT and CONTAINER_PORT
	docker run --rm -p $(HOST_PORT):$(CONTAINER_PORT) $(IMAGE)

db: # Setup the DB
	docker run --rm $(IMAGE):latest bundle exec rake db:migrate

test: # Build the docker image in development mode, using a test PARLIAMENT_BASE_URL. Then run rake within a Docker container using our image.
	RACK_ENV=development DATABASE_URL='postgres://bandiera:bandiera@db/bandiera' make build
	docker run --rm $(IMAGE):latest bundle exec rake

dev: # Build, bundle and run a development version of our application
	make dev-build
	make dev-bundle
	make dev-run

dev-build: # Run make build, but with the application set to run in the development environment
	RACK_ENV=development make build

dev-bundle: # Run a bundle install on our image (designed to work with dev-build and dev-run)
	docker run -p $(HOST_PORT):$(CONTAINER_PORT) -v ${PWD}:/app $(IMAGE) bundle install --path vendor/bundle

dev-run: # Build the Dcoker image in development mode then run the Docker image we have created. Mapping the HOST_PORT and CONTAINER_PORT, we also add a volume so that code changes we make on the host machine are reflected in the container.
	docker run -p $(HOST_PORT):$(CONTAINER_PORT) -v ${PWD}:/app $(IMAGE) bundle exec rails s Puma

push: # Push the Docker images we have build to the configured Docker repository (Run in GoCD to push the image to AWS)
	docker push $(IMAGE):$(VERSION)
	docker push $(IMAGE):latest

scan-image:
	docker login -u $(TENABLEIO_USER) -p $(TENABLEIO_PASSWORD) $(TENABLEIO_REGISTRY)
	docker tag $(IMAGE):$(VERSION) $(TENABLEIO_REGISTRY)/$(TENABLEIO_REPO)/$(APP_NAME):$(VERSION)
	docker push $(TENABLEIO_REGISTRY)/$(TENABLEIO_REPO)/$(APP_NAME):$(VERSION)

rmi: # Remove local versions of our images.
	docker rmi -f $(IMAGE):$(VERSION)
	docker rmi -f $(IMAGE):latest
	docker rmi -f $(docker images | grep "^<none>" | awk '{print $3}') || true

deploy-ecs: # Deploy our new Docker image onto an AWS cluster (Run in GoCD to deploy to various environments).
	./aws_ecs/register-task-definition.sh $(APP_NAME)
	aws ecs update-service --service $(APP_NAME) --cluster $(ECS_CLUSTER) --region $(AWS_REGION) --task-definition $(APP_NAME)
