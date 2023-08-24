

# Production build
build:
	DOCKER_BUILDKIT=1 docker compose build cli --no-cache

start:
	docker compose up

stop:
	docker compose down


# Development build
compose-dev=compose -f compose.development.yaml

build-dev:
	DOCKER_BUILDKIT=1 docker ${compose-dev} build --no-cache

start-dev:
	DOCKER_BUILDKIT=1 docker ${compose-dev} up --build --force-recreate

stop-dev:
	docker ${compose-dev} down

ssh-cli-dev:
	docker ${compose-dev} run -it cli sh