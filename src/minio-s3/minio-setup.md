
#MinIO local Setup

## Start MinIO
minio server /Users/sspaeti/Documents/minio

## Keys:
```
echo $MINIO_ACCESS_KEY
echo $MINIO_SECRET_KEY
```

#run minio
```
minio server $docs/minio -address $MINIO_ENDPOINT #192.168.2.128:9000
```

## more infos:
EXAMPLES:
  1. Start minio server on "/home/shared" directory.
     $ minio server /home/shared

  2. Start single node server with 64 local drives "/mnt/data1" to "/mnt/data64".
     $ minio server /mnt/data{1...64}

  3. Start distributed minio server on an 32 node setup with 32 drives each, run following command on all the nodes
     $ export MINIO_ACCESS_KEY=minio
     $ export MINIO_SECRET_KEY=miniostorage
     $ minio server http://node{1...32}.example.com/mnt/export{1...32}

  4. Start distributed minio server in an expanded setup, run the following command on all the nodes
     $ export MINIO_ACCESS_KEY=minio
     $ export MINIO_SECRET_KEY=miniostorage
     $ minio server http://node{1...16}.example.com/mnt/export{1...32} \
            http://node{17...64}.example.com/mnt/export{1...64}

## Installed with Brew:
https://docs.min.io/docs/minio-quickstart-guide.html