# Data and Scripts for the manuscript "The impotance of wild resources as a reflection of the resilience and changing nature of early agricultural systems in East Asia and Europe"

This repository contains data and scripts required for generating figures 2, 3, and 4 in the following manuscript:

Stevens, C.J., Shoda, S., Crema, E.R (2022). The impotance of wild resources as a reflection of the resilience and changing nature of early agricultural systems in East Asia and Europe.

For East Asia, the core datasets are presence-absence tables of key taxa (rice, millets, and various wild nuts) from Japan and Korea stored in the CSV files [`SiteList_JP.csv`](https://github.com/ercrema/abot_JapanKorea/blob/main/data/SiteList_JP.csv) and [`SiteList_KOR.csv`](https://github.com/ercrema/abot_JapanKorea/blob/main/data/SiteList_KOR.csv). The Japanese dataset has been obtained by processing and partially translating (see [`prepareSiteList_JP`](https://github.com/ercrema/abot_JapanKorea/blob/main/data/prepareSiteList_JP.R) for details) data downloaded from the [Database of Plant Macrofossils from Archaeological Sites in Japan](https://www.rekihaku.ac.jp/up-cgi/login.pl?p=param/issi/db_param) contained in the `data` folder ([`yayoi_abot.csv`](https://github.com/ercrema/abot_JapanKorea/blob/main/data/yayoi_abot.csv),[`kofun_abot.csv`](https://github.com/ercrema/abot_JapanKorea/blob/main/data/kofun_abot.csv), and [`kodai_abot.csv`](https://github.com/ercrema/abot_JapanKorea/blob/main/data/kodai_abot.csv)). The Korean dataset was manually compiled by CJ Stevens from the ["The Archaeobotanical Data in East Asia: Prehistoric Age"](https://portal.nrich.go.kr/kor/originalUsrView.do?menuIdx=565&info_idx=2036&bunya_cd=408).
The file [`presence_absence.R`](https://github.com/ercrema/abot_JapanKorea/blob/main/presence_absence.R) contains the R scripts for generatring figures 2 (`korea_abot.pdf`) and 3 (`japan_abot.pdf`) (see files in the [`figures`](https://github.com/ercrema/abot_JapanKorea/tree/main/figures) folder).

SPD analyses for figure 4 was based on a renalyses of the dataset from [Bevan et al 2017](https://doi.org/10.1073/pnas.1709190114), downloaded from the [associated data repository](https://discovery.ucl.ac.uk/id/eprint/10025178/) hosted on UCL discovery. The file [`spd.R`](https://github.com/ercrema/Stevens_etal_2022/blob/main/spd.R) contains all the script necessary for downloading, processing, analysing, and plotting the relevant dataset for generating figure 4 (see `spd_gb.pdf` in the [`figures`](https://github.com/ercrema/abot_JapanKorea/tree/main/figures) folder).


# Required R packages
```
attached base packages:
[1] stats     graphics  grDevices utils     datasets  methods   base     

other attached packages:
[1] dplyr_1.0.9         RColorBrewer_1.1-3  rnaturalearth_0.1.0
[4] sf_1.0-8            rcarbon_1.4.4      

loaded via a namespace (and not attached):
 [1] spatstat.linnet_2.3-2 tidyselect_1.1.2      xfun_0.31            
 [4] purrr_0.3.4           splines_4.2.1         lattice_0.20-45      
 [7] spatstat.utils_2.3-1  vctrs_0.4.1           generics_0.1.2       
[10] doSNOW_1.0.20         snow_0.4-4            mgcv_1.8-40          
[13] utf8_1.2.2            rlang_1.0.2           spatstat.data_2.2-0  
[16] e1071_1.7-11          pillar_1.7.0          spatstat_2.3-4       
[19] glue_1.6.2            DBI_1.1.2             sp_1.5-0             
[22] foreach_1.5.2         lifecycle_1.0.1       spatstat.core_2.4-4  
[25] codetools_0.2-18      knitr_1.39            parallel_4.2.1       
[28] class_7.3-20          fansi_1.0.3           Rcpp_1.0.8.3         
[31] KernSmooth_2.23-20    tensor_1.5            classInt_0.4-7       
[34] abind_1.4-5           deldir_1.0-6          spatstat.sparse_2.1-1
[37] polyclip_1.10-0       grid_4.2.1            cli_3.3.0            
[40] tools_4.2.1           magrittr_2.0.3        goftest_1.2-3        
[43] tibble_3.1.7          proxy_0.4-27          pkgconfig_2.0.3      
[46] crayon_1.5.1          ellipsis_0.3.2        spatstat.random_2.2-0
[49] Matrix_1.4-1          assertthat_0.2.1      iterators_1.0.14     
[52] R6_2.5.1              rpart_4.1.16          units_0.8-0          
[55] spatstat.geom_2.4-0   nlme_3.1-157          compiler_4.2.1 
```

# Funding
This research was funded by the ERC grant _Demography, Cultural Change, and the Diffusion of Rice and Millets during the Jomon-Yayoi transition in prehistoric Japan (ENCOUNTER)_ (Project N. 801953, PI: Enrico Crema) and by a Philip Leverhulme Prize (PLP-2019-304) in archaeology awarded to Enrico Crema.

# Licence
CC-BY 3.0

