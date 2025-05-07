#!/bin/sh
vtysh -c 'conf t' -c 'router eigrp 1 vrf default' -c 'network 172.21.0.10/24' -c 'network 172.21.2.10/24' -c 'end'