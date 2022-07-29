# Data and Scripts for the manuscript "The impotance of wild resources as a reflection of the resilience and changing nature of early agricultural systems in East Asia and Europe"

This repository contains data and scripts required for generating figures XX and XX in the following manuscript:

Stevens, C.J., Shoda, S., Crema, E.R (2022). The impotance of wild resources as a reflection of the resilience and changing nature of early agricultural systems in East Asia and Europe.

The core datasets are presence-absence tables of key taxa (rice, millets, and various wild nuts) from Japan and Korea store in the CSV files [`SiteList_JP.csv`](https://github.com/ercrema/abot_JapanKorea/blob/main/data/SiteList_JP.csv) and [`SiteList_KOR.csv`](https://github.com/ercrema/abot_JapanKorea/blob/main/data/SiteList_KOR.csv). The Japanese dataset has been obtained by processing and partially translating (see [`prepareSiteList_JP`](https://github.com/ercrema/abot_JapanKorea/blob/main/data/prepareSiteList_JP.R) for details) data downloaded from the [Database of Plant Macrofossils from Archaeological Sites in Japan](https://www.rekihaku.ac.jp/up-cgi/login.pl?p=param/issi/db_param) contained in the data folder ([`jomon_abot.csv`](https://github.com/ercrema/abot_JapanKorea/blob/main/data/jomon_abot.csv),[`yayoi_abot.csv`](https://github.com/ercrema/abot_JapanKorea/blob/main/data/yayoi_abot.csv),[`kofun_abot.csv`](https://github.com/ercrema/abot_JapanKorea/blob/main/data/kofun_abot.csv), and [`kodai_abot.csv`](https://github.com/ercrema/abot_JapanKorea/blob/main/data/kodai_abot.csv)). The Korean dataset was manually compiled by CJ Stevens from the ["The Archaeobotanical Data in East Asia: Prehistoric Age"](https://portal.nrich.go.kr/kor/originalUsrView.do?menuIdx=565&info_idx=2036&bunya_cd=408).
The file [`log.R`](https://github.com/ercrema/abot_JapanKorea/blob/main/log.R) contains the R scripts for generatring figures X and Y (see [`figures`](https://github.com/ercrema/abot_JapanKorea/tree/main/figures) folder).



