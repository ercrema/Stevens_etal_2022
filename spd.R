# Load Library ----
library(here)
library(rcarbon)
library(sf)
library(rnaturalearth)

# Read Data ----
temp <- tempfile()
download.file("https://discovery.ucl.ac.uk/id/eprint/10025178/4/Bevan_gbie14Csub.zip",temp)
c14data <- read.csv(unz(temp, "gbie14Csub/dates/archdates.csv"))

# Subset to Great Britain without scottish Isles ----
uk <- ne_states(country = "united kingdom",returnclass = 'sf')
scotland  <- subset(uk,region%in%c('Highlands and Islands','North Eastern','South Western',"Eastern")) |> st_union() |> st_cast(to='POLYGON')
scotland  <- scotland[order(st_area(scotland),decreasing=TRUE)[1]]
england_and_wales  <- subset(uk,!region%in%c('Highlands and Islands','North Eastern','South Western', 'Eastern','Northern Ireland')) |> st_union() |> st_cast(to='POLYGON')
win = st_union(scotland,england_and_wales) |> st_union()

# Subset only sites within window ----
sites  <- st_as_sf(c14data,coords=c('Longitude','Latitude'),crs=4326)
i   <- st_contains(win,sites,sparse = F,prepared = F)
c14data  <- c14data[i,]


# Subset dates for Wheat, Barley, and Hazelnuts ----
c14data$cat  <- NA
toMatchMat <- c("nutshell","grain","fruit","seed")
check1 <- grepl(paste(toMatchMat,collapse="|"), c14data$Material)
c14data$cat[which(grepl("Corylus",c14data$Species) & check1)] = 'hazelnut'

check <- grepl("Triticum",c14data$Species)
toExclude <- c("Hordeum/Triticum","Triticum/Hordeum vulgare ", "Hordeum vulgare/Triticum spelta", "Hordeum vulgare/Triticum","Avena/Triticum")
c14data$cat[which(check & !c14data$Species %in% toExclude)] = 'wheat'

check <- grepl("Hordeum",c14data$Species)
toExclude <- c("Hordeum/Triticum","Triticum/Hordeum vulgare ", "Hordeum vulgare/Triticum spelta", "Hordeum vulgare/Triticum","Avena/Triticum")
check <- check & !c14data$Species %in% toExclude
c14data$cat[which(check & !c14data$Species %in% toExclude)] = 'barley'

# check <- grepl("Avena",c14data$Species) & check1
# toExclude <- c("Avena/Triticum")
# check <- check & !c14data$Species %in% toExclude
# c14data$cat[which(check & !c14data$Species %in% toExclude)] = 'oats'

c14data  <- subset(c14data,!is.na(cat))
c14data$cat2  <- "Wheat + Barley"
c14data$cat2[which(c14data$cat=='hazelnut')] = "Hazelnut"
c14data$cat2 = factor(c14data$cat2,levels=c('Wheat + Barley','Hazelnut'),ordered=T)

# Calibrate and Plot StackSPD ----
caldates  <-  calibrate(c14data$CRA,c14data$Error,normalised=TRUE)
BCADtoBP(-6000) #7949
BCADtoBP(-1000) #2949
nrow(c14data) #1718 --> total number of dates
length(which.CalDates(caldates,BP < 7949 & BP > 2949, p=0.5)) #effective number of dates between 6000 and 1000 BC: 830 --> effective number of dates
ii  <- which.CalDates(caldates,BP <7949 & BP >2949, p=0.5)
table(c14data[ii,]$cat2)

# Wheat + Barley       Hazelnut                                                                                                              
#            285            542

stspd  <- stackspd(caldates,timeRange=BCADtoBP(c(-6000,-1000)),group = c14data$cat2)
# Permutation Test
test  <- permTest(x=caldates,timeRange=BCADtoBP(c(-6000,-1000)),marks=c14data$cat2,nsim=1000,runm=100)
# Extract regions of positive and negative deviations 
obs <- test$observed[[1]]
envelope <-test$envelope[[1]]
positive <- which(obs[,2]>envelope[,2])
negative <- which(obs[,2]<envelope[,1])


# Plot ----
pdf(width=9,height=5,file=here('figures','spd_gb.pdf'))
par(mfrow=c(1,2))
plot(stspd,type='proportion',calendar='BCAD',runm=100,ylab='Proportion SPD',col.fill=c('indianred','steelblue'),main='Relative Proportion of Wild Nuts vs Crops',legend=F,axes=F)

# Plot Intervals with significant positive an negative deviations of Hazelnut
i=1
while (i < length(obs[,1]))
{	
	if(!is.na(obs[i,2]))
	{
		if(obs[i,2]>envelope[i,2])
		{
			ss=obs[i,1]
			while(obs[i,2]>envelope[i,2])
			{
				ee=obs[i,1]
				i=i+1
				if (i>length(obs[,1]))
				{
					i = length(obs[,1])
					ee=obs[i,1]
					break()
				}
			}
			if (ss!=ee)	
			{
				arrows(x0=BPtoBCAD(ss),x1=BPtoBCAD(ee),y0=0.9,y1=0.9,length=0.02,angle = 90,code = 3,lwd=2)
				text(x=BPtoBCAD(median(c(ss,ee))),y=0.93,label='b',cex=0.8)
			}
		}
	}
	i = i+1
}

i=1
while (i < length(obs[,1]))
{
	if(!is.na(obs[i,2]))
	{
		if(obs[i,2]<envelope[i,1])
		{
			ss=obs[i,1]
			while(obs[i,2]<envelope[i,1])
			{
				ee=obs[i,1]
				i=i+1
				if (i>length(obs[,1]))
				{
					i = length(obs[,1])
					ee=obs[i,1]
					break()
				}
			}
			if (ss!=ee & abs(ss-ee)>50)
			{

				arrows(x0=BPtoBCAD(ss),x1=BPtoBCAD(ee),y0=0.9,y1=0.9,length=0.02,angle = 90,code = 3,lwd=2)
				text(x=BPtoBCAD(median(c(ss,ee))),y=0.93,label='a',cex=0.8)
			}
		}
	}
	i = i+1
}


plot(stspd,legend=T,col.fill=c('indianred','steelblue'),col.line=NULL,legend.arg=list(x='topleft',bty='n',cex=0.9),runm=100,calendar='BCAD')

dev.off()


