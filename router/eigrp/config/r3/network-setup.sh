#!/bin/sh
vtysh -c 'conf t' -c 'router eigrp 100' -c 'network 172.21.3.13/24' -c 'network 172.21.4.13/24' -c 'end'