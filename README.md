# Dibimbing - Kampus Merdeka - Final Project Template

## How to
- Since our goal is to minimize our resource usage, we will use free cloud databases on [Neon](https://neon.tech/). Once we create a database in it, get the connection string and put it in variable `DW_POSTGRES_URI` at `.env`
    ```.env
    DW_POSTGRES_URI="postgresql://...?sslmode=require"
    ```
- In order to spin up the containers, first you have to build all the Docker images needed using 
    ```sh
    make build
    ```
- Once all the images have been build up, you can try to spin up the containers using
    ```sh
    make spinup
    ```
- Once all the containers ready, you can try to
    - Access the Airflow on port `8081`
    - Access the Metabase on port `3001`, for the username and password, you can try to access the [.env](/.env) file
    - If you didn't find the created tables in the Metabase `Browse data`, you can try to sync it through Metabase admin UI
---
## Folder Structure

**main**

In the main folder, you can find `makefile`, so if you want to automate any script, you can try to modify it.

There is also `requirements.txt`, so if you want to add a library to the Airflow container, you can try to add it there. Once you add the library name in the file, make sure you rebuild the image before you spin up the container.

**dags**

This is were you put your `dag` files. This folder is already mounted on the container, hence any updates here will automatically take effect on the container side.

**data**

This flder contains the data needed for your project. If you want to generate or add additional data, you can place them here.

**docker**

Here is the place where you can modify or add a new docker stack if you decide to introduce a new data stack in your data platform. You are free to modify the given `docker-compose.yml` and `Dockerfile.airflow`.

**scripts**

This folder contains script needed in order to automate an initializations process on docker-container setup.

---
## Grading Criteria

**Code Quality (20%)**
- Code Readability (5%)
- Code Efficiency (5%)
- Documentation (10%)

**Project Delivery (30%)**
- Standard Template (6%)
- Data Platform Improvisation (12%)
- Data Modelling Improvisation (12%)

**Implementation (40%)**
- Data Extraction (Standard / Improved) (12%)
- Data Pipeline (Standard / Best-Practice) (12%)
- Data Analysis (16%)

**Presentation (10%)**
- Slide Content (4%)
- Slide Design (3%)
- Communication (3%)