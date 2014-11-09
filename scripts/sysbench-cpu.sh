#! /bin/sh

PrefixLog="/tmp/sysbench.cpu"

sudo /usr/sbin/ppc64_cpu --smt=8
sudo /usr/sbin/ppc64_cpu --frequency > ${PrefixLog}.frequency

for smt in on off
  do
    sudo /usr/sbin/ppc64_cpu --smt=$smt
    echo -n "[smt=$smt] ... "
      for num in 1 2 3 4
        do
	  echo -n "$num "
          /usr/bin/sysbench \
		--test=cpu \
		--cpu-max-prime=20000 \
		run >> ${PrefixLog}.p${smt}.$num
        done
        echo
  done
