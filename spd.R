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


# Subset dates for Oats, Wheat, Barley, and Hazelnuts ----
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

check <- grepl("Avena",c14data$Species) & check1
toExclude <- c("Avena/Triticum")
check <- check & !c14data$Species %in% toExclude
c14data$cat[which(check & !c14data$Species %in% toExclude)] = 'oats'

c14data  <- subset(c14data,!is.na(cat))
c14data$cat2  <- "Oat + Wheat + Barley"
c14data$cat2[which(c14data$cat=='hazelnut')] = "Hazelnut"
c14data$cat2 = factor(c14data$cat2,levels=c('Oat + Wheat + Barley','Hazelnut'),ordered=T)

# Calibrate and Plot StackSPD ----
caldates  <-  calibrate(c14data$CRA,c14data$Error,normalised=FALSE)
BCADtoBP(-6000) #7949
BCADtoBP(-1000) #2949
nrow(c14data) #1718 --> total number of dates
length(which.CalDates(caldates,BP < 7949 & BP > 2949, p=0.5)) #effective number of dates between 6000 and 1000 BC: 830 --> effective number of dates

stspd  <- stackspd(caldates,timeRange=BCADtoBP(c(-6000,-1000)),group = c14data$cat2)
par(mfrow=c(1,2))
plot(stspd,type='proportion',calendar='BCAD',runm=50,ylab='Proportion SPD',col.fill=c('indianred','steelblue'),main='Relative Proportion of Wild Nuts vs Crops',legend=F)
plot(stspd,legend=T,col.fill=c('indianred','steelblue'),col.line=NULL,legend.arg=list(x='topright',bty='n'),runm=50,calendar='BCAD')

# Add lines with significant deviations from NULL ----
test  <- permTest(x=caldates,timeRange=BCADtoBP(c(-6000,-1000)),marks=c14data$cat2,nsim=1000)


