FROM quay.io/frrouting/frr@sha256:c26f183a7ac0ece17565bc147d2e7126d6f24a55b178c6a5275b4902b921692b

WORKDIR /
COPY network-setup.sh network-setup.sh
RUN chmod +x ./network-setup.sh

RUN apk update && apk add sudo
RUN sudo apk add nano
RUN sudo apk add tcpdump
RUN sudo apk add sed
RUN sudo apk add shadow
RUN sudo apk add openrc
RUN sudo usermod -a -G frrvty frr
RUN sed -i 's/ospfd=no/ospfd=yes/g' etc/frr/daemons
RUN touch ./etc/frr/vtysh.conf