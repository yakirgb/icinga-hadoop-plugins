#!/bin/sh

#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 2 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program; if not, write to the Free Software
#   Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

PROGNAME=`basename $0`
VERSION="Version 2.0,"
AUTHOR="2009, Mike Adolphs (http://www.matejunkie.com/)"
AUTHOR="2013, Florian Baumann (http://noqqe.de)"

ST_OK=0
ST_WR=1
ST_CR=2
ST_UK=3


print_version() {
    echo "$VERSION $AUTHOR"
}

print_help() {
    print_version $PROGNAME $VERSION
    echo ""
    echo "$PROGNAME is a Nagios plugin to check the status of HDFS, Hadoop's"
	echo "underlying, redundant, distributed file system."
    echo ""
    echo "$PROGNAME -w 10 -c 5"
    echo ""
    echo "Options:"
	echo "  -w|--warning)"
	echo "     Defines the warning level for used space in percent"
	echo "  -c|--critical)"
	echo "     Defines the critical level for used space in percent"
    exit $ST_UK
}

while test -n "$1"; do
    case "$1" in
        --help|-h)
            print_help
            exit $ST_UK
            ;;
        --version|-v)
            print_version $PROGNAME $VERSION
            exit $ST_UK
            ;;
        --warning|-w)
            warning=$2
            shift
            ;;
        --critical|-c)
            critical=$2
            shift
            ;;
        *)
            echo "Unknown argument: $1"
            print_help
            exit $ST_UK
            ;;
        esac
    shift
done

check_sanity() {
    if [ -n "$warning" -a -n "$critical" ]; then
        if [ ${warning} -gt ${critical} ]; then
            echo "ERR: Confusing warning and critical values" 
        fi

        if [ ${warning} -gt 100 ] && [ ${critical} -gt 100 ]; then
            echo "ERR: Value above 100%? Rly?"
        fi
    else
        echo "ERR: Missing value, see --help"
    fi
}

get_vals() {
    tmp_vals=`hdfs dfsadmin -report 2>/dev/null`
    dfs_used=`echo -e "$tmp_vals" | grep -m1 "DFS Used:" | awk '{printf "%.2f\n", $3/1024/1024/1024/1024}'`
    dfs_used_p=`echo -e "$tmp_vals" | grep -m1 "DFS Used%:" | awk '{print $3}'`
    dfs_total=`echo -e "$tmp_vals" | grep -m1 "Present Capacity:" | awk '{printf "%.2f\n", $3/1024/1024/1024/1024}'`
    perc=`echo $dfs_used_p |awk -F. '{print $1}'`
}

do_output() {
	output="DFS total: ${dfs_total} TB, DFS used: ${dfs_used} TB (${dfs_used_p})"
}

do_perfdata() {
	perfdata="'dfs_total'=${dfs_total} 'dfs_used'=${dfs_used}"
}

# Runtime
check_sanity
get_vals

do_output
do_perfdata

# Nagios plugin data
if [ -n "$warning" -a -n "$critical" ] ; then
    if [ "$perc" -ge "$warning" -a "$perc" -lt "$critical" ] ; then
        echo "WARNING - ${output} | ${perfdata}"
	exit $ST_WR
    elif [ "$perc" -ge "$critical" ]; then
        echo "CRITICAL - ${output} | ${perfdata}"
	exit $ST_CR
    else
        echo "OK - ${output} | ${perfdata} "
	exit $ST_OK
    fi
else
    echo "OK - ${output} | ${perfdata}"
    exit $ST_OK
fi
