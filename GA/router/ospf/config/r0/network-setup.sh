#!/bin/sh
vtysh -c 'conf t' -c 'router ospf vrf default' -c 'network 172.21.0.10/24 area 0' -c 'network 172.21.2.10/24 area 0' -c 'end'