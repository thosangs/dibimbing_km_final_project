include .env

help:
	@echo "## build			- Build Docker Images (amd64) including its inter-container network."
	@echo "## spinup		- Spinup airflow, postgres, and metabase."

build:
	@echo '__________________________________________________________'
	@echo 'Building Docker Images ...'
	@echo '__________________________________________________________'
	@docker network inspect dataeng-network >/dev/null 2>&1 || docker network create dataeng-network
	@echo '__________________________________________________________'
	@docker build -t dataeng-dibimbing/airflow -f ./docker/Dockerfile.airflow .
	@echo '==========================================================='

spinup:
	@echo '__________________________________________________________'
	@echo 'Creating Instances ...'
	@echo '__________________________________________________________'
	@docker-compose -f ./docker/docker-compose.yml --env-file .env up
	@echo '==========================================================='

clean:
	@bash ./scripts/goodnight.sh