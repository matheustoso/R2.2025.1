#!/bin/sh
vtysh -c 'conf t' -c 'router ospf vrf default' -c 'network 172.21.4.12/24 area 0' -c 'end'