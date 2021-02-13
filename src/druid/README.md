# druid-deployment
Local Deployment of Druid with Kubernetes and Kustomize



# 1. Create Namespaces and pv / pvs before deploying above
## Namespaces
### create namespace
```
kubectl create namespace druid
kubectl get namespaces
```


## PersistentVolumes (pv) and PersistenVolumeClaims (pvc)
### change context to namespace
```
#get context:
kubectl config current-context
#use above context and set namespace to druid:
kubectl config set-context docker-desktop --namespace=druid
```
### create perstisten volumes
```
cd $git/data-engineering-devops/src/druid
kubectl apply -f  manifests/base/persistentVolume/volumes.yaml
```
## deletion
`kubectl delete -f  manifests/base/persistentVolume/volumes.yaml`

#### if deletin are hanging in termination use:
```
kubectl get pv
kubectl get pv --namespace=druid
kubectl edit pv <name-of-pv> #and then deltete the finalizer line and the corespondine line
#afterwards the pv will be gone!
```
<br>

# 2. druid-deployment
```
cd $git/data-engineering-devops/src/druid
kubectl apply -k manifests/overlays/dev/localhost/sspaeti
kubectl delete -k manifests/overlays/dev/localhost/sspaeti
```
## Port-forwarding on druid-router:
This is only needed when nodePort is not set in services.
```
kubectl get pod
kubectl port-forward druid-router-86798c8b4c-vjvxj 8888:8888
```
<br>

# 3. Resource settings
Resources are very low for a productive druid server. BUT, this very low settings are working and optimized for my local Macbook Pro.
Macbook specs:
* MacBook Pro (13-inch, 2020, Four Thunderbolt 3 ports)
* 2.3 GHz Quad-Core Intel Core i7
* 32 GB 3733 MHz LPDDR4X

Docker specs I've given:
* 6 CPUs
* 20 GB Memory
* 1 GB Swap