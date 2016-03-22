#! /usr/bin/Rscript
###
###
### Jesse Leigh Patsolic 
### 2016 <jesse@cis.jhu.edu>
### S.D.G 
#


### data.csv is the 2nd sheet of the NeuroData R/W spreadsheet.

require(ggplot2)

dat <- read.csv("data.csv")
dat$Threads <- as.factor(dat$Threads)
dat$Size <- as.factor(dat$Size)

ts <- 20
p <-  ggplot(data=dat,aes(x=Size, y = Throughput, group=Threads,color=Threads)) + 
    geom_line(size=1.5) + 
    ylab("Throughput (MB/sec)") + 
    xlab("Size of cutout (MB)") + 
    ggtitle("Read Throughput across multiple threads") + 
    theme(plot.title=element_text(size=ts),
          axis.title.x=element_text(size=ts),
          axis.title.y=element_text(size=ts),
          legend.title=element_text(size=ts),
          legend.text=element_text(size=ts-2),
          axis.text=element_text(size=ts-2))

pdf("ReadThroughputPlot.pdf", height=4,width=10)
print(p)
dev.off()

png("ReadThroughputPlot.png", height=480, width=1000, res=96)
print(p)
dev.off()


dat <- read.csv("data2.csv")
dat$Threads <- as.factor(dat$Threads)
dat$Size <- as.factor(dat$Size)

ts <- 20
p <-  ggplot(data=dat,aes(x=Size, y = Throughput, group=Threads,color=Threads)) + 
    geom_line(size=1.5) + 
    ylab("Throughput (MB/sec)") + 
    xlab("Size of cutout (MB)") + 
    ggtitle("Write Throughput across multiple threads") + 
    theme(plot.title=element_text(size=ts),
          axis.title.x=element_text(size=ts),
          axis.title.y=element_text(size=ts),
          legend.title=element_text(size=ts),
          legend.text=element_text(size=ts-2),
          axis.text=element_text(size=ts-2))

pdf("WriteThroughputPlot.pdf", height=4,width=10)
print(p)
dev.off()

png("WriteThroughputPlot.png", height=480, width=1000, res=96)
print(p)
dev.off()

#   Time: 30 min
##  Working status: Works!
### Comments: I don't like the quality of the png files.
####Soli Deo Gloria
