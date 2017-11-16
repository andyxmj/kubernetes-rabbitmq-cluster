# kubernetes-rabbitmq-cluster
a simple Rabbitmq cluster based on Kubernetes

## quick-start

1. create vip service
```#kubectl create -f kubernetes/rabbitmq-cluster-vip.yaml```

2. start rabbitmq node 1
```#kubectl create -f kubernetes/rabbitmq-cluster-node1.yaml```

3. wait a few seconds, make sure http://<your-kubernetes-host-ip>:30130 can be accessed.

4. start other nodes
```
#kubectl create -f kubernetes/rabbitmq-cluster-node2.yaml
#kubectl create -f kubernetes/rabbitmq-cluster-node3.yaml
```

## Q & A
### 1. how to add more nodes in cluster ?

copy kubernetes/rabbitmq-cluster-node2.yaml and replace "rabbitmq2" to "rabbitmqX" in the file.



