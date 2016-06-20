#! /usr/bin/Rscript
###
### Image creation script for fig:store1
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


#### JLP messed with the colors
#### GK messed with colors
cbPalette <- c("#000000", "#56B4E9", "#E69F00","#0072D0", "#FFF000","#470778", "#CC79A7", "#00B800", "#006940","#005f5b", "#006352")
col1 <- c('#e66101','#fdb863','#f0f0f0','#b2abd2','#5e3c99')
col2 <- c('#1b9e77','#d95f02','#7570b3','#e7298a','#66a61e')
col3 <- c('#000000','#999999')

#### Theme options for ggplot
ts <- 32
tt <- theme(plot.title=element_text(size=ts),
          axis.title.x=element_text(size=ts - 2),
          axis.title.y=element_text(size=ts - 2),
          legend.title=element_text(size=ts),
          legend.text=element_text(size=ts-2),
          strip.text=element_text(size=ts),
          plot.margin=unit(1.00*c(1,1,1,1),'lines'),
          axis.text=element_text(size=ts-4))

outputDir <- '../figs/'


########################################################################
### Setting up url's for data read/write data
baseread<-"../../store/data/read/"
basewrite<-"../../store/data/write/"

Threads <- c(1,2,4,8,16,32)

#### File names
readFiles <- paste0(baseread,"read_",Threads,"_threads.csv")
writeFiles <- paste0(basewrite,"write_",Threads,"_threads.csv")


#### Reading in data
datRead <- foreach(i = 1:length(Threads),.combine='rbind') %do% {
  tmp <- read.csv(readFiles[i],header=FALSE)  
  colnames(tmp) <- c("Size",paste0("test",1:(ncol(tmp)-1),"_",Threads[i]))

  size <- tmp$Size 
  st <- stack(tmp[,-1])
  st$values <- (Threads[i]*size/1024)/st$values # Converted to GB
  th<-data.frame(size=size,threads=Threads[i],st)
}

#### Cleaning data types
datRead$threads <- as.factor(datRead$threads)
datRead$size <- as.factor(datRead$size)
datRead$ind <- as.factor(datRead$ind)
datRead$type <- "Read"

#### Reading in data
datWrite <- foreach(i = 1:length(Threads),.combine='rbind') %do% {
  tmp <- read.csv(writeFiles[i],header=FALSE)  
  colnames(tmp) <- c("Size", paste0("test",1:(ncol(tmp)-1),"_",Threads[i]))
  
  size <- tmp$Size
  st <- stack(tmp[,-1])
  st$values <- (Threads[i]*size/1024)/st$values # Converted to GB
  th<-data.frame(size=size,threads=Threads[i],st)
}

#### Cleaning data types
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

#### With SE
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

#### Cleaning data types
datReadSE$Threads <- as.factor(datReadSE$Threads)
datReadSE$Size <- as.factor(datReadSE$Size)
datReadSE$type <- "Read"


#### With SE
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


#### Cleaning data types
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
          legend.position=c(0.25,0.35))

pdf(paste0(outputDir,"/store-read.pdf"),height=6,width=10)
print(p1rse)
dev.off()

png(paste0(outputDir,"/store-read.png"),height=800, width=1200, res=120)
print(p1rse)
dev.off()


p1wse <- ggplot(data=datWriteSE,aes(x=Size,y=avg,group=Threads,color=Threads)) + 
    geom_line(size=1) + 
    geom_errorbar(aes(ymin=sel, ymax=seu),
        width=0.25,size=1.2) + 
    geom_point(color='black', size=2) + 
    scale_colour_manual(values=cbPalette) + 
    ylab("Throughput (GB/s)") + 
    xlab("Size (MB/thread)") + 
    scale_x_discrete(labels=labW) + 
    ggtitle("Image Volume Writing") + 
    tt +
    theme(legend.position='none')
          #axis.title.y=element_blank())

pdf(paste0(outputDir,"/store-write.pdf"), height=6,width=7)
print(p1wse)
dev.off()

png(paste0(outputDir,"/store-write.png"), height=800, width=934, res=120)
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
     ylab("Throughput (GB/s)") +
     ggtitle("Annotation Volume Writing") +
     scale_colour_manual(values=cbPalette[c(8,7,9)],
            labels=
            c('After Blaze', 'Before Blaze','Perceived')) +
     geom_line(size=1.5, alpha=1) + 
     geom_point(size=2,colour='black') +
     guides(colour=guide_legend(title=NULL, 
                    keywidth=2,
                    keyheight=1.6), 
		    override.aes=list(size=3)) + 
     tt + 
     theme(legend.title=element_blank(),
           legend.justification=c(1,0), 
           legend.position=c(0.965,0.3))
           #axis.title.y=element_blank())
        
pdf(paste0(outputDir,"/store-ndblaze.pdf"), height=5,width=8)
print(p2)
dev.off()

png(paste0(outputDir,"/store-ndblaze.png"), height=620, width=960,res=120)
print(p2)
dev.off()

#### Tilecache data from csv files
dir1 <- '../../store/data/tilecache'
tileDatFiles <- dir(dir1,full.names=TRUE)[grep('csv',dir(dir1,))]

tiledat <- foreach(i = tileDatFiles)%do%{
    read.csv(i, head=FALSE,stringsAsFactors=FALSE)
    }

datBU <- tiledat
o1 <- list()
o2 <- list()

### Replacing errors in csv with NAs
### And casting form strings to floats
print("Replacing non numeric entries and entries <= 0 with NAs")
for(i in 1:length(tiledat)){
    o1[[i]] <- grep('[0-9]\\.[0-9]{1,}\\.',tiledat[[i]][,1])
    o2[[i]] <- grep("^[0-9]{2,}",tiledat[[i]][,1])

    tiledat[[i]]$tile <- as.integer(rownames(tiledat[[i]]))

    tiledat[[i]][c(o1[[i]],o2[[i]]),] <- NA
    tiledat[[i]]$trial <- as.integer(i)
    tiledat[[i]][,1] <- as.numeric(tiledat[[i]][,1])
    tiledat[[i]][which(tiledat[[i]] <= 0),] <- NA
    tiledat[[i]] <- tiledat[[i]][complete.cases(tiledat[[i]]),]
    }

tot <- length(c(Reduce('c',o1),Reduce('c',o2)))
sprintf("Number of errors totals %d",tot) 
datL <- Reduce('rbind', tiledat)
datL$V1 <- datL$V1*1000 #Convert to miliseconds
datL$trial <- as.factor(datL$trial)
#levels(datL$trial) <- paste("Trial", 1:length(tiledat))

datL <- datL[datL$trial %in% c(1),]
p3 <-  ggplot(data=datL[1:600,],aes(x=tile,y=V1,group=trial,colour=trial)) + 
        geom_line(alpha=.75) + 
        #geom_rug(col="black",alpha=.1, sides='r') +
        scale_colour_manual(values=col3) +
        #scale_y_log10(limits=c(4,1e3),breaks=10^c(-3:3)) + 
        scale_y_log10() + 
        xlab('Slice') + 
        ylab("Time (ms)") + 
        ggtitle("Image Tile Reading (1024 x 1024 tiles)") + 
        tt + 
        theme(legend.position='none')
        #facet_grid(. ~ trial) + 
        #guides(colour=guide_legend(override.aes=list(linewidth=4))) + 
        #theme(legend.justification=c(1,0), 
        #      legend.position=c(0.97,0.75))

p33 <- ggplot(data=datL,aes(x=tile,y=V1,group=trial,colour=trial)) + 
        geom_violin() + 
        theme(text=element_blank(), 
              axis.ticks=element_blank(),
              legend.position='none')
p33

pdf(paste0(outputDir,"/store-tilecache.pdf"), height=4,width=10)
print(p3)
dev.off()

png(paste0(outputDir,"/store-tilecache.png"), height=480, width=1200, res=120)
print(p3)
dev.off()


        

#### Downsample figure data
#dsFile <- gzfile('../data/ds_data.gzip')
#    #url("https://github.com/neurodata/ndgrutedb/raw/gkiar-dev/figs/downsample_profile_data/ds_data.gzip")
#load(dsFile)
#close(dsFile)
#
##### Data points retrieved from the web service with the following command run on awesome:
##### tail -f /var/log/celery/mrocp.log | egrep --line-buffered 'downsampling to factor|Completed building graph in |Your atlas has|took' | tee filtered_output.txt
#
##### This was tested on KKI2009_800_1_bg.graphml
#
#tgp <- vapply(tgp, function(x){x}, 1)
#trd <- vapply(trd, function(x){x}, 1)
#tat <- vapply(tat, function(x){x}, 1)
#
#tgp_e <- vapply(tgp_e, function(x){x}, 1)
#trd_e <- vapply(trd_e, function(x){x}, 1)
#tat_e <- vapply(tat_e, function(x){x}, 1)
#
#labs <- c("Reading","Generation")
#
#df <- data.frame(dsf,Reading=trd,Generation=tgp)
#df2 <- melt(df,  id.vars = 'dsf', variable.name = 'time')
#
#df3 <- data.frame(dsf=df2$dsf,activity=df2$variable,time=df2$value,se=c(trd_e,tgp_e))
#
#colnames(df3) <- c('dsf', 'activity', 'time', 'se')
#
##### Downsample figure
#p4 <- ggplot(df3, aes(x=dsf,y=time,color=activity)) +  
#        geom_line(size=1.5) + 
#        geom_errorbar(aes(ymin=time-se,ymax=time+se), 
#                      width=.4, size=1) +
#        geom_point(size=2, colour='black') + 
#        #scale_color_manual(values=cbPalette[c(6,3)]) +
#        #ggtitle("MR-GRUTEDB Spatial Downsample") +
#        ggtitle("Spatial Graph Downsampling") +
#        xlab('Downsample Factor') + 
#        ylab("Time (s)") +
#        tt +
#        theme(legend.title=element_blank()) + 
#        theme(legend.justification=c(1,0), 
#              legend.position=c(0.97,0.25)) + 
#        guides(colour=guide_legend(
#			keywidth=1.5,
#			keyheight=1.85))
#        #annotation_custom(
#        #    grob=textGrob(plotLabels[4],gp=gpar(cex=2)),
#        #    ymin=360,ymax=360,
#        #    xmin=1,xmax=1
#        #    ) + 
#
#pdf(paste0(outputDir,"/ndpaper-fig1e.pdf"), height=6,width=10)
#print(p4)
#dev.off()
#
#png(paste0(outputDir,"/ndpaper-fig1e.png"), height=620, width=1200, res=120)
#print(p4)
#dev.off()


### Ingest Times
inDat <- read.csv("../../store/data/ingest/ingest_timing.csv", header=TRUE)

in1 <- stack(inDat[,-c(1)])
in1$Trial <- as.factor(gsub("X", "", in1$ind))
in1$ind <- NULL
in1$Size <- as.integer(inDat$Size)
in1$MBps <- (in1$Size*1024)/in1$values
in1$Size <- as.factor(inDat$Size)

ingestTime <- 
    ggplot(data=in1, aes(x=Size, y=MBps, group=Trial))+
        geom_line(aes(colour=Trial), size=1.5, alpha=0.55) +
        geom_point(size=2) + 
        ylab("Throughput (MB/s)") +
        xlab("Size (GB)") + 
        ggtitle("Image Ingest Throughput Trials")+
        tt +
        guides(
               colour=guide_legend(
                title=NULL,
                keywidth=2.3,
                keyheight=1.6), 
	       override.aes=list(size=3)) + 
        theme(legend.justification=c(1,0), 
          legend.position=c(0.975,0.25))

pdf(paste0(outputDir,"/store-ingest.pdf"), height=6,width=10)
print(ingestTime)
dev.off()

png(paste0(outputDir,"/store-ingest.png"), height=620, width=1200, res=120)
print(ingestTime)
dev.off()

layoutStore1 <- rbind(c(1,1,2,2,3,3),
                     c(4,4,4,5,5,5))

layoutStore2 <- rbind(c(1,1,2,2,3,3),
                     c(4,4,4,5,6,6))

layoutStore3 <- rbind(c(1,1,2,2),
                     c(3,3,4,4))
#### With SE
pdf(paste0(outputDir,"/store.pdf"),w=20,h=12)
#grid.arrange(p1rse,p3,p1wse,p2,layout_matrix=layoutStore3)
grid.arrange(p1rse,p3,ingestTime,p2,layout_matrix=layoutStore3)
dev.off()

png(paste0(outputDir,"/store.png"),w=1900,h=1140, res=96)
#grid.arrange(p1rse,p3,p1wse,p2,layout_matrix=layoutStore3)
grid.arrange(p1rse,p3,ingestTime,p2,layout_matrix=layoutStore3)
dev.off()

#   Time: 10+ days worth, with many small edits.
#   Working status: I think it's good to go.
### Comments: To run, `Rscript StoreFig1.r`
####Soli Deo Gloria
