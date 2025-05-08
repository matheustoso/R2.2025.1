#!/bin/sh
docker compose up -d --build

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
    sleep 1
    r0=$(docker compose exec r0 sh -c "vtysh -c 'show ip route' | grep '^O' | wc -l")
    r1=$(docker compose exec r1 sh -c "vtysh -c 'show ip route' | grep '^O' | wc -l")
    r2=$(docker compose exec r2 sh -c "vtysh -c 'show ip route' | grep '^O' | wc -l")
    r3=$(docker compose exec r3 sh -c "vtysh -c 'show ip route' | grep '^O' | wc -l")
    r4=$(docker compose exec r4 sh -c "vtysh -c 'show ip route' | grep '^O' | wc -l")
    r5=$(docker compose exec r5 sh -c "vtysh -c 'show ip route' | grep '^O' | wc -l")
    echo "Tabela de Roteamento r0: $r0/5"
    echo "Tabela de Roteamento r1: $r1/5"
    echo "Tabela de Roteamento r2: $r2/5"
    echo "Tabela de Roteamento r3: $r3/5"
    echo "Tabela de Roteamento r4: $r4/5"
    echo "Tabela de Roteamento r5: $r5/5"
done

echo "Convergência da rede ocorreu em aproximadamente $SECONDS segundos."
echo $SECONDS > logs/convergence-time.txt

docker compose exec r0 vtysh -c 'show ip route' > logs/r0/ip-route.txt
docker compose exec r1 vtysh -c 'show ip route' > logs/r1/ip-route.txt
docker compose exec r2 vtysh -c 'show ip route' > logs/r2/ip-route.txt
docker compose exec r3 vtysh -c 'show ip route' > logs/r3/ip-route.txt
docker compose exec r4 vtysh -c 'show ip route' > logs/r4/ip-route.txt
docker compose exec r5 vtysh -c 'show ip route' > logs/r5/ip-route.txt
echo "Tabelas de roteamento IP logadas em logs/rN/ip-route.txt"

#Coleta topologia ospf
docker compose exec r0 vtysh -c 'show ip ospf route' > logs/r0/route.txt
docker compose exec r1 vtysh -c 'show ip ospf route' > logs/r1/route.txt
docker compose exec r2 vtysh -c 'show ip ospf route' > logs/r2/route.txt
docker compose exec r3 vtysh -c 'show ip ospf route' > logs/r3/route.txt
docker compose exec r4 vtysh -c 'show ip ospf route' > logs/r4/route.txt
docker compose exec r5 vtysh -c 'show ip ospf route' > logs/r5/route.txt
echo "Tabelas de roteamento OSPF logadas em logs/rN/route.txt"

#Coleta interfaces ospf
docker compose exec r0 vtysh -c 'show ip ospf interface' > logs/r0/interface.txt
docker compose exec r1 vtysh -c 'show ip ospf interface' > logs/r1/interface.txt
docker compose exec r2 vtysh -c 'show ip ospf interface' > logs/r2/interface.txt
docker compose exec r3 vtysh -c 'show ip ospf interface' > logs/r3/interface.txt
docker compose exec r4 vtysh -c 'show ip ospf interface' > logs/r4/interface.txt
docker compose exec r5 vtysh -c 'show ip ospf interface' > logs/r5/interface.txt
echo "Interfaces OSPF logadas em logs/rN/interface.txt"

#Coleta vizinhos ospf
docker compose exec r0 vtysh -c 'show ip ospf neighbor' > logs/r0/neighbor.txt
docker compose exec r1 vtysh -c 'show ip ospf neighbor' > logs/r1/neighbor.txt
docker compose exec r2 vtysh -c 'show ip ospf neighbor' > logs/r2/neighbor.txt
docker compose exec r3 vtysh -c 'show ip ospf neighbor' > logs/r3/neighbor.txt
docker compose exec r4 vtysh -c 'show ip ospf neighbor' > logs/r4/neighbor.txt
docker compose exec r5 vtysh -c 'show ip ospf neighbor' > logs/r5/neighbor.txt
echo "Vizinhos OSPF logados em logs/rN/neighbor.txt"

#Finalização
read -p "Terminar containers? [s/n]" -n 1 -r
echo
if [[ $REPLY =~ ^[Ss]$ ]]
then
    bash ./dispose.sh
    exit 1
fi

echo "Execute o script dispose.sh para terminar os containers"