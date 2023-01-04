# Docker for Symfony
**ONLY for DEV, not for production**

Installing :
+ PHP 8.1.13 CLI
+ Composer (last version)
+ Symfony (last version)
+ Some other php extentions
+ nodejs, npm, yarn
+ MariaDB 10.10.2
+ PHPMyAdmin 5.0.4

## Run Locally

Clone the project

Go in the directory created

```shell
cd formation-sf6
```

Run the docker compose

```shell
docker compose -p guestbook up -d
```

Log into the PHP container

```shell
docker exec -it guestbook bash
```

Check the Symfony installation

```bash
symfony check:requirements
symfony server:ca:install
```

*MariaDB is available at port 3307*

*PHPMyAdmin is available at http://127.0.0.1:8080*

*Your application will be available at http://127.0.0.1:8000*

## Thanks to
- [@yoanbernabeu](https://github.com/yoanbernabeu) for the inspiration
