# kubernetes-rabbitmq-cluster
a simple Rabbitmq cluster based on Kubernetes

## quick-start

1. build images
```
#cd images
#sh build-images.sh
```

2. push images to habor
```
#docker tag epic-rabbitmq-server:3.6.10 10.254.9.21/library/epic-rabbitmq-server:3.6.10
#docker push 10.254.9.21/library/epic-rabbitmq-server:3.6.10
```

3. create vip service
```
#kubectl create -f kubernetes/rabbitmq-cluster-vip.yaml
```

4. start rabbitmq node 1
```
#kubectl create -f kubernetes/rabbitmq-cluster-node1.yaml
```

5. wait a few seconds, make sure ```http://10.254.9.21:30130``` can be accessed.

6. start other nodes
```
#kubectl create -f kubernetes/rabbitmq-cluster-node2.yaml
#kubectl create -f kubernetes/rabbitmq-cluster-node3.yaml
```

## Q & A
### 1. how to add more nodes in cluster ?

copy kubernetes/rabbitmq-cluster-node2.yaml and replace "rabbitmq2" to "rabbitmqX" in the file.


