#! /usr/bin/Rscript
###
### Image creation script for fig:store1 (a-d)
###
### Jesse Leigh Patsolic 
### 2016 <jesse@cis.jhu.edu>
### S.D.G 
#


#### Loading packages
require(ggplot2)
require(gridExtra)
require(grid)
require(reshape)
require(foreach)


#### Set up letters for labels
plotLabels <- letters[1:4]

#### JLP messed with the colors
#cbPalette <- c("#000000", "#56B4E9", "#E69F00","#0072D8", "#FFF000","#470778", "#CC79A7")
#### GK messed with colors
cbPalette <- c("#000000", "#56B4E9", "#E69F00","#0072D0", "#FFF000","#470778", "#CC79A7", "#00B800", "#006940","#005f5b", "#006352")
#### Theme options for ggplot
ts <- 32
tt <- theme(plot.title=element_text(size=ts),
          axis.title.x=element_text(size=ts - 2),
          axis.title.y=element_text(size=ts - 2),
          legend.title=element_text(size=ts),
          legend.text=element_text(size=ts-2),
          strip.text=element_text(size=ts),
          #plot.margin=unit(c(2,3,2,2),'lines'),
          axis.text=element_text(size=ts-4))

### Setting up url's for data read/write data
baseread<-"../../store/data/read/"
    #"https://raw.githubusercontent.com/neurodata/ndpaper2016/gh-pages/Results/CSV/ndstore/read/"

basewrite<-"../../store/data/write/"
    #"https://raw.githubusercontent.com/neurodata/ndpaper2016/gh-pages/Results/CSV/ndstore/read/"

Threads <- c(1,2,4,8,16,32)
#size <- c(0.5,2^c(0:11))

#### File names
readFiles <- paste0(baseread,"read_",Threads,"_threads.csv")
writeFiles <- paste0(basewrite,"write_",Threads,"_threads.csv")

datRead <- foreach(i = 1:length(Threads),.combine='rbind') %do% {
  tmp <- read.csv(readFiles[i],header=FALSE)  
  colnames(tmp) <- c("Size",paste0("test",1:(ncol(tmp)-1),"_",Threads[i]))

  size <- tmp$Size 
  st <- stack(tmp[,-1])
  st$values <- (Threads[i]*size/1024)/st$values # Converted to GB
  th<-data.frame(size=size,threads=Threads[i],st)
}


datRead$threads <- as.factor(datRead$threads)
datRead$size <- as.factor(datRead$size)
datRead$ind <- as.factor(datRead$ind)
datRead$type <- "Read"

datWrite <- foreach(i = 1:length(Threads),.combine='rbind') %do% {
  tmp <- read.csv(writeFiles[i],header=FALSE)  
  colnames(tmp) <- c("Size", paste0("test",1:(ncol(tmp)-1),"_",Threads[i]))
  
  size <- tmp$Size
  st <- stack(tmp[,-1])
  st$values <- (Threads[i]*size/1024)/st$values # Converted to GB
  th<-data.frame(size=size,threads=Threads[i],st)
}

datWrite$threads <- as.factor(datWrite$threads)
datWrite$size <- as.factor(datWrite$size)
datWrite$ind <- as.factor(datWrite$ind)
datWrite$type <- "Write"

datIO <- rbind(datRead, datWrite)

labR <- as.character(unique(datRead$size))
labR[seq(1,length(labR),by=2)] <- ""

labW <- as.character(unique(datWrite$size))
labW[seq(1,length(labW),by=2)] <- ""

#### Read throughput figure
p1r <- ggplot(data=datRead,aes(x=size,y=values,group=ind,color=threads)) + 
    geom_line(size=1) + 
    geom_point(color='black', size=0.75) + 
    scale_colour_manual(values=cbPalette) + 
    scale_x_discrete(labels=labR) + 
    ylab("Throughput (GB/s)") + 
    xlab("Size (MB/thread)") + 
    ggtitle("Image Volume Reading") + 
    tt +
    guides(color=guide_legend(
            keywidth=1.5,keyheight=1.25)) + 
    theme(legend.justification=c(1,0), 
          legend.position=c(0.345,0.5))

#pdf("../figs/store_a.pdf", height=6,width=8)
#print(p1r)
#dev.off()
#
#png("../figs/store_a.png", height=620, width=1200, res=120)
#print(p1r)
#dev.off()


#### Read throughput figure
p1w <- ggplot(data=datWrite,aes(x=size,y=values,group=ind,color=threads)) + 
    geom_line(size=1) + 
    geom_point(color='black', size=0.75) + 
    scale_colour_manual(values=cbPalette) + 
    ylab("Throughput (GB/s)") + 
    xlab("Size (MB/thread)") + 
    scale_x_discrete(labels=labW) + 
    ggtitle("Image Volume Writing") + 
    tt +
    theme(legend.position='none')
   # theme(axis.ticks.x=element_blank(),
   #       axis.text.x=element_blank(),
   #       axis.title.x=element_blank()) +
   #     annotation_custom(
   #         grob=textGrob(plotLabels[1],gp=gpar(cex=2)),
   #         ymin=10.5, ymax=10.5,
   #         xmin=0.65, xmax=0.65
   #         )

#pdf("../figs/store_b.pdf", height=4.5,width=10)
#print(p1w)
#dev.off()
#
#png("../figs/store_b.png", height=620, width=1200, res=120)
#print(p1w)
#dev.off()

#p1 <- ggplot(data=datIO,aes(x=size,y=values,group=ind,color=threads)) + 
#    geom_line(size=0.8) + 
#    geom_point(color='black', size=0.75) + 
#    scale_colour_manual(values=cbPalette) + 
#    ylab("GB/second") + 
#    #xlab("MB/thread") + 
#    ggtitle("Input/Output") + 
#    facet_grid( ~ type, scales='free_y') + 
#    tt +
#   # theme(axis.ticks.x=element_blank(),
#   #       axis.text.x=element_blank(),
#   #       axis.title.x=element_blank()) +
#    theme(legend.justification=c(1,0), 
#          legend.position=c(0.95,0.5),
#          axis.text=element_text(size=ts-8)) 
#   #     annotation_custom(
#   #         grob=textGrob(plotLabels[1],gp=gpar(cex=2)),
#   #         ymin=10.5, ymax=10.5,
#   #         xmin=0.65, xmax=0.65
#   #         )
#
#pdf("../figs/store_a.pdf", height=4.5,width=10)
#print(p1)
#dev.off()
#
#png("../figs/store_a.png", height=620, width=1200, res=120)
#print(p1)
#dev.off()


datReadSE <- foreach(i = 1:length(Threads),.combine='rbind') %do% {
  tmp <- read.csv(readFiles[i],header=FALSE)  
  colnames(tmp) <- c("Size",paste0("test",1:(ncol(tmp)-1),"_",Threads[i]))

  size <- tmp$Size
  tmp[,-1]<-(Threads[i]*size/1024)/tmp[,-1] # Converted to GB
  avg <- apply(tmp[,-1],1,mean)
  sel <- avg-apply(tmp[,-1],1,function(x){sd(x)/sqrt(dim(tmp[,-1])[2])})
  seu <- avg +apply(tmp[,-1],1,function(x){sd(x)/sqrt(dim(tmp[,-1])[2])}) 

  data.frame(Size=size,
             Threads=Threads[i],
             avg=avg,
             sel=sel,
             seu=seu
             )
}


datReadSE$Threads <- as.factor(datReadSE$Threads)
datReadSE$Size <- as.factor(datReadSE$Size)
datReadSE$type <- "Read"


datWriteSE <- foreach(i = 1:length(Threads),.combine='rbind') %do% {
  tmp <- read.csv(writeFiles[i],header=FALSE)  
  colnames(tmp) <- c("Size",paste0("test",1:(ncol(tmp)-1),"_",Threads[i]))

  size <- tmp$Size
  tmp[,-1]<-(Threads[i]*size/1024)/tmp[,-1] # Converted to GB
  avg <- apply(tmp[,-1],1,mean)
  sel <- avg-apply(tmp[,-1],1,function(x){sd(x)/sqrt(dim(tmp[,-1])[2])})
  seu <- avg +apply(tmp[,-1],1,function(x){sd(x)/sqrt(dim(tmp[,-1])[2])}) 

  data.frame(Size=size,
             Threads=Threads[i],
             avg=avg,
             sel=sel,
             seu=seu
             )
}


datWriteSE$Threads <- as.factor(datWriteSE$Threads)
datWriteSE$Size <- as.factor(datWriteSE$Size)
datWriteSE$type <- "Write"


p1rse <- ggplot(data=datReadSE,aes(x=Size,y=avg,group=Threads,color=Threads)) + 
    geom_line(size=1) + 
    geom_errorbar(aes(ymin=sel, ymax=seu),
        width=0.25,size=1.2) + 
    geom_point(color='black', size=2) + 
    scale_colour_manual(values=cbPalette) + 
    scale_x_discrete(labels=labR) + 
    ylab("Throughput (GB/s)") + 
    xlab("Size (MB/thread)") + 
    ggtitle("Image Volume Reading") + 
    tt +
    guides(colour=guide_legend(keywidth=2,keyheight=1.7)) + 
    theme(legend.justification=c(1,0), 
          legend.position=c(0.345,0.375))

pdf("../figs/store_a.pdf", height=6,width=7)
print(p1rse)
dev.off()

png("../figs/store_a.png", height=800, width=934, res=120)
print(p1rse)
dev.off()


p1wse <- ggplot(data=datWriteSE,aes(x=Size,y=avg,group=Threads,color=Threads)) + 
    geom_line(size=1) + 
    geom_errorbar(aes(ymin=sel, ymax=seu),
        width=0.25,size=1.2) + 
    geom_point(color='black', size=2) + 
    scale_colour_manual(values=cbPalette) + 
    #ylab("Throughput (GB/s)") + 
    xlab("Size (MB/thread)") + 
    scale_x_discrete(labels=labW) + 
    ggtitle("Image Volume Writing") + 
    tt +
    theme(legend.position='none',
          axis.title.y=element_blank())

pdf("../figs/store_b.pdf", height=6,width=7)
print(p1wse)
dev.off()

png("../figs/store_b.png", height=800, width=934, res=120)
print(p1wse)
dev.off()




#### NDBlaze data
ndblaze <- read.csv('../../store/data/write/data.csv')
                    #url("https://raw.githubusercontent.com/neurodata/ndpaper2016/0cc4e9a2adc80fc30e9091a4b6158f8823666249/store/data/write/data.csv")


NDB <- data.frame(stack(ndblaze[,-1]),Threads=ndblaze[,1])
colnames(NDB) <- c("values", "group", "Threads")
NDB$values <- NDB$values/1000
NDB$Threads <- as.factor(NDB$Threads)

p2 <-ggplot(data=NDB,
            aes(x=Threads,
                y=values,
                group=group,
                colour=group)) + 
     #ylab("Throughput (GB/s)") +
     ggtitle("Annotation Volume Writing") +
     scale_colour_manual(values=cbPalette[c(8,7,9)],
            labels=
            c('After Blaze', 'Before Blaze','Perceived')) +
     geom_line(size=1.5, alpha=1) + 
     geom_point(size=2,colour='black') +
#     scale_x_continuous(trans='log2',
#                        labels=c(1:4)) + 
#     scale_x_continuous(breaks=c(1,2,4,8,16)) +
     guides(colour=guide_legend(title=NULL, 
                    keywidth=2,
                    keyheight=1.6), 
		    override.aes=list(size=3)) + 
     tt + 
     theme(legend.title=element_blank(),
           legend.justification=c(1,0), 
           legend.position=c(0.965,0.3),
           axis.title.y=element_blank()) + 
     #annotation_custom(
     #   grob=textGrob(plotLabels[2],gp=gpar(cex=2)),
     #   ymin=102500,ymax=102500,
     #   xmin=1,xmax=1
     #   ) + 

        
pdf("../figs/store_c.pdf", height=5,width=8)
print(p2)
dev.off()

png("../figs/store_c.png", height=620, width=960,res=120)
print(p2)
dev.off()

#### Tile Read data from github csv file
tileDat <- read.csv('../../store/data/tilecache/1024_1024_4threads_ndtilecache.csv',
                    head=FALSE, 
                    stringsAsFactors=FALSE)
#"https://raw.githubusercontent.com/neurodata/ndpaper2016/gh-pages/Results/CSV/ndtilecache/1024_1024_4threads_ndtilecache.csv"

#### Fix some errors 
tileDat[488,] <- NA #0.624686002731
tileDat[1216,] <- NA #0.210937023163

tileDat <- tileDat[,1]
tileDat <- as.numeric(tileDat)
Tile<- 1:length(tileDat)

tileDat <- data.frame(Tile,Time=tileDat*1e3)

#### Tile read figure
p3 <- ggplot(data=tileDat,aes(x=Tile,y=Time)) + 
        geom_line() + 
        scale_y_log10() + 
        ylab("Time (ms)") + 
        xlab("Slice") +
        ggtitle("Reading 512 x 512 Image Tiles") + 
        #annotation_custom(
        #    grob=textGrob(plotLabels[3],gp=gpar(cex=2)),
        #    ymin=4, ymax=4,
        #    xmin=-250,xmax=-250
        #    ) + 
        tt
        
pdf("../figs/store_d.pdf", height=4,width=8)
print(p3)
dev.off()

png("../figs/store_d.png", height=480, width=960, res=120)
print(p3)
dev.off()


        

#### Downsample figure data
dsFile <- gzfile('../data/ds_data.gzip')
    #url("https://github.com/neurodata/ndgrutedb/raw/gkiar-dev/figs/downsample_profile_data/ds_data.gzip")
load(dsFile)
close(dsFile)

#### Data points retrieved from the web service with the following command run on awesome:
#### tail -f /var/log/celery/mrocp.log | egrep --line-buffered 'downsampling to factor|Completed building graph in |Your atlas has|took' | tee filtered_output.txt

#### This was tested on KKI2009_800_1_bg.graphml

tgp <- vapply(tgp, function(x){x}, 1)
trd <- vapply(trd, function(x){x}, 1)
tat <- vapply(tat, function(x){x}, 1)

tgp_e <- vapply(tgp_e, function(x){x}, 1)
trd_e <- vapply(trd_e, function(x){x}, 1)
tat_e <- vapply(tat_e, function(x){x}, 1)

labs <- c("Reading","Generation")

df <- data.frame(dsf,Reading=trd,Generation=tgp)
df2 <- melt(df,  id.vars = 'dsf', variable.name = 'time')

df3 <- data.frame(dsf=df2$dsf,activity=df2$variable,time=df2$value,se=c(trd_e,tgp_e))

colnames(df3) <- c('dsf', 'activity', 'time', 'se')

#### Downsample figure
p4 <- ggplot(df3, aes(x=dsf,y=time,color=activity)) +  
        geom_line(size=1.5) + 
        geom_errorbar(aes(ymin=time-se,ymax=time+se), 
                      width=.4, size=1) +
        geom_point(size=2, colour='black') + 
        #scale_color_manual(values=cbPalette[c(6,3)]) +
        #ggtitle("MR-GRUTEDB Spatial Downsample") +
        ggtitle("Spatial Graph Downsampling") +
        xlab('Downsample Factor') + 
        ylab("Time (s)") +
        tt +
        theme(legend.title=element_blank()) + 
        theme(legend.justification=c(1,0), 
              legend.position=c(0.97,0.25)) + 
        guides(colour=guide_legend(
			keywidth=1.5,
			keyheight=1.85))
        #annotation_custom(
        #    grob=textGrob(plotLabels[4],gp=gpar(cex=2)),
        #    ymin=360,ymax=360,
        #    xmin=1,xmax=1
        #    ) + 

pdf("../figs/store_e.pdf", height=6,width=10)
print(p4)
dev.off()

png("../figs/store_e.png", height=620, width=1200, res=120)
print(p4)
dev.off()


layoutStore1 <- rbind(c(1,1,2,2,3,3),
                     c(4,4,4,5,5,5))


#### With SE
pdf("../figs/store01.pdf",w=20,h=12)
grid.arrange(p1rse,p1wse,p2,p3,p4,layout_matrix=layoutStore1)
#grid.arrange(p1r,p1w,p2,p3,p4,layout_matrix=layoutStore1)
dev.off()

png("../figs/store01.png",w=1900,h=1140, res=96)
grid.arrange(p1rse,p1wse,p2,p3,p4,layout_matrix=layoutStore1)
#grid.arrange(p1r,p1w,p2,p3,p4,layout_matrix=layoutStore1)
dev.off()

#   Time: 4-5 days worth with many edits.
#   Working status: I think it's good to go.
### Comments: To run, `Rscript StoreFig1.r`
####Soli Deo Gloria
