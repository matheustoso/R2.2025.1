#!/bin/sh
docker compose up -d --build
wait $!
docker compose exec r0 ./network-setup.sh
docker compose exec r1 ./network-setup.sh
docker compose exec r2 ./network-setup.sh
docker compose exec r3 ./network-setup.sh
docker compose exec r4 ./network-setup.sh
docker compose exec r5 ./network-setup.sh

#Espera convergência da rede, coleta tempo e tabelas de roteamento
mkdir -p ./logs/r0
mkdir -p ./logs/r1
mkdir -p ./logs/r2
mkdir -p ./logs/r3
mkdir -p ./logs/r4
mkdir -p ./logs/r5

r0=0
r1=0
r2=0
r3=0
r4=0
r5=0

SECONDS=0

while [ "$r0" -lt 5 ] || [ "$r1" -lt 5 ] || [ "$r2" -lt 5 ] || [ "$r3" -lt 5 ] || [ "$r4" -lt 5 ] || [ "$r5" -lt 5 ]; do
    sleep 0.5
    r0=$(docker compose exec r0 sh -c "vtysh -c 'show ip route' | grep '^O' | wc -l")
    r1=$(docker compose exec r1 sh -c "vtysh -c 'show ip route' | grep '^O' | wc -l")
    r2=$(docker compose exec r2 sh -c "vtysh -c 'show ip route' | grep '^O' | wc -l")
    r3=$(docker compose exec r3 sh -c "vtysh -c 'show ip route' | grep '^O' | wc -l")
    r4=$(docker compose exec r4 sh -c "vtysh -c 'show ip route' | grep '^O' | wc -l")
    r5=$(docker compose exec r5 sh -c "vtysh -c 'show ip route' | grep '^O' | wc -l")
done

echo $SECONDS > logs/convergence-time.txt

docker compose exec r0 vtysh -c 'show ip route' > logs/r0/ip-route.txt
docker compose exec r1 vtysh -c 'show ip route' > logs/r1/ip-route.txt
docker compose exec r2 vtysh -c 'show ip route' > logs/r2/ip-route.txt
docker compose exec r3 vtysh -c 'show ip route' > logs/r3/ip-route.txt
docker compose exec r4 vtysh -c 'show ip route' > logs/r4/ip-route.txt
docker compose exec r5 vtysh -c 'show ip route' > logs/r5/ip-route.txt

#Coleta topologia ospf
docker compose exec r0 vtysh -c 'show ip ospf route' > logs/r0/route.txt
docker compose exec r1 vtysh -c 'show ip ospf route' > logs/r1/route.txt
docker compose exec r2 vtysh -c 'show ip ospf route' > logs/r2/route.txt
docker compose exec r3 vtysh -c 'show ip ospf route' > logs/r3/route.txt
docker compose exec r4 vtysh -c 'show ip ospf route' > logs/r4/route.txt
docker compose exec r5 vtysh -c 'show ip ospf route' > logs/r5/route.txt

#Coleta interfaces ospf
docker compose exec r0 vtysh -c 'show ip ospf interface' > logs/r0/interface.txt
docker compose exec r1 vtysh -c 'show ip ospf interface' > logs/r1/interface.txt
docker compose exec r2 vtysh -c 'show ip ospf interface' > logs/r2/interface.txt
docker compose exec r3 vtysh -c 'show ip ospf interface' > logs/r3/interface.txt
docker compose exec r4 vtysh -c 'show ip ospf interface' > logs/r4/interface.txt
docker compose exec r5 vtysh -c 'show ip ospf interface' > logs/r5/interface.txt

#Coleta vizinhos ospf
docker compose exec r0 vtysh -c 'show ip ospf neighbor' > logs/r0/neighbor.txt
docker compose exec r1 vtysh -c 'show ip ospf neighbor' > logs/r1/neighbor.txt
docker compose exec r2 vtysh -c 'show ip ospf neighbor' > logs/r2/neighbor.txt
docker compose exec r3 vtysh -c 'show ip ospf neighbor' > logs/r3/neighbor.txt
docker compose exec r4 vtysh -c 'show ip ospf neighbor' > logs/r4/neighbor.txt
docker compose exec r5 vtysh -c 'show ip ospf neighbor' > logs/r5/neighbor.txt