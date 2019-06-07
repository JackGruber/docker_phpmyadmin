# phpMyAdmin Docker image based on Alpine
Based on the official Project
https://github.com/phpmyadmin/docker

[Alpine](https://hub.docker.com/_/alpine/) is used as base image, so the image runs on ARM and x64 systems.

## Docker hub tags

You can use following tags on Docker hub:

* `latest` - latest version release for arm and x86/x64
* `amd64` - latest version for x86/x64
* `armhf` - latest version for arm
* `4.9.0.1` - version release for arm and x86/x64
* `4.9.0.1-amd64` - version release for x86/x64
* `4.9.0.1-armhf` - version release for arm

## Usage with linked server

First you need to run MySQL or MariaDB server in Docker, and this image need
link a running mysql instance container:

```
docker run --name myadmin -d --link mysql_db_server:db -p 8080:80 jackgruber/phpmyadmin
```

## Usage with external server

You can specify MySQL host in the `PMA_HOST` environment variable. You can also
use `PMA_PORT` to specify port of the server in case it's not the default one:

```
docker run --name myadmin -d -e PMA_HOST=dbhost -p 8080:80 jackgruber/phpmyadmin
```

## Links
* [jackgruber/phpmyadmin - Docker Hub](https://hub.docker.com/r/jackgruber/phpmyadmin)
* [Alpine - Docker Hub](https://hub.docker.com/_/alpine/)
