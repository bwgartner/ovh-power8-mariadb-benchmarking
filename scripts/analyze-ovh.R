# simple analysis of sysbench-ovh.sh output data
# which has been converted to csv by extract-ovh.sh

library(ggplot2)

# for combined data sets
ovh_analysis <- function(vm="ra.p8.s") {

  vmregexp<-c(paste0(vm,"$"))

  myDirs <- list.files("./", pattern=vmregexp)
  tables <- lapply(paste(myDirs, "/sysbench.ovh.csv", sep="/"), read.csv, header = TRUE)
  ovhDF <- do.call(rbind,tables)

  myTitle <- paste0("RunAbove IBM Power8 MariaDB\nVM (", vm, ") Test (sysbench-ovh)\nTransactions Per Second")
  p<-ggplot(ovhDF,aes(SMT_Setting,Transactions_Per_Second,color=factor(SysBench_Num_Threads)))
  p + stat_summary(fun.y=mean,geom="line") + facet_grid(. ~ Operating_System) + ggtitle(c(myTitle))
}
