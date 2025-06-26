#!/bin/sh
vtysh -c 'conf t' -c 'router eigrp 1 vrf default' -c 'network 172.21.0.14/24' -c 'network 172.21.1.14/24' -c 'end'