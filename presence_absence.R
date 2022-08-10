# Load library and Data ----
library(here)
library(RColorBrewer)
japan  <- read.csv(here('data','SiteList_JP.csv'))
korea  <- read.csv(here('data','SiteList_KOR.csv'))
source(here('src','addBetaDens.R'))
# Define and Macro-Regions and Periods ----
# Group Japan by Region
japan$MacroRegion = "South-West"
japan$MacroRegion[which(japan$Region%in%c('Kanto','Chubu'))]='Central'
japan$MacroRegion[which(japan$Region%in%c('Tohoku'))]='North-East'

# Re-organise Period in Korea
korea  <- subset(korea, Period != 'Early Chulmun')
korea$Period2 = korea$Period 
korea$Period2[which(korea$Period %in% c('Early Mumun','Late Mumun'))] = 'Mumun'

# Consider only sites with presence of Rice or Millets ----
japan  <- subset(japan,rice_and_millets == 1)
korea  <- subset(korea,rice_and_millets == 1)


# Compute Frequences and HPDIs (Japan) ----
japan.periods = c('Yayoi','Kofun','Kodai')
japan.regions = c('South-West','Central','North-East')
japan.freq = expand.grid(japan.periods,japan.regions,stringsAsFactors = FALSE)
colnames(japan.freq) = c('Period','Region')

japan.freq$wildnuts = NA
japan.freq$total = NA
japan.freq$beta1 = NA
japan.freq$beta2 = NA


for (i in 1:nrow(japan.freq))
{

	tmp = subset(japan,Period==japan.freq$Period[i] & MacroRegion==japan.freq$Region[i])
	japan.freq$total[i] = nrow(tmp)
	japan.freq$wildnuts[i]=sum(tmp$wild_nuts)
	japan.freq$beta1[i] = 0.5 + japan.freq$wildnuts[i]
	japan.freq$beta2[i] = 0.5 + japan.freq$total[i] - japan.freq$wildnuts[i]
}


# Compute Frequences and HPDIs (Korea) ----
korea.periods = c('Middle Chulmun','Late Chulmun','Mumun')
korea.freq = data.frame(Period=korea.periods)

korea.freq$wildnuts = NA
korea.freq$total = NA
korea.freq$beta1 = NA
korea.freq$beta2 = NA

for (i in 1:nrow(korea.freq))
{

	tmp = subset(korea,Period2==korea.freq$Period[i])
	korea.freq$total[i] = nrow(tmp)
	korea.freq$wildnuts[i]=sum(tmp$wild_nuts)
	korea.freq$beta1[i] = 0.5 + korea.freq$wildnuts[i]
	korea.freq$beta2[i] = 0.5 + korea.freq$total[i] - korea.freq$wildnuts[i]
}






# Plot Frequencies/HPDIs (Japan) ----

pdf(width=8,height=4,file=here('figures','japan_abot.pdf'))
par(mar=c(3,4,3,1))
plot(NULL,xlim=c(0.75,11.25),ylim=c(0,1),xlab='',ylab='Proportion Sites',axes=FALSE,main='')
japan.freq$index = c(1:3,5:7,9:11)
japan.freq$cols = rep(brewer.pal(n=3,'Set2'),3)
w = 0.3

for (i in 1:nrow(japan.freq))
{
	addBetaDens(x=japan.freq$index[i],beta1=japan.freq$beta1[i],beta2=japan.freq$beta2[i],w=w,col=japan.freq$cols[i])
}


axis(side=1,at=c(2,6,10),labels=c('South-West','Central','North-East'),tick=FALSE,cex=1.2)
abline(v = c(4,8),lty=2)
axis(side=2,at=seq(0,1,length.out=5),labels=seq(0,1,length.out = 5),las=2)
axis(side=2,at=1.1+seq(0,1,length.out=5),labels=seq(0,1,length.out = 5),las=2)
axis(side=3,at=japan.freq$index,labels = paste0('n=',japan.freq$total),cex=1,tick=FALSE,padj=1)
legend('bottomright',legend=c('Yayoi','Kofun','Kodai'),fill=brewer.pal(n=4,'Set2'),bty='n')
dev.off()


# Plot Frequencies/HPDIs (Korea) ----
pdf(width=6,height=4,file=here('figures','korea_abot.pdf'))
par(mar=c(3,4,3,1))
plot(NULL,xlim=c(0.75,3.25),ylim=c(0,1),xlab='',ylab='Proportion Sites',axes=FALSE,main='')
korea.freq$index = c(1:3)
w = 0.2

for (i in 1:nrow(korea.freq))
{
	addBetaDens(x=korea.freq$index[i],beta1=korea.freq$beta1[i],beta2=korea.freq$beta2[i],w=w,col='steelblue')
}

axis(side=1,at=c(1:4),labels=c('Early \n Chulmun','Middle \n Chulmun','Late \n Chulumun','Mumun'),tick=FALSE,cex=1.2)
axis(side=2,at=seq(0,1,length.out=5),labels=seq(0,1,length.out = 5),las=2)
axis(side=3,at=korea.freq$index,labels = paste0('n=',korea.freq$total),cex=1,tick=FALSE,padj = 1)
dev.off()
