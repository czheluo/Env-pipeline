times<-Sys.time()
library(qqman)
library('getopt')
options(bitmapType='cairo')
spec = matrix(c(
    'infile','f',0,'character',
    'outfile','o',0,'character',
    'table','l',0,'character'
     ), byrow=TRUE, ncol=4);
opt = getopt(spec);
print_usage <- function(spec=NULL){
    cat(getopt(spec, usage=TRUE));
    cat("Usage example: \n")
    cat("
    Usage example:
    Usage:
    --infile sweep out file
    --outfile figure name
    --table out file
    --help      usage
    \n")
    q(status=1);
}
if ( !is.null(opt$help) ) { print_usage(spec) }
if ( is.null(opt$infile) ) { print_usage(spec) }
if ( is.null(opt$outfile) ) { print_usage(spec) }

mydata<-read.table(opt$infile,header = TRUE,sep="\t")
mydata$ne <- log10(mydata[,3])
newdata <- mydata[c(1,2,4)]
colnames(newdata) <- c("CHR","POS","P")
ymaxP=ceiling(max(newdata$P,na.rm=TRUE))
yminP=ceiling(min(newdata$P,na.rm=TRUE))
png(paste(opt$outfile,".png",sep=""),height=900,width=1600)
manhattan(newdata,chr="CHR",bp="POS",p="P",col=rainbow(4),chrlabs=("SNPs"),ylab="log10(BF)",ylim=c(yminP,ymaxP),suggestiveline=FALSE ,genomewideline=1.5,logp=FALSE)
dev.off()
pdf(paste(opt$outfile,".pdf",sep=""),height=8,width=16)
manhattan(newdata,chr="CHR",bp="POS",p="P",col=rainbow(4),chrlabs=("SNPs"),ylab="log10(BF)",ylim=c(yminP,ymaxP),suggestiveline=FALSE,genomewideline=1.5,logp=FALSE)
dev.off()
select <- subset(newdata,newdata$P>=1.5)
select <- select[with(select,order(newdata$POS)),]
select <- select[order(newdata$POS,newdata$P),]
write.table(select, file = opt$table)
escaptime=Sys.time()-times;
print("Done!")
print(escaptime)
