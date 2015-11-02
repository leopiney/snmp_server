## SNMP Daemon

This docker image is based on polinux/snmpd and tnwinc/snmp docker images. It runs on Debian operating system.

The SNMP daemon runs in foreground so that is always available. The snmp-mib-downloader library is used so that many MIBs are available to query.

Ports 161/udp and 162/udp are exposed by default.
