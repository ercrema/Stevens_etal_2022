# Load library and Data ----
library(here)
library(RColorBrewer)
japan  <- read.csv(here('data','SiteList_JP.csv'))
korea  <- read.csv(here('data','SiteList_KOR.csv'))

# Define and Macro-Regions and Periods ----

# Group Japan by Region
japan$MacroRegion = "South-West"
japan$MacroRegion[which(japan$Region%in%c('Kanto','Chubu'))]='Central'
japan$MacroRegion[which(japan$Region%in%c('Tohoku'))]='North-East'

# Re-organise Period in Korea
korea$Period2 = korea$Period 
korea$Period2[which(korea$Period %in% c('Early Mumun','Late Mumun'))] = 'Mumun'

# Compute Frequences and HPDIs (Japan) ----
japan.periods = c('Jomon','Yayoi','Kofun','Kodai')
japan.regions = c('South-West','Central','North-East')
japan.freq = expand.grid(japan.periods,japan.regions,stringsAsFactors = FALSE)
colnames(japan.freq) = c('Period','Region')

japan.freq$wildnuts = NA
japan.freq$wildnuts.lo90 = NA
japan.freq$wildnuts.hi90 = NA
japan.freq$wildnuts.lo50 = NA
japan.freq$wildnuts.hi50 = NA
japan.freq$wildnuts.obsProp = NA
japan.freq$ricemillets = NA
japan.freq$ricemillets.lo90 = NA
japan.freq$ricemillets.hi90 = NA
japan.freq$ricemillets.lo50 = NA
japan.freq$ricemillets.hi50 = NA
japan.freq$ricemillets.obsProp = NA
japan.freq$total = NA


for (i in 1:nrow(japan.freq))
{

	tmp = subset(japan,Period==japan.freq$Period[i] & MacroRegion==japan.freq$Region[i])
	japan.freq$total[i] = nrow(tmp)
	japan.freq$wildnuts[i]=sum(tmp$wild_nuts)
	japan.freq$ricemillets[i]=sum(tmp$rice_and_millets)
	japan.freq$wildnuts.obsProp[i] = japan.freq$wildnuts[i]/japan.freq$total[i]
	japan.freq$wildnuts.lo90[i] = qbeta(0.05,japan.freq$wildnuts[i]+1,japan.freq$total[i]-japan.freq$wildnuts[i]+1)
	japan.freq$wildnuts.hi90[i] = qbeta(0.95,japan.freq$wildnuts[i]+1,japan.freq$total[i]-japan.freq$wildnuts[i]+1)
	japan.freq$wildnuts.lo50[i] = qbeta(0.25,japan.freq$wildnuts[i]+1,japan.freq$total[i]-japan.freq$wildnuts[i]+1)
	japan.freq$wildnuts.hi50[i] = qbeta(0.75,japan.freq$wildnuts[i]+1,japan.freq$total[i]-japan.freq$wildnuts[i]+1)
	japan.freq$ricemillets.obsProp[i] = japan.freq$ricemillets[i]/japan.freq$total[i]
	japan.freq$ricemillets.lo90[i] = qbeta(0.05,japan.freq$ricemillets[i]+1,japan.freq$total[i]-japan.freq$ricemillets[i]+1)
	japan.freq$ricemillets.hi90[i] = qbeta(0.95,japan.freq$ricemillets[i]+1,japan.freq$total[i]-japan.freq$ricemillets[i]+1)
	japan.freq$ricemillets.lo50[i] = qbeta(0.25,japan.freq$ricemillets[i]+1,japan.freq$total[i]-japan.freq$ricemillets[i]+1)
	japan.freq$ricemillets.hi50[i] = qbeta(0.75,japan.freq$ricemillets[i]+1,japan.freq$total[i]-japan.freq$ricemillets[i]+1)
}


# Compute Frequences and HPDIs (Korea) ----
korea.periods = c('Early Chulmun','Middle Chulmun','Late Chulmun','Mumun')
korea.freq = data.frame(Period=korea.periods)

korea.freq$wildnuts = NA
korea.freq$wildnuts.lo90 = NA
korea.freq$wildnuts.hi90 = NA
korea.freq$wildnuts.lo50 = NA
korea.freq$wildnuts.hi50 = NA
korea.freq$wildnuts.obsProp = NA
korea.freq$ricemillets = NA
korea.freq$ricemillets.lo90 = NA
korea.freq$ricemillets.hi90 = NA
korea.freq$ricemillets.lo50 = NA
korea.freq$ricemillets.hi50 = NA
korea.freq$ricemillets.obsProp = NA
korea.freq$total = NA


for (i in 1:nrow(korea.freq))
{

	tmp = subset(korea,Period2==korea.freq$Period[i])
	korea.freq$total[i] = nrow(tmp)
	korea.freq$wildnuts[i]=sum(tmp$wild_nuts)
	korea.freq$ricemillets[i]=sum(tmp$rice_and_millets)
	korea.freq$wildnuts.obsProp[i] = korea.freq$wildnuts[i]/korea.freq$total[i]
	korea.freq$wildnuts.lo90[i] = qbeta(0.05,korea.freq$wildnuts[i]+1,korea.freq$total[i]-korea.freq$wildnuts[i]+1)
	korea.freq$wildnuts.hi90[i] = qbeta(0.95,korea.freq$wildnuts[i]+1,korea.freq$total[i]-korea.freq$wildnuts[i]+1)
	korea.freq$wildnuts.lo50[i] = qbeta(0.25,korea.freq$wildnuts[i]+1,korea.freq$total[i]-korea.freq$wildnuts[i]+1)
	korea.freq$wildnuts.hi50[i] = qbeta(0.75,korea.freq$wildnuts[i]+1,korea.freq$total[i]-korea.freq$wildnuts[i]+1)
	korea.freq$ricemillets.obsProp[i] = korea.freq$ricemillets[i]/korea.freq$total[i]
	korea.freq$ricemillets.lo90[i] = qbeta(0.05,korea.freq$ricemillets[i]+1,korea.freq$total[i]-korea.freq$ricemillets[i]+1)
	korea.freq$ricemillets.hi90[i] = qbeta(0.95,korea.freq$ricemillets[i]+1,korea.freq$total[i]-korea.freq$ricemillets[i]+1)
	korea.freq$ricemillets.lo50[i] = qbeta(0.25,korea.freq$ricemillets[i]+1,korea.freq$total[i]-korea.freq$ricemillets[i]+1)
	korea.freq$ricemillets.hi50[i] = qbeta(0.75,korea.freq$ricemillets[i]+1,korea.freq$total[i]-korea.freq$ricemillets[i]+1)
}




# Plot Results (Japan) ----

pdf(width=10,height=7,file=here('figures','japan_abot.pdf'))
par(mar=c(3,4,3,1))
plot(NULL,xlim=c(0.75,14.25),ylim=c(0,2.1),xlab='',ylab='Proportion Sites',axes=FALSE,main='')
japan.freq$index = c(1:4,6:9,11:14)
japan.freq$cols = rep(brewer.pal(n=4,'Set2'),3)
w = 0.35
for (i in 1:nrow(japan.freq))
{
	rect(xleft=japan.freq$index[i]-w,xright=japan.freq$index[i]+w,ybottom=1.1+japan.freq$wildnuts.lo90[i],ytop=1.1+japan.freq$wildnuts.hi90[i],border=NA,col=japan.freq$cols[i])
	points(x=japan.freq$index[i],y=1.1+japan.freq$wildnuts.obsProp[i],pch="+")

	rect(xleft=japan.freq$index[i]-w,xright=japan.freq$index[i]+w,ybottom=japan.freq$ricemillets.lo90[i],ytop=japan.freq$ricemillets.hi90[i],border=NA,col=japan.freq$cols[i])
	points(x=japan.freq$index[i],y=japan.freq$ricemillets.obsProp[i],pch="+")
}
axis(side=1,at=c(2.5,7.5,12.5),labels=c('South-West','Central','North-East'),tick=FALSE,cex=1.2)
abline(v = c(5,10),lty=2)
axis(side=2,at=seq(0,1,length.out=5),labels=seq(0,1,length.out = 5),las=2)
axis(side=2,at=1.1+seq(0,1,length.out=5),labels=seq(0,1,length.out = 5),las=2)
axis(side=3,at=japan.freq$index,labels = paste0('n=',japan.freq$total),cex=1,tick=FALSE,padj=1)
legend('bottomright',legend=c('Jomon','Yayoi','Kofun','Kodai'),fill=brewer.pal(n=4,'Set2'),bty='n')
text(x=2,y=0.95,labels = 'Rice + Millets',cex=1.3)
text(x=2,y=2.05,labels = 'Wild Nuts',cex=1.3)
dev.off()


# Plot Results (Korea) ----
pdf(width=6,height=7,file=here('figures','korea_abot.pdf'))
par(mar=c(3,4,3,1))
plot(NULL,xlim=c(0.75,4.25),ylim=c(0,2.1),xlab='',ylab='Proportion Sites',axes=FALSE,main='')
korea.freq$index = c(1:4)
w = 0.2
for (i in 1:nrow(korea.freq))
{
	rect(xleft=korea.freq$index[i]-w,xright=korea.freq$index[i]+w,ybottom=1.1+korea.freq$wildnuts.lo90[i],ytop=1.1+korea.freq$wildnuts.hi90[i],border=NA,col='steelblue')
	points(x=korea.freq$index[i],y=1.1+korea.freq$wildnuts.obsProp[i],pch="+")

	rect(xleft=korea.freq$index[i]-w,xright=korea.freq$index[i]+w,ybottom=korea.freq$ricemillets.lo90[i],ytop=korea.freq$ricemillets.hi90[i],border=NA,col='steelblue')
	points(x=korea.freq$index[i],y=korea.freq$ricemillets.obsProp[i],pch="+")
}
axis(side=1,at=c(1:4),labels=c('Early \n Chulmun','Middle \n Chulmun','Late \n Chulumun','Mumun'),tick=FALSE,cex=1.2)
axis(side=2,at=seq(0,1,length.out=5),labels=seq(0,1,length.out = 5),las=2)
axis(side=2,at=1.1+seq(0,1,length.out=5),labels=seq(0,1,length.out = 5),las=2)
axis(side=3,at=korea.freq$index,labels = paste0('n=',korea.freq$total),cex=1,tick=FALSE,padj = 1)
text(x=1 ,y=0.95,labels = 'Rice + Millets',cex=1)
text(x=1,y=2.05,labels = 'Wild Nuts',cex=1)
dev.off()
