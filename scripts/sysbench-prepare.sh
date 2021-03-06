#! /bin/sh

[ -r ./.mariadbrc ] && source ./.mariadbrc

PrefixLog="/tmp/sysbench.prepare"

for connect in \
	/var/lib/mysql/mysql.sock \
	/var/run/mysql/mysql.sock \
	/var/run/mysqld/mysqld.sock
  do
    if [ -S $connect ] ; then
      socket=$connect
    fi
  done

/usr/bin/sysbench  \
	--test=oltp \
	--num-threads=16 \
	--max-requests=10000 \
	--db-driver=mysql \
	--mysql-db=test \
	--mysql-user=${myUser} \
	--mysql-password=${myPassword} \
	--oltp-table-size=1000000 \
	--mysql-engine-trx=yes \
	--oltp-reconnect-mode=transaction \
	--mysql-table-engine=innodb \
	--max-requests=1000000 \
	--mysql-socket=$socket \
	prepare
