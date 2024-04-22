#!/usr/bin/env bash


usage() {

	cat <<-EOF

	usage: $0 destination-directory

	example script that charts CSV data that has been generated from sar
	Excel XLXS files with charts are produced

	applicable to any CSV data

	
	example: sar-chart.sh data-dir

	This script is using data generated by asp.sh


	EOF

}


while getopts h arg
do
	case $arg in
		h) usage;exit 0;;
		*) usage;exit 1;;
	esac
done

srcDir=csv
destDir=$1

[ -d "$srcDir" -a -r "$srcDir" ] || {
	echo
	echo Cannot access "$srcDir"
	echo
	exit 1
}

mkdir $destDir

[ -d "$destDir" -a -w "$destDir" ] || {
	echo
	echo cannot read and/or write directory destDir: $destDir
	echo
	usage
	echo
	exit 1
}

### Template
#echo working on sar-
#dynachart.pl --spreadsheet-file ${destDir}/ --worksheet-col hostname --category-col 'timestamp' 
################


# if dynachart.pl is in the path then use it.
# if not then check for local directory copy or link
# otherwise error exit

dynaChart=$(which dynachart.pl)

if [[ -z $dynaChart ]]; then
	if [[ -f ./dynachart.pl ]]; then
		dynaChart='./dynachart.pl'
		[ -x "$dynaChart" ] || {
			echo
			echo $dynaChart is not executable	
			echo
			exit 2
		}
	else
		echo
		echo "dynachart.pl not found"
		echo
		exit 1
	fi
fi


# default of 1 chart per metric
#echo working on sar-disk-default.xlsx
#dynachart.pl --spreadsheet-file ${destDir}/sar-disk-default.xlsx --worksheet-col DEV --category-col 'timestamp' --chart-cols 'rd_sec/s' --chart-cols 'wr_sec/s' < sar-disk.csv

# combine metrics into one chart
#echo working on sar-disk-combined.xlsx
#dynachart.pl --spreadsheet-file ${destDir}/sar-disk-combined.xlsx --combined-chart --worksheet-col DEV --category-col 'timestamp' --chart-cols 'rd_sec/s' --chart-cols 'wr_sec/s' < sar-disk.csv

#:<<'COMMENT'

echo working on sar-network-device.xlsx
dynachart.pl --spreadsheet-file ${destDir}/sar-network-device.xlsx --combined-chart --worksheet-col IFACE --category-col 'timestamp' --chart-cols 'rxkB/s' --chart-cols 'txkB/s' < "$srcDir"/sar-net-dev.csv

echo working on sar-network-error-device.xlsx
dynachart.pl --spreadsheet-file ${destDir}/sar-network-error-device.xlsx --combined-chart --worksheet-col IFACE --category-col 'timestamp' --chart-cols 'rxerr/s' --chart-cols 'txerr/s' < "$srcDir"/sar-net-ede.csv

echo working on sar-network-nfs.xlsx
dynachart.pl --spreadsheet-file ${destDir}/sar-network-nfs.xlsx --worksheet-col hostname --category-col 'timestamp' --chart-cols 'call/s' --chart-cols 'retrans/s' --chart-cols 'read/s' --chart-cols 'write/s' --chart-cols 'access/s' --chart-cols 'getatt/s'  < "$srcDir"/sar-net-nfs.csv

echo working on sar-network-nfsd.xlsx
dynachart.pl --spreadsheet-file ${destDir}/sar-network-nfsd.xlsx --worksheet-col hostname --category-col 'timestamp' --chart-cols 'scall/s' --chart-cols 'badcall/s' --chart-cols 'packet/s' --chart-cols 'udp/s' --chart-cols 'tcp/s' --chart-cols 'hit/s' --chart-cols 'miss/s' --chart-cols 'sread/s' --chart-cols 'swrite/s' --chart-cols 'saccess/s' --chart-cols 'sgetatt/s' < "$srcDir"/sar-net-nfsd.csv

echo working on sar-network-socket.xlsx
dynachart.pl --spreadsheet-file ${destDir}/sar-network-socket.xlsx --worksheet-col hostname --category-col 'timestamp' --chart-cols 'totsck' --chart-cols 'tcpsck' --chart-cols 'udpsck' --chart-cols 'rawsck' --chart-cols 'ip-frag' --chart-cols 'tcp-tw' < "$srcDir"/sar-net-sock.csv

echo working on sar-context.xlsx
dynachart.pl --spreadsheet-file ${destDir}/sar-context.xlsx --worksheet-col hostname --category-col 'timestamp' --chart-cols 'proc/s' --chart-cols 'cswch/s' < "$srcDir"/sar-context.csv

echo working on sar-cpu.xlsx
# extracted with -u ALL, so all CPU on one line
dynachart.pl --spreadsheet-file ${destDir}/sar-cpu.xlsx --worksheet-col hostname --category-col 'timestamp' --chart-cols '%usr' --chart-cols '%nice' --chart-cols '%sys' --chart-cols '%iowait' --chart-cols '%steal' --chart-cols '%irq' --chart-cols '%soft' --chart-cols '%guest' --chart-cols '%idle' < "$srcDir"/sar-cpu.csv

echo working on sar-cpu-combined.xlsx
dynachart.pl --spreadsheet-file ${destDir}/sar-cpu-combined.xlsx --combined-chart --worksheet-col hostname --category-col 'timestamp' --chart-cols '%usr' --chart-cols '%nice' --chart-cols '%sys' --chart-cols '%iowait' --chart-cols '%steal' --chart-cols '%irq' --chart-cols '%soft' --chart-cols '%guest' --chart-cols '%idle' < "$srcDir"/sar-cpu.csv


echo working on sar-io-default.xlsx
dynachart.pl --spreadsheet-file ${destDir}/sar-io-default.xlsx --worksheet-col hostname --category-col 'timestamp' --chart-cols 'tps' --chart-cols 'rtps' --chart-cols 'wtps' --chart-cols 'bread/s' --chart-cols 'bwrtn/s' < "$srcDir"/sar-io.csv

echo working on sar-io-tps-combined.xlsx
dynachart.pl --spreadsheet-file ${destDir}/sar-io-tps-combined.xlsx --combined-chart --worksheet-col hostname --category-col 'timestamp' --chart-cols 'tps' --chart-cols 'rtps' --chart-cols 'wtps' < "$srcDir"/sar-io.csv

echo working on sar-io-blks-per-second-combined.xlsx
dynachart.pl --spreadsheet-file ${destDir}/sar-io-blks-per-second-combined.xlsx --combined-chart --worksheet-col hostname --category-col 'timestamp' --chart-cols 'bread/s' --chart-cols 'bwrtn/s' < "$srcDir"/sar-io.csv


echo working on sar-load-runq-threads.xlsx
dynachart.pl --spreadsheet-file ${destDir}/sar-load-runq-threads.xlsx --combined-chart --worksheet-col hostname --category-col 'timestamp' --chart-cols 'runq-sz' --chart-cols 'plist-sz' --chart-cols 'ldavg-1' --chart-cols 'ldavg-5' --chart-cols 'ldavg-15' < "$srcDir"/sar-load.csv

echo working on sar-load-runq.xlsx
dynachart.pl --spreadsheet-file ${destDir}/sar-load-runq.xlsx --combined-chart --worksheet-col hostname --category-col 'timestamp' --chart-cols 'runq-sz' --chart-cols 'ldavg-1' --chart-cols 'ldavg-5' --chart-cols 'ldavg-15' < "$srcDir"/sar-load.csv

echo working on sar-memory.xlsx
dynachart.pl --spreadsheet-file ${destDir}/sar-memory.xlsx --combined-chart --worksheet-col hostname --category-col 'timestamp' --chart-cols 'frmpg/s' --chart-cols  'bufpg/s' < "$srcDir"/sar-mem.csv


echo working on sar-paging-rate.xlsx
dynachart.pl --spreadsheet-file ${destDir}/sar-paging-rate.xlsx --combined-chart --worksheet-col hostname --category-col 'timestamp'  --chart-cols 'pgpgin/s' --chart-cols  'pgpgout/s' < "$srcDir"/sar-paging.csv

echo working on sar-swap-rate.xlsx
dynachart.pl --spreadsheet-file ${destDir}/sar-swap-rate.xlsx --combined-chart --worksheet-col hostname --category-col 'timestamp'  --chart-cols 'pswpin/s' --chart-cols 'pswpout/s' < "$srcDir"/sar-swap-stats.csv


echo working on sar-swap-utilization.xlsx
dynachart.pl --spreadsheet-file ${destDir}/sar-swap-utilization.xlsx --combined-chart --worksheet-col hostname --category-col 'timestamp' --chart-cols 'kbswpfree' --chart-cols 'kbswpused' --chart-cols '%swpused' --chart-cols 'kbswpcad' --chart-cols '%swpcad' < "$srcDir"/sar-swap-utilization.csv

#COMMENT

echo working on sar-kernel-fs.csv
dynachart.pl --spreadsheet-file ${destDir}/sar-kernel-fs.xlsx --worksheet-col hostname --category-col 'timestamp' --chart-cols 'dentunusd' --chart-cols 'file-nr' --chart-cols 'inode-nr' --chart-cols 'pty-nr' < "$srcDir"/sar-kernel-fs.csv


