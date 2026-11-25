# Docker Commands Cheat Sheet

Common Docker and Docker Compose commands used in daily development,
with examples for Laravel projects.

> **Note:** Examples use `app`, `nginx`, `mysql`, and `redis` as service
> names. Replace them with the actual service names from your
> `docker-compose.yml` file.

## 1. Docker basics

  Command               Description
  --------------------- ---------------------------------------------
  `docker --version`    Check the installed Docker version
  `docker info`         Display Docker system information
  `docker ps`           List running containers
  `docker ps -a`        List all containers, including stopped ones
  `docker images`       List local images
  `docker volume ls`    List volumes
  `docker network ls`   List networks
  `docker system df`    Show Docker disk usage

## 2. Docker Compose

Run these commands from the directory containing `docker-compose.yml`
(or `compose.yaml`).

  -----------------------------------------------------------------------
  Command                             Description
  ----------------------------------- -----------------------------------
  `docker compose up -d`              Create and start services in the
                                      background

  `docker compose up -d --build`      Build images, then start services

  `docker compose down`               Stop and remove containers and
                                      Compose networks

  `docker compose stop`               Stop services without removing
                                      containers

  `docker compose start`              Start existing stopped services

  `docker compose restart`            Restart services

  `docker compose ps`                 Show the project's containers

  `docker compose config`             Validate and render the Compose
                                      configuration

  `docker compose pull`               Pull service images

  `docker compose build`              Build or rebuild service images

  `docker compose build --no-cache`   Build images without using the
                                      build cache
  -----------------------------------------------------------------------

## 3. Enter a container and run commands

  ------------------------------------------------------------------------------------------
  Command                                                Description
  ------------------------------------------------------ -----------------------------------
  `docker compose exec app bash`                         Open Bash inside the running `app`
                                                         container

  `docker compose exec app sh`                           Open a shell if Bash is unavailable

  `docker compose exec app php -v`                       Check the PHP version

  `docker compose exec app composer install`             Install PHP dependencies

  `docker compose exec app php artisan --version`        Check the Laravel version

  `docker compose exec app php artisan migrate`          Run database migrations

  `docker compose exec app php artisan optimize:clear`   Clear Laravel's cached optimization
                                                         files

  `docker compose exec app php artisan queue:work`       Start a queue worker manually
  ------------------------------------------------------------------------------------------

Use `docker compose exec` for a command in an already-running service.
Use `docker compose run --rm` when you need a temporary one-off
container.

Example:

``` bash
docker compose run --rm app php artisan migrate
```

## 4. Logs and troubleshooting

  --------------------------------------------------------------------------
  Command                                Description
  -------------------------------------- -----------------------------------
  `docker compose logs`                  Display logs from all services

  `docker compose logs -f`               Follow logs continuously

  `docker compose logs -f app`           Follow application logs

  `docker compose logs --tail=100 app`   Show the last 100 application log
                                         lines

  `docker compose top`                   Show processes running in services

  `docker stats`                         Monitor container resource usage

  `docker inspect CONTAINER_NAME`        Inspect a container

  `docker compose exec app php -m`       List PHP extensions
  --------------------------------------------------------------------------

## 5. Laravel daily commands

Run these from the Laravel application container, or prefix them with
`docker compose exec app`.

``` bash
php artisan migrate
php artisan migrate:status
php artisan db:seed
php artisan optimize:clear
php artisan route:list
php artisan test
composer install
composer update
```

For example, from your host terminal:

``` bash
docker compose exec app php artisan route:list
docker compose exec app php artisan test
```

## 6. MySQL database commands

The examples below assume the database service is named `mysql`.

**Open the MySQL client:**

``` bash
docker compose exec mysql mysql -u root -p
```

**Export a database:**

``` bash
docker compose exec mysql sh -c 'mysqldump -u root -p"$MYSQL_ROOT_PASSWORD" DATABASE_NAME' > backup.sql
```

**Import a database:**

``` bash
docker compose exec -T mysql sh -c 'mysql -u root -p"$MYSQL_ROOT_PASSWORD" DATABASE_NAME' < backup.sql
```

Replace `DATABASE_NAME` with your database name. These examples assume
`MYSQL_ROOT_PASSWORD` is available inside the MySQL container. Avoid
putting real passwords directly into commands or committing them to Git.

## 7. Cleanup and storage

  -----------------------------------------------------------------------
  Command                             Description
  ----------------------------------- -----------------------------------
  `docker container prune`            Remove stopped containers

  `docker image prune`                Remove dangling images

  `docker image prune -a`             Remove images not used by existing
                                      containers

  `docker volume prune`               Remove unused volumes

  `docker network prune`              Remove unused networks

  `docker system prune`               Remove unused containers, networks,
                                      and dangling images

  `docker system prune -a`            Also remove unused images
  -----------------------------------------------------------------------

> **Warning:** `docker compose down -v` removes the Compose project's
> declared named volumes and attached anonymous volumes. If your
> database stores data in one of those volumes, that data can be
> deleted. Do not run it casually or on a shared/production environment.

## 8. Typical daily workflow

``` bash
# Start the project
docker compose up -d

# Check service status
docker compose ps

# Follow logs when troubleshooting
docker compose logs -f

# Run Laravel migrations
docker compose exec app php artisan migrate

# Clear Laravel caches
docker compose exec app php artisan optimize:clear

# Open a shell in the application container
docker compose exec app bash

# Stop and remove the project containers and network
docker compose down
```

## 9. Useful distinctions

-   `docker compose stop` stops containers but keeps them so they can be
    started again.
-   `docker compose down` removes the containers and Compose-created
    networks; named volumes are kept unless `-v` is supplied.
-   `docker compose up -d --build` rebuilds images when needed and
    starts the services.
-   `docker compose exec` runs a command inside an already-running
    service.
-   `docker compose run --rm` creates a one-off container for a command
    and removes it when it exits.
-   `docker compose logs -f SERVICE` follows logs for one service.

## Quick reference: 10 commands to learn first

``` bash
docker compose up -d
docker compose up -d --build
docker compose down
docker compose ps
docker compose logs -f
docker compose exec app bash
docker compose restart
docker compose exec app php artisan migrate
docker compose build --no-cache
docker system df
```

------------------------------------------------------------------------

**Reminder:** Always check the service names in your Compose file before
copying commands. Be especially careful with volume and cleanup commands
because they can remove persistent data.
