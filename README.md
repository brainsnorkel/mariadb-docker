# MariaDB Dockerfile on Alpine

This Dockerfile is intended to be used as both a standalone and an Openshift S2I build/run.

It is a manual fork of the [Russ McKendrick](https://github.com/russmckendrick/docker/tree/master/mariadb) 
repository, changed to be a "pure" Dockerfile-in-the-root-directory repository.

Changes from the original include:
 1. Use of the Openshift fix-permissions.sh utility from the [CentOS 7 repo](https://github.com/CentOS/CentOS-Dockerfiles/tree/master/mariadb/centos7)
 2. Removal of chown mysql:mysql etc. to let Openshift run it as its chosen user
 3. Modication of the startup script to explicitly use the defaul root MariaDB user to start things off

MariaDB
=============

A Docker build which runs just [MariaDB](https://mariadb.org/).

You can set the root MySQL password by passing the `MYSQL_ROOT_PASSWORD` as an environment variable (if nothing is passed then the password will be random, so you will need to it from the logs). You can also create a database by setting and passing the following ...

- `MYSQL_DATABASE` = Name of the database to create
- `MYSQL_USER` = Username for the database you defined in `MYSQL_DATABASE`
- `MYSQL_PASSWORD` = Password for the user created in `MYSQL_USER`

You can lauch a continer by using one of the following ...

- `docker run -d -p 3306:3306 russmckendrick/mariadb`
- `docker run -d -p 3306:3306 -e MYSQL_ROOT_PASSWORD=y0Urp455w0rd russmckendrick/mariadb`
- `docker run -d -p 3306:3306 -e MYSQL_ROOT_PASSWORD=y0Urp455w0rd -e MYSQL_DATABASE=wibble -e MYSQL_USER=rah -e MYSQL_PASSWORD=y0UrDbP455w0rD russmckendrick/mariadb`
- `docker run -d -p 3306:3306 -e MYSQL_DATABASE=wibble russmckendrick/mariadb`
- `docker run -d -p 3306:3306 --name="database" -e MYSQL_DATABASE=wibble -v /home/containers/database:/var/lib/mysql russmckendrick/mariadb`

If you didn't set `MYSQL_ROOT_PASSWORD` then you can run `docker logs` to see what password has been set;

``` bash
[root@docker ~]# docker run -d -p 3306:3306 russmckendrick/mariadb
26b504347376828eae8accda2715125a71e717c8462a8dbeba93189cb3bafdfa
[root@docker mariadb]# docker ps
CONTAINER ID        IMAGE                                COMMAND              CREATED             STATUS              PORTS                    NAMES
26b504347376        russmckendrick/mariadb:latest        /usr/local/bin/run   4 seconds ago       Up 3 seconds        0.0.0.0:3306->3306/tcp   mydbserver     
[root@docker ~]# docker logs 26b504347376
=> An empty or uninitialized MariaDB volume is detected in /var/lib/mysql
=> Installing MariaDB ...
=> Done!
=> Creating MariaDB root user with a random password
=> Done!
========================================================================
You can now connect to this MariaDB Server using:

    mysql -uroot -pc735bacb -h<host> -P<port> --protocol=TCP
========================================================================
[root@docker ~]# mysql -uroot -pc735bacb --protocol=TCP
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 9
Server version: 10.1.9-MariaDB-log MariaDB Server

Copyright (c) 2000, 2015, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| test               |
+--------------------+
4 rows in set (0.01 sec)

MariaDB [(none)]> exit
Bye
```