#! /bin/sh

OutputFN="sysbench.cpu.csv"

# SLE12-ra.p8.s/sysbench.cpu.poff.3

# from the directory, obtain OS, VMFlavor
mydir=$(basename `pwd`)
OS=$(echo $mydir | cut -f1 -d'-')
VMFlavor=$(echo $mydir | cut -f2 -d'-')

# from the files, obtain the
#	SMT setting, 
#	execution time,
#	min,
#	avg,
#	max

Prefix="sysbench.cpu.p"

echo "Operating_System,VM_Flavor,SMT_Setting,Execution_Time,Request_Minimum,Request_Average,Request_Maximum" > $OutputFN

for mf in ${Prefix}*
  do
    SMT=$(echo $mf | cut -f3 -d'.')
    SMT=${SMT##p}
    [ "$SMT" = "on" ] && SMT=8
    [ "$SMT" = "off" ] && SMT=0
    Sample=$(echo $mf | cut -f5 -d'.')
    Time=$(grep "execution:" $mf 2>/dev/null | awk '{print $NF}')
    Min=$(grep "min:" $mf 2>/dev/null | awk '{print $NF}' )
    Min=${Min%%ms}
    Avg=$(grep "avg:" $mf 2>/dev/null | awk '{print $NF}' )
    Avg=${Avg%%ms}
    Max=$(grep "max:" $mf 2>/dev/null | awk '{print $NF}' )
    Max=${Max%%ms}
    echo "${OS},${VMFlavor},${SMT},${Time},${Min},${Avg},${Max}" >> $OutputFN
  done
