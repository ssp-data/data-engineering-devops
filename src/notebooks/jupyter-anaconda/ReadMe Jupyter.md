# 1. Create docker image (only for me)
```
cd $git/open-source-data-engineering/src/notebooks/jupyter-anaconda/docker/
docker build -t sspaeti/jupyter-anaconda:py3.7-spark3-0.0.2 .
docker push
```

# 1. pull docker image
```
docker pull sspaeti/jupyter-anaconda:py3.7-spark3-0.0.2
```

# 2. Create Namespaces and pv / pvs before deploying above
## Namespaces
### create namespace
```
kubectl create namespace jupyter
kubectl get namespaces
```


## PersistentVolumes (pv) and PersistenVolumeClaims (pvc)
### change context to namespace
```
#get context:
kubectl config current-context
#use above context and set namespace:
kubectl config set-context docker-desktop --namespace=jupyter
```
### create perstisten volumes
```
cd $git/open-source-data-engineering/src/notebooks/jupyter-anaconda
kubectl apply -f manifests/base/volume.yaml
```

# 3. jupyter-anaconda-deployment
```
cd $git/open-source-data-engineering/src/notebooks/jupyter-anaconda
kubectl apply -k manifests/overlays/dev/localhost/anaconda/
kubectl delete -k manifests/overlays/dev/localhost/anaconda/
```

## attention to set the correct MINIO credentials in `manifests/base/statefulset.yaml``
* envs MINIO_SECRET_ENDPOINT, MINIO_ACCESS_KEY and MINIO_SECRET_KEY need to be set correctly