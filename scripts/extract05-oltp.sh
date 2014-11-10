#! /bin/sh

OutputFN="sysbench05.oltp.csv"

# SLE12-ra.p8.s/sysbench05.oltp.poff.t32
# from the directory, obtain OS, VMFlavor
mydir=$(basename `pwd`)
OS=$(echo $mydir | cut -f1 -d'-')
VMFlavor=$(echo $mydir | cut -f2 -d'-')

# from the files, obtain the SMT setting, DBThread and TPS
Prefix="sysbench05.oltp.p*"

echo "Operating_System,VM_Flavor,SMT_Setting,SysBench_Num_Threads,Total_Transactions,Transactions_Per_Second,Request_Minimum,Request_Average,Request_Maximum" > $OutputFN

for mf in ${Prefix}*
  do
    SMT=$(echo $mf | cut -f3 -d'.')
    SMT=${SMT##p}
    [ "$SMT" = "on" ] && SMT=8
    [ "$SMT" = "off" ] && SMT=0
    NThread=$(echo $mf | cut -f4 -d'.' | cut -f1 -d'-')
    NThread=${NThread##t}
    TT=$(grep "transactions:" $mf 2>/dev/null | awk '{print $2}')
    TPS=$(grep "transactions:" $mf 2>/dev/null | awk '{print $3}')
    TPS=${TPS##\(}
    Min=$(grep "min:" $mf 2>/dev/null | awk '{print $NF}' )
    Min=${Min%%ms}
    Avg=$(grep "avg:" $mf 2>/dev/null | awk '{print $NF}' )
    Avg=${Avg%%ms}
    Max=$(grep "max:" $mf 2>/dev/null | awk '{print $NF}' )
    Max=${Max%%ms}
    echo "${OS},${VMFlavor},${SMT},${NThread},${TT},${TPS},${Min},${Avg},${Max}" >> $OutputFN
  done
