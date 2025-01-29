#!/bin/bash

# Inicializar Config Server Replica Set
winpty docker exec -it cfgsvr1 mongosh --eval "
rs.initiate(
  {
    _id: \"cfgrs\",
    configsvr: true,
    members: [
      { _id : 0, host : \"cfgsvr1:27017\" },
      { _id : 1, host : \"cfgsvr2:27017\" },
      { _id : 2, host : \"cfgsvr3:27017\" }
    ]
  }
)"

# Inicializar Shard 1 Replica Set
winpty docker exec -it shard1svr1 mongosh --eval "
rs.initiate(
  {
    _id: \"shard1rs\",
    members: [
      { _id : 0, host : \"shard1svr1:27017\" },
      { _id : 1, host : \"shard1svr2:27017\" },
      { _id : 2, host : \"shard1svr3:27017\" }
    ]
  }
)"

# Inicializar Shard 2 Replica Set
winpty docker exec -it shard2svr1 mongosh --eval "
rs.initiate(
  {
    _id: \"shard2rs\",
    members: [
      { _id : 0, host : \"shard2svr1:27017\" },
      { _id : 1, host : \"shard2svr2:27017\" },
      { _id : 2, host : \"shard2svr3:27017\" }
    ]
  }
)"

# Inicializar Shard 3 Replica Set
winpty docker exec -it shard3svr1 mongosh --eval "
rs.initiate(
  {
    _id: \"shard3rs\",
    members: [
      { _id : 0, host : \"shard3svr1:27017\" },
      { _id : 1, host : \"shard3svr2:27017\" },
      { _id : 2, host : \"shard3svr3:27017\" }
    ]
  }
)"

# Esperar a que los ReplicaSets se inicialicen
sleep 30

# Agregar shards al cluster
winpty docker exec -it router1 mongosh --eval "
sh.addShard(\"shard1rs/shard1svr1:27017,shard1svr2:27017,shard1svr3:27017\")
sh.addShard(\"shard2rs/shard2svr1:27017,shard2svr2:27017,shard2svr3:27017\")
sh.addShard(\"shard3rs/shard3svr1:27017,shard3svr2:27017,shard3svr3:27017\")
"

echo "Sharded Cluster inicializado y configurado"