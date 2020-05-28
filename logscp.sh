#!/bin/bash
if [ -z $1 ]
then
        i=10.10.10.99
else
        i=$1
fi

j=$(ssh firefly@$i -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null 'if [[ -f /var/log/granbury/thrive-server.log ]] ; then echo "/var/log/granbury/thrive-server.log" ; elif [[ -f /opt/thrive/wildfly-10.1.0.Final/standalone/log/server.log ]]; then echo "/opt/thrive/wildfly-10.1.0.Final/standalone/log/server.log" ; elif [[ -f /home/firefly/jboss-as-7.1.1.Final/standlong/log/server.log ]];  then echo "/home/firefly/jboss-as-7.1.1.Final/standlong/log/server.log" ; else echo "" ; fi ;')

if [ -z $j ]
then
	echo "Error Finding Log File, check version"
else
	scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null firefly@$i:$j .
fi
