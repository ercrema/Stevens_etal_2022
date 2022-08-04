#### This scripts prepare the data downleaded from the "Database of Plant Macrofossils from Archaeological Sites in Japan" (URL:https://www.rekihaku.ac.jp/up-cgi/login.pl?p=param/issi/db_param).
#### Queries were carried out on the 19th of July 2022 by setting "時代分類" (Period) to 'C:弥生時代','D:古墳時代', and 'E:古代'.
#### Downloaded CSV files were originally encoded in Shift-JIS and re-encoded in UTF-8

# Load Library ----
library(here)
library(sf)
library(dplyr)

# Read and Aggregate Data ----
yayoi  <- read.csv(here('data','yayoi_abot.csv'),header = FALSE)
kofun  <- read.csv(here('data','kofun_abot.csv'),header = FALSE)
kodai  <- read.csv(here('data','kodai_abot.csv'),header = FALSE)

yayoi$PeriodClassification  <- c("Yayoi")
kofun$PeriodClassification  <- c("Kofun")
kodai$PeriodClassification  <- c("Kodai")

complete  <- rbind.data.frame(yayoi,kofun,kodai)

# Setup Header ----
colnames(complete) = c('ID','Taxon','APGNameJP','APGNameLatin','EnglerJP','EnglerLatin','Part','SiteName','Prefecture','SiteAdresss','Latitude','Longitude','Period','Creator','Year','Title','Page','Notes','Notes2','VolumeTitle','PublishedBy','PeriodClassification')

# Translate Prefecture ----
# Clean Field
complete$Prefecture = unlist(lapply(strsplit(complete$Prefecture,split="："),function(x){x[2]}))
complete$Prefecture = unlist(strsplit(complete$Prefecture,split="県"))
complete$Prefecture[which(complete$Prefecture=="大阪府")]="大阪"
complete$Prefecture[which(complete$Prefecture=="京都府")]="京都"
complete$Prefecture[which(complete$Prefecture=="東京都")]="東京"
# Read and Join to Lookup Table
prefTranslate = read.csv(here('data','prefectures_translations.csv'))
complete = left_join(complete,prefTranslate,by=c('Prefecture'='JpNames'))

# Exclude Hokkaido ----
complete  <- subset(complete,Region!='Hokkaido')

# Read Key Taxa Translation ----
# taxa_translation.csv provides the translation and classification of key taxa
taxa_translation  <- read.csv(here('data','taxa_translation_JP.csv'))
complete  <- left_join(complete,taxa_translation,by=c('ID'='ID'))


# Define Unique SiteID ----
# Give a unique SiteID for each unique combination of site name, prefecture, and period:
complete$site.comb = as.factor(paste(complete$SiteName,complete$Translation,complete$PeriodClassification,sep='.'))
complete$SiteID = paste0('J',as.numeric(complete$site.comb))

# Same site can often have different geographic coordinates. This could be either because of a small differences in the excavation units across different campaigns, or genuinely two different sites that happen to  have the same name.

# Extract unique sites with same SiteID but different geographic coordinates and compute maximum inter-distance
sites = select(complete,SiteID,site.comb,Latitude,Longitude) |> unique()
dupNames = names(table(sites$site.comb))[which(table(sites$site.comb)>1)]
sites.dup = sites[which(sites$site.comb%in%dupNames),]
sites.dup  <- st_as_sf(sites.dup,coords=c("Longitude","Latitude"),crs=4326)
dupNames.maxDist = numeric(length(dupNames))
for (i in  1:length(dupNames))
{
	j = which(sites.dup$site.comb==dupNames[i])
	dupNames.maxDist[i] = as.numeric(max(st_distance(sites.dup[j,],sites.dup[j,]))/1000)
}

# Manually Check Site Location Address for Discrepancies:
dups = cbind.data.frame(SiteName=dupNames,MaxDist=dupNames.maxDist)
dups2check = subset(dups,MaxDist>5) # manually check sets with a distance over 5km:

dups2check[1,]
subset(complete,SiteName=="布留遺跡"&Translation=='Nara') |> select(SiteName,Latitude,Longitude,SiteAdresss,VolumeTitle) |> unique()
# Same Site

# Create Site List and Extract Presence/Absence ----
sitelist = select(complete,SiteID,SiteName,Prefecture=Translation,Region=Region,Period=PeriodClassification) |> unique()

sitelist$chestnut = sitelist$buckeye = sitelist$walnut = sitelist$acorn = sitelist$rice = sitelist$millet = sitelist$beechnut = sitelist$hazelnut = sitelist$acorn_beechnut = sitelist$chestnut_beechnut = sitelist$acorn_chestnut = sitelist$rice_and_millets = sitelist$wild_nuts = 0 

for (i in 1:length(sitelist$SiteID))
{
	tmp = subset(complete,SiteID==sitelist$SiteID[i])
	sitelist$chestnut[i] = any(tmp$Classification=='chestnut',na.rm=T)
	sitelist$buckeye[i] = any(tmp$Classification=='buckeye',na.rm=T)
	sitelist$walnut[i] = any(tmp$Classification=='walnut',na.rm=T)
	sitelist$hazelnut[i] = any(tmp$Classification=='hazelnut',na.rm=T)
	sitelist$acorn[i] = any(tmp$Classification=='acorn',na.rm=T)
	sitelist$acorn_beechnut[i] = any(tmp$Classification=='acorn / beechnut',na.rm=T)
	sitelist$chestnut_beechnut[i] = any(tmp$Classification=='chestnut / beechnut',na.rm=T)
	sitelist$rice[i] = any(tmp$Classification=='crop (rice)',na.rm=T)
	sitelist$millet[i] = any(tmp$Classification=='crop (millet)',na.rm=T)
	sitelist$rice_and_millets[i] = any(tmp$Classification2=='Millets + Rice',na.rm=T)
	sitelist$wild_nuts[i] = any(tmp$Classification2=='Wild Nuts',na.rm=T)
}

write.csv(sitelist,here("data","SiteList_JP.csv"),row.names=FALSE)
