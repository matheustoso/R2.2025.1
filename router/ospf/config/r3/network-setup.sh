#!/bin/sh
vtysh -c 'conf t' -c 'int lo' -c 'ip address 10.10.10.13/32' -c 'end' -c 'conf t' -c 'router ospf' -c 'network 10.10.10.13/32 area 0' -c 'network 172.21.4.13/24 area 0' -c 'end'