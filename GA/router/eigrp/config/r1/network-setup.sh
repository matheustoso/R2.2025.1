#!/bin/sh
vtysh -c 'conf t' -c 'router eigrp 1 vrf default' -c 'network 172.21.2.11/24' -c 'network 172.21.4.11/24' -c 'end'