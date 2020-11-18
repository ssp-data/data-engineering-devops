<!-- https://medium.com/faun/apache-spark-on-kubernetes-docker-for-mac-2501cc72e659 -->


1. download spark binaries from https://spark.apache.org/downloads.html
2. tar zxvf spark-3.0.1-bin-hadoop3.2.tgz
3. build docker image with `./bin/docker-image-tool.sh -t spark-docker build`
4. Let’s create a custom service account with ClusterRole :
```
kubectl create serviceaccount spark
kubectl create clusterrolebinding spark-role --clusterrole=edit  --serviceaccount=default:spark --namespace=default
```

5. submit spark-job:
```
$SPARK_HOME/bin/spark-submit  \
    --master k8s://https://localhost:6443  \
    --deploy-mode cluster  \
    --conf spark.executor.instances=1  \
    --conf spark.kubernetes.authenticate.driver.serviceAccountName=spark  \
    --conf spark.kubernetes.container.image=spark:spark-docker  \
    --class org.apache.spark.examples.SparkPi  \
    --name spark-pi  \
    local:///Users/sspaeti/Documents/spark/spark-3.0.1-bin-hadoop3.2/examples/jars/spark-examples_2.12-3.0.1.jar
```

## In order to run successfully, add `com.amazonaws_aws-java-sdk-bundle` to your $SPARK_HOME/jars like this:

In my case, it was 1.11.375 version (check on maven repo) - dependency from hadoop-aws.jar:
`cp $HOME/.ivy2/jars/com.amazonaws_aws-java-sdk-bundle-1.11.375.jar $SPARK_HOME/jars`

# run spark-shell job on MinIo
```
$SPARK_HOME/bin/spark-shell \
  --master k8s://https://localhost:6443  \
  --deploy-mode client  \
  --conf spark.executor.instances=1  \
  --conf spark.kubernetes.authenticate.driver.serviceAccountName=spark  \
  --conf spark.kubernetes.container.image=spark:spark-docker  \
  --packages org.apache.hadoop:hadoop-aws:3.2.0,io.delta:delta-core_2.12:0.7.0 \
  --conf spark.delta.logStore.class=org.apache.spark.sql.delta.storage.S3SingleDriverLogStore \
  --conf spark.hadoop.fs.path.style.access=true \
  --conf spark.hadoop.fs.s3a.access.key=$MINIO_ACCESS_KEY \
  --conf spark.hadoop.fs.s3a.secret.key=$MINIO_SECRET_KEY \
  --conf spark.hadoop.fs.s3a.endpoint=$MINIO_ENDPOINT \
  --conf spark.hadoop.fs.s3a.connection.ssl.enabled=false \
  --conf spark.hadoop.fs.impl=org.apache.hadoop.fs.s3a.S3AFileSystem \
  --conf spark.sql.catalog.spark_catalog=org.apache.spark.sql.delta.catalog.DeltaCatalog \
  --conf spark.sql.extensions=io.delta.sql.DeltaSparkSessionExtension \
  --conf spark.driver.port=4040 \
  --name spark-delta
````
!! Remark - Use 192... address, 127.0.0.1:9000 will resolve in HttpHostConnectException.. 127 should only be used in the browser


Save confs in `$SPARK_HOME/conf/spark-defaults.conf` like:
```
spark.master                                            k8s://https://localhost:6443
spark.executor.instances                                1
spark.kubernetes.authenticate.driver.serviceAccountName spark
spark.kubernetes.container.image                        spark:spark-docker
spark.delta.logStore.class                              org.apache.spark.sql.delta.storage.S3SingleDriverLogStore
spark.hadoop.fs.path.style.access                       true
spark.hadoop.fs.s3a.access.key                          minio
spark.hadoop.fs.s3a.secret.key                          miniostorage
spark.hadoop.fs.s3a.endpoint                            192.168.2.128:9000
spark.hadoop.fs.s3a.connection.ssl.enabled              false
spark.hadoop.fs.impl                                    org.apache.hadoop.fs.s3a.S3AFileSystem
spark.driver.port                                       4040
spark.sql.extensions                                    io.delta.sql.DeltaSparkSessionExtension
spark.sql.catalog.spark_catalog                         org.apache.spark.sql.delta.catalog.DeltaCatalog
```
and you can start your spark-submit with only:
```
$SPARK_HOME/bin/spark-shell \
  --deploy-mode client  \
  --packages org.apache.hadoop:hadoop-aws:3.2.0,io.delta:delta-core_2.12:0.7.0 \
  --name spark-delta
```

## read / write delta
```
spark.range(5).write.format("delta").mode("overwrite").save("s3a://test/delta-table123")

val df = spark.read.format("delta").load("s3a://test/delta-table123")
df.show()
```


## Run Docker Image locally
docker ps
docker run --publish 80:88 --detach --name spark spark:spark-docker
