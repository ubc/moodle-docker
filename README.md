# Moodle Docker

This repository provides a ready-to-use Docker setup for running [Moodle](https://moodle.org/), the popular open-source learning management system (LMS). It simplifies deployment with Docker and Docker Compose, making it easy to spin up a development or production Moodle instance quickly.

## Features

- Dockerized Moodle environment
- Preconfigured with Maria database
- Supports persistent data using Docker volumes
- Easy setup and teardown using Docker Compose
- Compatible with Moodle versions 4.x
- Preconfigured with Shibboleth auth

## Requirements

- [Docker](https://www.docker.com/get-started) (20.10+ recommended)
- [Docker Compose](https://docs.docker.com/compose/install/) (1.29+ recommended)

## Getting Started

### 1. Clone the repository
```bash
git clone https://github.com/ubc/moodle-docker.git
cd moodle-docker
```
### 2. Start Moodle
```bash
docker compose up -d
```
This will start:
* Moodle on port 8080
* MariaDB database
* Redis
* Shibd

Check the logs to confirm everything is running:
```bash
docker compose logs -f
```

### 3. Access Moodle
Once the containers are running, open your browser and go to:
```
http://localhost:8080
```
Follow the Moodle web installer to complete the setup.

### Starting and Removing Containers
Stop containers:
```bash
docker compose down
```
Remove volumes (to clear all data):
```bash
docker compose down -v
```

---

## Known Issues

* When using NFS shared volume for `/moodledata`, you may get `session data file is not created by your uid` error. It is due to the NFS mount user id mapping is not consistent with local user id. Use Redis session for workaround.
* By default application cache is using file store, which is pretty slow. Configure Redis to be used for application cache: `Site administration`->`plugins`->`caching`->`Configuration`->under `Redis` row, click add instance