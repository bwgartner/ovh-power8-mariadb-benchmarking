#! /bin/sh

[ -r ./mariadbrc ] && source ./mariadbrc

PrefixLog="/tmp/sysbench.ovh"

sudo /usr/sbin/ppc64_cpu --smt=8

for smt in on off
  do
    sudo /usr/sbin/ppc64_cpu --smt=$smt
    echo -n "[smt=$smt] threads ... " 
    for connect in \
	/var/lib/mysql/mysql.sock \
	/var/run/mysql/mysql.sock \
	/var/run/mysqld/mysqld.sock
      do
        if [ -S $connect ] ; then
          socket=$connect
        fi
      done
    for threads in 1 2 4 8 16 32 64 128
      do
        echo -n "$threads " 
        /usr/bin/sysbench \
	--test=oltp \
	--oltp-table-size=1000000 \
	--oltp-dist-type=uniform \
	--oltp-table-name=sbtest \
	--max-requests=0  \
	--mysql-user=${myUser} \
	--mysql-password=${myPassword} \
	--mysql-db=test \
	--mysql-table-engine=INNODB \
	--db-driver=mysql \
	--oltp-point-selects=1 \
	--oltp-simple-ranges=0 \
	--oltp-sum-ranges=0 \
	--oltp-order-ranges=0 \
	--oltp-distinct-ranges=0 \
	--oltp-skip-trx=on \
	--oltp-read-only=on \
	--mysql-socket=$socket \
	--max-time=5 \
	--num-threads=$threads \
	run > ${PrefixLog}.p${smt}.t${threads}
      done
      echo
  done
