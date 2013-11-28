# Icinga Hadoop Plugins

these tiny pure shell+awk plugins for monitoring your hadoop cluster
are a enhanced and uptodate version of
[exchange.nagios.org check_hadoop-dfs.sh](http://exchange.nagios.org/directory/Plugins/Others/check_hadoop-2Ddfs-2Esh/details)

## check_hadoop_dfs

Monitors the available space in your hdfs. Values in percent

Usage:

     ./check_hadoop-dfs.sh -w 80 -c 90

## check_hadoop_datanodes

Monitors the available nodes in your cluster

This plugin requires hadoop superuser permissions. To achieve this I'm
calling the report via sudo (which you have to configure at frist, for sure)

Pre-Install:

    sudo cp genhdfsreport.sh /usr/local/bin/genhdfsreport.sh
    echo 'nagios  ALL=(ALL) NOPASSWD: /usr/local/bin/genhdfsreport.sh' > /etc/suders.d/30_nagioshdfs

You can modify this to your own needs/user. 

Usage: 

    ./check_hadoop-datanodes.sh -w 50 -c 44

