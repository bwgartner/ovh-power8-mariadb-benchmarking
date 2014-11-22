#! /bin/sh

[ -r ./.mariadbrc ] && source ./.mariadbrc

PrefixLog="/tmp/sysbench05.oltp"
sudo /usr/sbin/ppc64_cpu --smt=8

for connect in \
	/var/lib/mysql/mysql.sock \
	/var/run/mysql/mysql.sock \
	/var/run/mysqld/mysqld.sock
  do
    if [ -S $connect ] ; then
      socket=$connect
    fi
  done

/usr/local/bin/sysbench \
	--test=/usr/local/share/sysbench/tests/db/oltp.lua \
        --oltp-table-size=1000000 \
	--mysql-db=test \
	--mysql-user=${myUser} \
	--mysql-password=${myPassword} \
	prepare

for smt in on 4 2 1 off
  do
    for threads in 1 2 4 8 16 32 64 128
      do

	sudo /usr/sbin/ppc64_cpu --smt=${smt}

        echo ${PrefixLog}.p${smt}.t${threads}

        /usr/local/bin/sysbench \
		--test=/usr/local/share/sysbench/tests/db/oltp.lua \
	        --oltp-table-size=1000000 \
        	--oltp-dist-type=uniform \
        	--oltp-table-name=sbtest \
		--oltp-test-mode=complex \
		--max-requests=0 \
		--mysql-user=${myUser} \
		--mysql-password=${myPassword} \
		--mysql-db=test \
		--mysql-table-engine=InnoDB \
		--db-driver=mysql \
		--report-interval=15 \
		--mysql-socket=$socket \
		--max-time=300 \
		--num-threads=${threads} \
		run > ${PrefixLog}.p${smt}.t${threads}
          
      done
  done

