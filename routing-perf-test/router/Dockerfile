FROM frrouting/frr@sha256:990e83490108b686fd6df3b1cafa6bdbb2714acb00eedb9a89693946f46f45ce

WORKDIR /

RUN apk update && apk add sudo
RUN sudo apk add nano
RUN sudo apk add sed
RUN sudo apk add shadow
RUN sudo apk add openrc
RUN sudo usermod -a -G frrvty frr
RUN sed -i 's/bgpd=no/bgpd=yes/g' etc/frr/daemons
RUN rc-service frr restart
