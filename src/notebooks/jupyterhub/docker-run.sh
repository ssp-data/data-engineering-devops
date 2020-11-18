docker pull jupyterhub/jupyterhub:latest

# Important: This jupyterhub/jupyterhub image contains only the Hub itself, with no configuration.
# In general, one needs to make a derivative image, with at least a jupyterhub_config.py setting up an Authenticator and/or a Spawner.
# To run the single-user servers, which may be on the same system as the Hub or not, Jupyter Notebook version 4 or greater must be installed.

# The JupyterHub docker image can be started with the following command:
docker run -p 8000:8000 -d --name jupyterhub jupyterhub/jupyterhub jupyterhub

# This command will create a container named jupyterhub that you can stop and resume with
docker stop/start

# The Hub service will be listening on all interfaces at port 8000, which makes this a good choice for testing JupyterHub on your desktop or laptop.

# If you want to run docker on a computer that has a public IP then you should (as in MUST) secure it with ssl by adding ssl options to your docker configuration or by using a ssl enabled proxy.
# Mounting volumes will allow you to store data outside the docker image (host system) so it will be persistent, even when you start a new image.
# The command docker exec -it jupyterhub bash will spawn a root shell in your docker container.
docker exec -it jupyterhub bash

#You can use the root shell to create system users in the container. These accounts will be used for authentication in JupyterHub's default configuration.

#create user:
adduser admin

#create notebook otherwise error thrown: Spawn failed: Server at http://127.0.0.1:38837/user/admin/ didn't respond in 30 seconds
pip install notebook pyspark

export MINIO_ACCESS_KEY=minio
export MINIO_SECRET_KEY=miniostorage
