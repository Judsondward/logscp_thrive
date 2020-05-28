#!/bin/bash
# Fetches logs from a Thrive Server and SCPs them back to this host
read -p "IP Address (Leave Blank for 10.10.10.99): " ip
read -p "Log Date YYYY-MM-DD (Leave Blank for current date): " date
read -p "Firefly Password: " -s SSHPASS

if [ -z SSHPASS ]
then
	echo No password entered, exiting.
	exit 1
else
	export SSHPASS
fi

if [ -z $ip ]
then
        ip=10.10.10.99
fi

# Locate path and export it to a variable.
#
# Current Valid Paths:
# /var/log/granbury/thrive-server
# /opt/thrive/wildfly-10.1.1.Final/standalone/log/server
# /home/firefly/jboss-as-7.1.1.Final/standalone/log/server

path=$(sshpass -e ssh firefly@$ip -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null 'if [[ -f /var/log/granbury/thrive-server.log ]] ; then echo "/var/log/granbury/thrive-server.log" ; elif [[ -f /opt/thrive/wildfly-10.1.0.Final/standalone/log/server.log ]]; then echo "/opt/thrive/wildfly-10.1.0.Final/standalone/log/server.log" ; elif [[ -f /home/firefly/jboss-as-7.1.1.Final/standlone/log/server.log ]];  then echo "/home/firefly/jboss-as-7.1.1.Final/standlone/log/server.log" ; else echo "" ; fi ;')

if [ -z $path ]
then
	echo "Unable to locate log file, check version."
elif [ -z $date ]
then
	sshpass -e scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null firefly@$ip:$path .
else
	sshpass -e scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null firefly@$ip:$path.$date .
fi
