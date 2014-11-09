#! /bin/sh

OutputFN="sysbench.ovh.csv"

# SLE12-ra.p8.2xl/sysbench.ovh.poff.t32
# from the directory, obtain OS, VMFlavor
mydir=$(basename `pwd`)
OS=$(echo $mydir | cut -f1 -d'-')
VMFlavor=$(echo $mydir | cut -f2 -d'-')

#echo "OS : $OS"
#echo "VMFlavor : $VMFlavor"

# from the file name, obtain the SMT setting, NThread
Prefix="sysbench.ovh.p"

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
    #ART=$(grep avg: $mf 2>/dev/null | awk '{print $2}' | cut -f1 -d'm')
    #echo "${OS},${VMFlavor},${SMT},${DBThread},${TPS},${ART}" >> $OutputFN
    Min=$(grep "min:" $mf 2>/dev/null | awk '{print $NF}' )
    Min=${Min%%ms}
    Avg=$(grep "avg:" $mf 2>/dev/null | awk '{print $NF}' )
    Avg=${Avg%%ms}
    Max=$(grep "max:" $mf 2>/dev/null | awk '{print $NF}' )
    Max=${Max%%ms}
    echo "${OS},${VMFlavor},${SMT},${NThread},${TT},${TPS},${Min},${Avg},${Max}" >> $OutputFN
  done
