FROM debian

# We need non-free repositories for SNMP stuff
RUN sed -e 's/$/ non-free/' -i /etc/apt/sources.list

RUN apt-get update && \
    apt-get install -y libsnmp-dev snmp snmpd snmp-mibs-downloader vim tcpdump && \
    apt-get purge -y --auto-remove && rm -rf /var/lib/apt/lists/*

# Updates the SNMP default configurations
RUN sed -e 's#export MIBS=#export MIBS=/usr/share/mibs/#' -i /etc/default/snmpd
RUN sed -e 's/SNMPDOPTS/#SNMPDOPTS/' -i /etc/default/snmpd
RUN echo "SNMPDOPTS='-Lsd -Lf /dev/null -u snmp -I -smux -p /var/run/snmpd.pid -c /etc/snmp/snmpd.conf'" >> /etc/default/snmpd

# Updates the SNMPD configuration
RUN mv /etc/snmp/snmpd.conf /etc/snmp/snmpd.conf.org
RUN echo "rocommunity public" > /etc/snmp/snmpd.conf
RUN echo "agentAddress udp:161,udp6:[::1]:161" >> /etc/snmp/snmpd.conf

# Updates SNMP configuration and downloads new MIBs
RUN sed -e 's/mibs :/#mibs :/' -i /etc/snmp/snmp.conf
RUN download-mibs

COPY ./bootstrap.sh /bootstrap.sh

EXPOSE 161:161/udp
EXPOSE 162:162/udp

ENTRYPOINT ["/bootstrap.sh"]
