bash

#!/bin/bash



# Set the variables for MaxClients, MaxRequestsPerChild, and KeepAliveTimeout

MAX_CLIENTS=${MAX_CLIENTS}

MAX_REQUESTS_PER_CHILD=${MAX_REQUESTS_PER_CHILD}

KEEP_ALIVE_TIMEOUT=${KEEP_ALIVE_TIMEOUT}



# Backup the original Apache configuration file before making any changes

cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.bak



# Update the MaxClients, MaxRequestsPerChild, and KeepAliveTimeout values in the Apache configuration file

sed -i "s/MaxClients [0-9]\+/MaxClients $MAX_CLIENTS/" /etc/httpd/conf/httpd.conf

sed -i "s/MaxRequestsPerChild [0-9]\+/MaxRequestsPerChild $MAX_REQUESTS_PER_CHILD/" /etc/httpd/conf/httpd.conf

sed -i "s/KeepAliveTimeout [0-9]\+/KeepAliveTimeout $KEEP_ALIVE_TIMEOUT/" /etc/httpd/conf/httpd.conf



# Restart the Apache service to apply the changes

systemctl restart httpd.service



# Check the status of the Apache service to verify if it's running without errors

systemctl status httpd.service