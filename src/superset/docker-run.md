

<!-- `docker pull preset/superset:latest` -->

# build docker image
Because we need to add pydruid for connection to druid.
```
cd $git/open-source-data-engineering/src/superset/
docker build -t superset/druid .
```

# How to use this image
#Start a superset instance on port 8080
docker run -d -p 8080:8080 --name superset superset/druid
# Initialize a local Superset Instance
With your local superset container already running...
Setup your local admin account
```
docker exec -it superset superset fab create-admin \
               --username admin \
               --firstname Superset \
               --lastname Admin \
               --email simu@sspaeti.com \
               --password admin
```
# Migrate local DB to latest
`docker exec -it superset superset db upgrade`

# Load Examples
`#docker exec -it superset superset load_examples`

# Setup roles
`docker exec -it superset superset init`

# Login and take a look -- navigate to
open http://localhost:8080/login/ -- u/p: [admin/admin]



# catch logs from `stdout`
docker logs superset

# add druid as datasource:
SQLAlchemy URI: `druid://10.107.128.249:8888/druid/v2/sql  #check IP in Kubernetes/Services`  TODO: make this with DNS

<!-- druid://localhost:30088/druid/v2/sql -->


<br><br>

# Docker Image
## How to extend this image
This docker image contains only the base Superset build, excluding database drivers that you will need to connect to your analytics DB (MySQL, Postgres, BigQuery, Snowflake, Redshift, etc.) This is deliberate as many of these drivers do not have Apache-compatible license, and we do not want to bloat the image with packages you do not need in your environment.

We do recommend that you write a simple docker file based on this image. Here's what it may look like:

<!--
FROM preset/superset
# Switching to root to install the required packages
USER root
# Example: installing the MySQL driver to connect to the metadata database
# if you prefer Postgres, you may want to use `psycopg2-binary` instead
RUN pip install mysqlclient
# Example: installing a driver to connect to Redshift
# Find which driver you need based on the analytics database
# you want to connect to here:
# https://superset.incubator.apache.org/installation.html#database-dependencies
RUN pip install sqlalchemy-redshift
# Switching back to using the `superset` user
USER superset
Find the recommended Python libraries for popular databases here: https://superset.incubator.apache.org/installation.html#database-dependencies
-->
