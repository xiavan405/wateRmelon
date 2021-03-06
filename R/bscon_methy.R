#New BScon_methy after modifications of 17.09.2015

bscon_methy <- function(mset450k) {

green.Channel <- try (intensitiesByChannel(QCdata(mset450k))$Cy3, silent = T)
if (!inherits (green.Channel, 'try-error')){green.Channel <- intensitiesByChannel(QCdata(mset450k))$Cy3} 
  else 
    stop ("Green channel 450k QC data could not be found")

red.Channel<-try (intensitiesByChannel(QCdata(mset450k))$Cy5, silent = T)
if (!inherits (red.Channel, 'try-error')){red.Channel <- intensitiesByChannel(QCdata(mset450k))$Cy5} 
else 
  stop ("Red channel 450k QC data could not be found")

rownames(green.Channel)-> green.rows
rownames(red.Channel)-> red.rows
  
bisulfite.green <- green.Channel[grep("^B.*C.*I", rownames(green.Channel)),] #  find any rownames starting with B that contain a subsequent C and then an I
bisulfite.red <- red.Channel[grep("^B.*C.*I", rownames(red.Channel)),]
  
bsI.green <- bisulfite.green[1:12,]
bsI.red <- bisulfite.red[1:12,]
  
bsII.green <- green.Channel[grep( '^B.*C.*II', rownames(green.Channel)),]    #  as above with II (subset of above)
bsII.red <- red.Channel[grep( '^B.*C.*II', rownames(red.Channel)),]
  
# calculate BS conv type 1 betas as an example of using an index vector
BSI.betas<-rbind(bsI.green[1:3,], bsI.red[7:9,])/((rbind(bsI.green[1:3,], bsI.red[7:9,])) + rbind(bsI.green[4:6,], bsI.red[10:12,]))
  
#calculation of BS conv in Type II data
BSII.betas <- bsII.red/(bsII.red + bsII.green)
  
apply(rbind(BSI.betas, BSII.betas), 2, median)*100 ## this is the value you are interested in 
}
