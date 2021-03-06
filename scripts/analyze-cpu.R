# simple analysis of sysbench-cpu.sh output data
# which has been converted to csv by extract-cpu.sh

library(ggplot2)

# for combined data sets
cpu_analysis <- function(vm="ra.p8.s") {

  vmregexp<-c(paste0(vm,"$"))

  myDirs <- list.files("./", pattern=vmregexp)
  tables <- lapply(paste(myDirs, "/sysbench.cpu.csv", sep="/"), read.csv, header = TRUE)
  cpuDF <- do.call(rbind,tables)

  myTitle <- paste0("RunAbove IBM Power8 MariaDB\nVM (", vm, ") Test (sysbench-cpu)\nAverage Request Time (ms)")
  p<-ggplot(cpuDF,aes(SMT_Setting, Request_Average,color=factor(Operating_System)))
  p + stat_summary(fun.y=mean,geom="line") + ggtitle(c(myTitle))
}
