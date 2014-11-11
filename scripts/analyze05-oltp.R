# simple analysis of sysbench05-oltp.sh output data
# which has been converted to csv by extract05-oltp.sh

library(ggplot2)

# for combined data sets
oltp_analysis <- function(vm="ra.p8.s") {

  vmregexp<-c(paste0(vm,"$"))

  myDirs <- list.files("./", pattern=vmregexp)
  tables <- lapply(paste(myDirs, "/sysbench05.oltp.csv", sep="/"), read.csv, header = TRUE)
  oltpDF <- do.call(rbind,tables)

  myTitle <- paste0("RunAbove IBM Power8 MariaDB\nVM (", vm, ") Test (sysbench05-oltp)\nTransactions Per Second")
  p<-ggplot(oltpDF,aes(SMT_Setting,Transactions_Per_Second,color=factor(SysBench_Num_Threads)))
  p + stat_summary(fun.y=mean,geom="line") + facet_grid(. ~ Operating_System) + ggtitle(c(myTitle))
}
