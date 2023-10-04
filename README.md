
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# High Memory Usage by Apache
---

This incident type refers to a situation where the Apache server running on a system is consuming an abnormally high amount of memory. This can result in the system becoming unresponsive or slow, leading to degraded performance. It is important to identify the root cause of the high memory usage and take appropriate measures to optimize the server's performance to avoid such incidents in the future.

### Parameters
```shell
export PATH_TO_APACHE_LOG_FILE="PLACEHOLDER"

export MEMORY_USAGE_THRESHOLD_IN_MB="PLACEHOLDER"

export MAX_CLIENTS="PLACEHOLDER"

export KEEP_ALIVE_TIMEOUT="PLACEHOLDER"

export MAX_REQUESTS_PER_CHILD="PLACEHOLDER"
```

## Debug

### Check the memory usage of Apache
```shell
ps -aux | grep apache | awk '{print $4, $11}' | sort -k1 -n
```

### Check the Apache error log
```shell
tail -f /var/log/httpd/error_log
```

### Check the Apache access log
```shell
tail -f /var/log/httpd/access_log
```

### Check the Apache worker status
```shell
apachectl status
```

### Check the Apache configuration
```shell
apachectl configtest
```

### Check the Apache module status
```shell
httpd -M
```

### Check the system memory usage
```shell
free -m
```

### Check the disk usage
```shell
df -h
```

### Check the server load
```shell
uptime
```

### Check the network connections
```shell
netstat -antp | grep apache
```

## Repair

### Identify the root cause of the high memory usage by Apache by analyzing the server logs and monitoring tools.
```shell
bash

#!/bin/bash



# Set variables

LOGFILE="${PATH_TO_APACHE_LOG_FILE}"

THRESHOLD="${MEMORY_USAGE_THRESHOLD_IN_MB}"



# Check memory usage of Apache process

while true; do

    MEMUSAGE=$(ps -C apache2 -o rss= | awk '{ sum+=$1 } END { print sum/1024 }')

    if (( $(echo "$MEMUSAGE > $THRESHOLD" | bc -l) )); then

        # Log high memory usage

        echo "$(date) - Apache memory usage: $MEMUSAGE MB" >> $LOGFILE

        # Analyze logs and monitoring tools to identify root cause

        # ADD YOUR ANALYSIS STEPS HERE

        break

    fi

    sleep 5

done


```

### Optimize the Apache server configuration by adjusting parameters such as MaxClients, MaxRequestsPerChild, and KeepAliveTimeout to reduce memory usage.
```shell
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


```