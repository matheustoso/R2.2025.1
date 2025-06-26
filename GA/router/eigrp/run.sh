#!/bin/sh

# Executa o setup dos containers
docker compose up -d --build

# Executa o setup dos roteadores FRR
docker compose exec r0 ./network-setup.sh
docker compose exec r1 ./network-setup.sh
docker compose exec r2 ./network-setup.sh
docker compose exec r3 ./network-setup.sh
docker compose exec r4 ./network-setup.sh
docker compose exec r5 ./network-setup.sh

# Cria diretórios de logs
mkdir -p ./logs/r0
mkdir -p ./logs/r1
mkdir -p ./logs/r2
mkdir -p ./logs/r3
mkdir -p ./logs/r4
mkdir -p ./logs/r5

# Aguarda a convergência total da rede e registra o tempo
r0=0
r1=0
r2=0
r3=0
r4=0
r5=0
SECONDS=0
while [ "$r0" -lt 5 ] || [ "$r1" -lt 5 ] || [ "$r2" -lt 5 ] || [ "$r3" -lt 5 ] || [ "$r4" -lt 5 ] || [ "$r5" -lt 5 ]; do
    sleep 1
    r0=$(docker compose exec r0 sh -c "vtysh -c 'show ip route' | grep '^E' | wc -l")
    r1=$(docker compose exec r1 sh -c "vtysh -c 'show ip route' | grep '^E' | wc -l")
    r2=$(docker compose exec r2 sh -c "vtysh -c 'show ip route' | grep '^E' | wc -l")
    r3=$(docker compose exec r3 sh -c "vtysh -c 'show ip route' | grep '^E' | wc -l")
    r4=$(docker compose exec r4 sh -c "vtysh -c 'show ip route' | grep '^E' | wc -l")
    r5=$(docker compose exec r5 sh -c "vtysh -c 'show ip route' | grep '^E' | wc -l")
    echo "Tabela de Roteamento r0: $r0/5"
    echo "Tabela de Roteamento r1: $r1/5"
    echo "Tabela de Roteamento r2: $r2/5"
    echo "Tabela de Roteamento r3: $r3/5"
    echo "Tabela de Roteamento r4: $r4/5"
    echo "Tabela de Roteamento r5: $r5/5"
done
echo "Convergência da rede ocorreu em aproximadamente $SECONDS segundos."
echo $SECONDS > logs/convergence-time.txt

# Registra tabelas de roteamento IP
docker compose exec r0 vtysh -c 'show ip route' > logs/r0/ip-route.txt
docker compose exec r1 vtysh -c 'show ip route' > logs/r1/ip-route.txt
docker compose exec r2 vtysh -c 'show ip route' > logs/r2/ip-route.txt
docker compose exec r3 vtysh -c 'show ip route' > logs/r3/ip-route.txt
docker compose exec r4 vtysh -c 'show ip route' > logs/r4/ip-route.txt
docker compose exec r5 vtysh -c 'show ip route' > logs/r5/ip-route.txt
echo "Tabelas de roteamento IP logadas em logs/rN/ip-route.txt"

# Registra topologias eigrp
docker compose exec r0 vtysh -c 'show ip eigrp topology' > logs/r0/topology.txt
docker compose exec r1 vtysh -c 'show ip eigrp topology' > logs/r1/topology.txt
docker compose exec r2 vtysh -c 'show ip eigrp topology' > logs/r2/topology.txt
docker compose exec r3 vtysh -c 'show ip eigrp topology' > logs/r3/topology.txt
docker compose exec r4 vtysh -c 'show ip eigrp topology' > logs/r4/topology.txt
docker compose exec r5 vtysh -c 'show ip eigrp topology' > logs/r5/topology.txt
echo "Topologias EIGRP logadas em logs/rN/topology.txt"

# Registra interfaces eigrp
docker compose exec r0 vtysh -c 'show ip eigrp interface' > logs/r0/interface.txt
docker compose exec r1 vtysh -c 'show ip eigrp interface' > logs/r1/interface.txt
docker compose exec r2 vtysh -c 'show ip eigrp interface' > logs/r2/interface.txt
docker compose exec r3 vtysh -c 'show ip eigrp interface' > logs/r3/interface.txt
docker compose exec r4 vtysh -c 'show ip eigrp interface' > logs/r4/interface.txt
docker compose exec r5 vtysh -c 'show ip eigrp interface' > logs/r5/interface.txt
echo "Interfaces EIGRP logadas em logs/rN/interface.txt"

# Registra vizinhos eigrp
docker compose exec r0 vtysh -c 'show ip eigrp neighbor' > logs/r0/neighbor.txt
docker compose exec r1 vtysh -c 'show ip eigrp neighbor' > logs/r1/neighbor.txt
docker compose exec r2 vtysh -c 'show ip eigrp neighbor' > logs/r2/neighbor.txt
docker compose exec r3 vtysh -c 'show ip eigrp neighbor' > logs/r3/neighbor.txt
docker compose exec r4 vtysh -c 'show ip eigrp neighbor' > logs/r4/neighbor.txt
docker compose exec r5 vtysh -c 'show ip eigrp neighbor' > logs/r5/neighbor.txt
echo "Vizinhos EIGRP logados em logs/rN/neighbor.txt"

# Testes de latência: r0 pinga ambas interfaces do r5
echo "Iniciando testes de latência"
docker compose exec r0 sh -c 'ping -c 50 -s 50 172.21.3.15' > logs/ping50-r0-n3-r5.txt
docker compose exec r0 sh -c 'ping -c 50 -s 500 172.21.3.15' > logs/ping500-r0-n3-r5.txt
docker compose exec r0 sh -c 'ping -c 50 -s 5000 172.21.3.15' > logs/ping5000-r0-n3-r5.txt
docker compose exec r0 sh -c 'ping -c 50 -s 50 172.21.1.15' > logs/ping50-r0-n1-r5.txt
docker compose exec r0 sh -c 'ping -c 50 -s 500 172.21.1.15' > logs/ping500-r0-n1-r5.txt
docker compose exec r0 sh -c 'ping -c 50 -s 5000 172.21.1.15' > logs/ping5000-r0-n1-r5.txt
echo "Testes de latência logados em logs/ping*.txt"

# Testes de quantidade de pacotes de roteamento enviados na rede
echo "Iniciando testes de quantidade de pacotes de roteamento"
docker compose exec r0 sh -c 'timeout 60 tcpdump -i any proto 88' > logs/r0/tcpdump.txt &
docker compose exec r1 sh -c 'timeout 60 tcpdump -i any proto 88' > logs/r1/tcpdump.txt &
docker compose exec r2 sh -c 'timeout 60 tcpdump -i any proto 88' > logs/r2/tcpdump.txt &
docker compose exec r3 sh -c 'timeout 60 tcpdump -i any proto 88' > logs/r3/tcpdump.txt &
docker compose exec r4 sh -c 'timeout 60 tcpdump -i any proto 88' > logs/r4/tcpdump.txt &
docker compose exec r5 sh -c 'timeout 60 tcpdump -i any proto 88' > logs/r5/tcpdump.txt &
wait
echo "Testes de latência logados em logs/rN/tcpdump.txt"

# Finalização
read -p "Terminar containers? [s/n]" -n 1 -r
echo
if [[ $REPLY =~ ^[Ss]$ ]]
then
    bash ./dispose.sh
    exit 1
fi

echo "Execute o script dispose.sh para terminar os containers"