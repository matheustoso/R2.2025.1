docker compose up -d --build
wait $!
docker compose exec r0 ./network-setup.sh
docker compose exec r1 ./network-setup.sh
docker compose exec r2 ./network-setup.sh
docker compose exec r3 ./network-setup.sh
docker compose exec r4 ./network-setup.sh
docker compose exec r5 ./network-setup.sh