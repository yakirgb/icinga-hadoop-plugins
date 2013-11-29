# Icinga Hadoop Plugins

these tiny pure shell+awk plugins for monitoring your hadoop cluster
are a enhanced and uptodate version of
[exchange.nagios.org check_hadoop-dfs.sh](http://exchange.nagios.org/directory/Plugins/Others/check_hadoop-2Ddfs-2Esh/details)

## check_hadoop_dfs

Monitors the available space in your hdfs. Values in percent

Usage:

     ./check_hadoop-dfs.sh -w 80 -c 90

Example output:

    ./check_hadoop-dfs.sh -w 80 -c 90
    OK - DFS total: 24.13 TB, DFS used: 12.93 TB (57.46%) | 'dfs_total'=24.13 'dfs_used'=12.93


## check_hadoop_datanodes

Monitors the available nodes in your cluster

This plugin requires hadoop superuser permissions. To achieve this I'm
calling the report via sudo (which you have to configure at frist, for sure)

Pre-Install:

    sudo cp genhdfsreport.sh /usr/local/bin/genhdfsreport.sh
    echo 'nagios  ALL=(ALL) NOPASSWD: /usr/local/bin/genhdfsreport.sh' > /etc/sudoers.d/30_nagioshdfs

You can modify this to your own needs/user. 

Usage: 

    ./check_hadoop-datanodes.sh -w 50 -c 44

Example output:

    $ ./check_hadoop-datanodes.sh -w 20 -c 10
    OK - Nodes available: 40, Nodes total: 48, Nodes dead: 8 | 'dn_avail'=40 'dn_total'=48 'dn_dead'=8

    $ ./check_hadoop-datanodes.sh -w 50 -c 44
    CRITICAL - Nodes available: 40, Nodes total: 48, Nodes dead: 8 | 'dn_avail'=40 'dn_total'=48 'dn_dead'=8
