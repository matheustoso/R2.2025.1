#!/bin/sh
vtysh -c 'conf t' -c 'router eigrp 1 vrf default' -c 'network 172.21.1.15/24' -c 'network 172.21.3.15/24' -c 'end'