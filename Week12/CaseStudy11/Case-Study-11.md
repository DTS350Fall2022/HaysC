---
title: "Case Study 11"
author: "Claire Hays"
date: "11/13/2022"
output: 
  html_document:
    keep_md: true
editor_options: 
  chunk_output_type: console
---




```r
library(tidyverse)
```

```
## ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.1 ──
```

```
## ✔ ggplot2 3.3.5     ✔ purrr   0.3.4
## ✔ tibble  3.1.8     ✔ dplyr   1.0.8
## ✔ tidyr   1.2.0     ✔ stringr 1.4.0
## ✔ readr   2.1.2     ✔ forcats 0.5.1
```

```
## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
## ✖ dplyr::filter() masks stats::filter()
## ✖ dplyr::lag()    masks stats::lag()
```

```r
library(knitr)
library(downloader)
library(dplyr)
library(lubridate)
```

```
## 
## Attaching package: 'lubridate'
```

```
## The following objects are masked from 'package:base':
## 
##     date, intersect, setdiff, union
```

```r
library(ggplot2)
library(grid)
library(corrplot)
```

```
## corrplot 0.92 loaded
```

```r
library(readr) 
library(haven)
library(readxl)
library(foreign)
library(stringr)
library(stringi)
library(tidyquant)
```

```
## Loading required package: PerformanceAnalytics
```

```
## Loading required package: xts
```

```
## Loading required package: zoo
```

```
## 
## Attaching package: 'zoo'
```

```
## The following objects are masked from 'package:base':
## 
##     as.Date, as.Date.numeric
```

```
## 
## Attaching package: 'xts'
```

```
## The following objects are masked from 'package:dplyr':
## 
##     first, last
```

```
## 
## Attaching package: 'PerformanceAnalytics'
```

```
## The following object is masked from 'package:graphics':
## 
##     legend
```

```
## Loading required package: quantmod
```

```
## Loading required package: TTR
```

```
## Registered S3 method overwritten by 'quantmod':
##   method            from
##   as.zoo.data.frame zoo
```

```r
library(timetk)
library(DT)
library(dygraphs)
library(sf)
```

```
## Linking to GEOS 3.10.2, GDAL 3.4.2, PROJ 8.2.1; sf_use_s2() is TRUE
```

```r
library(USAboundaries)
library(USAboundariesData)
library(ggsflabel)
```

```
## 
## Attaching package: 'ggsflabel'
```

```
## The following objects are masked from 'package:ggplot2':
## 
##     geom_sf_label, geom_sf_text, StatSfCoordinates
```

```r
library(maps)
```

```
## 
## Attaching package: 'maps'
```

```
## The following object is masked from 'package:purrr':
## 
##     map
```

```r
library(leaflet)
```

```
## 
## Attaching package: 'leaflet'
```

```
## The following object is masked from 'package:xts':
## 
##     addLegend
```

```r
library(mapview)
```


```r
temp <- tempfile()
download.file("https://github.com/WJC-Data-Science/DTS350/raw/master/permits.csv", "temp")
permits_dat <- read_csv("temp")
```

```
## New names:
## Rows: 327422 Columns: 8
## ── Column specification
## ──────────────────────────────────────────────────────── Delimiter: "," chr
## (3): StateAbbr, countyname, variable dbl (5): ...1, state, county, year, value
## ℹ Use `spec()` to retrieve the full column specification for this data. ℹ
## Specify the column types or set `show_col_types = FALSE` to quiet this message.
## • `` -> `...1`
```

```r
head(permits_dat)
```

```
## # A tibble: 6 × 8
##    ...1 state StateAbbr county countyname     variable     year value
##   <dbl> <dbl> <chr>      <dbl> <chr>          <chr>       <dbl> <dbl>
## 1     1     1 AL             1 Autauga County All Permits  2010   191
## 2     2     1 AL             1 Autauga County All Permits  2009   110
## 3     3     1 AL             1 Autauga County All Permits  2008   173
## 4     4     1 AL             1 Autauga County All Permits  2007   260
## 5     5     1 AL             1 Autauga County All Permits  2006   347
## 6     6     1 AL             1 Autauga County All Permits  2005   313
```

```r
penn <- permits_dat %>%
  filter(StateAbbr == "PA",
         year == 2010) %>%
  group_by(countyname, county) %>%
  summarise(tot_value = sum(value))
```

```
## `summarise()` has grouped output by 'countyname'. You can override using the
## `.groups` argument.
```

```r
head(penn)
```

```
## # A tibble: 6 × 3
## # Groups:   countyname [6]
##   countyname       county tot_value
##   <chr>             <dbl>     <dbl>
## 1 Adams County          1       634
## 2 Allegheny County      3      2865
## 3 Armstrong County      5       120
## 4 Beaver County         7       706
## 5 Bedford County        9       226
## 6 Berks County         11       895
```

```r
counties <- read_csv("PA_counties.csv")
```

```
## Rows: 68 Columns: 6
## ── Column specification ────────────────────────────────────────────────────────
## Delimiter: ","
## chr (3): County Name, County Code text, Georeferenced Latitude & Longitude
## dbl (3): County Code Number, Longitude, Latitude
## 
## ℹ Use `spec()` to retrieve the full column specification for this data.
## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
```

```r
colnames(counties)
```

```
## [1] "County Name"                        "County Code Number"                
## [3] "County Code text"                   "Longitude"                         
## [5] "Latitude"                           "Georeferenced Latitude & Longitude"
```

```r
names(counties)[names(counties) == "County Name"] <- "countyname"
names(counties)[names(counties) == "County Code Number"] <- "county"
head(counties)
```

```
## # A tibble: 6 × 6
##   countyname county `County Code text` Longitude Latitude `Georeferenced Latit…`
##   <chr>       <dbl> <chr>                  <dbl>    <dbl> <chr>                 
## 1 Adams           1 01                     -77.2     39.9 POINT (-77.22224271 3…
## 2 Allegheny       2 02                     -80.0     40.5 POINT (-79.98619843 4…
## 3 Armstrong       3 03                     -79.5     40.8 POINT (-79.47316899 4…
## 4 Beaver          4 04                     -80.4     40.7 POINT (-80.35107356 4…
## 5 Bedford         5 05                     -78.5     40.0 POINT (-78.49116474 4…
## 6 Berks           6 06                     -75.9     40.4 POINT (-75.93077327 4…
```

```r
dat <- counties %>% 
  right_join(penn, counties, by = "county") %>%
  arrange(desc(tot_value)) %>%
  drop_na()

head(dat)
```

```
## # A tibble: 6 × 8
##   countyname.x   county `County Code text` Longitude Latitude `Georeferenced L…`
##   <chr>           <dbl> <chr>                  <dbl>    <dbl> <chr>             
## 1 Armstrong           3 03                     -79.5     40.8 POINT (-79.473168…
## 2 Fulton             29 29                     -78.1     39.9 POINT (-78.114850…
## 3 Lycoming           41 41                     -77.1     41.3 POINT (-77.069424…
## 4 Mercer             43 43                     -80.3     41.3 POINT (-80.260094…
## 5 Northumberland     49 49                     -76.7     40.9 POINT (-76.711884…
## 6 Snyder             55 55                     -77.1     40.8 POINT (-77.072559…
## # … with 2 more variables: countyname.y <chr>, tot_value <dbl>
```


```r
dat$quartiles <- cut(dat$tot_value, quantile(dat$tot_value), include.lowest = TRUE, labels = FALSE)
head(dat)
```

```
## # A tibble: 6 × 9
##   countyname.x   county `County Code text` Longitude Latitude `Georeferenced L…`
##   <chr>           <dbl> <chr>                  <dbl>    <dbl> <chr>             
## 1 Armstrong           3 03                     -79.5     40.8 POINT (-79.473168…
## 2 Fulton             29 29                     -78.1     39.9 POINT (-78.114850…
## 3 Lycoming           41 41                     -77.1     41.3 POINT (-77.069424…
## 4 Mercer             43 43                     -80.3     41.3 POINT (-80.260094…
## 5 Northumberland     49 49                     -76.7     40.9 POINT (-76.711884…
## 6 Snyder             55 55                     -77.1     40.8 POINT (-77.072559…
## # … with 3 more variables: countyname.y <chr>, tot_value <dbl>, quartiles <int>
```

```r
top_penn_county <- dat %>%
      filter(row_number() == 1)

q1 <- dat %>%
  filter(quartiles == 1)
q2 <- dat %>%
  filter(quartiles == 2)
q3 <- dat %>%
  filter(quartiles == 3)
q4 <- dat %>%
  filter(quartiles == 4)
```


```r
PA_map <- leaflet() %>% 
  addTiles() %>%
  addCircleMarkers(
    data = q4,
    label = ~countyname.x,
    color = "red",
    popup = ~as.character(tot_value),
    fillOpacity = .5) %>%  
  addCircleMarkers(
    data = q3,
    label = ~countyname.x,
    color = "orange",
    popup = ~as.character(tot_value),
    fillOpacity = .5) %>% 
  addCircleMarkers(
    data = q2,
    label = ~countyname.x,
    color = "yellow",
    popup = ~as.character(tot_value),
    fillOpacity = .5) %>%
  addCircleMarkers(
    data = q1,
    label = ~countyname.x,
    color = "blue",
    popup = ~as.character(tot_value),
    fillOpacity = .5) %>% 
  addCircleMarkers(
    data = top_penn_county,
    label = ~countyname.x,
    color = "green",
    popup = ~as.character(tot_value),
    fillOpacity = .5)
```

```
## Assuming "Longitude" and "Latitude" are longitude and latitude, respectively
## Assuming "Longitude" and "Latitude" are longitude and latitude, respectively
## Assuming "Longitude" and "Latitude" are longitude and latitude, respectively
## Assuming "Longitude" and "Latitude" are longitude and latitude, respectively
## Assuming "Longitude" and "Latitude" are longitude and latitude, respectively
```

```r
PA_map
```

```{=html}
<div id="htmlwidget-e153a22dba3160fe9950" style="width:672px;height:480px;" class="leaflet html-widget"></div>
<script type="application/json" data-for="htmlwidget-e153a22dba3160fe9950">{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addTiles","args":["https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,null,{"minZoom":0,"maxZoom":18,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false,"attribution":"&copy; <a href=\"https://openstreetmap.org\">OpenStreetMap<\/a> contributors, <a href=\"https://creativecommons.org/licenses/by-sa/2.0/\">CC-BY-SA<\/a>"}]},{"method":"addCircleMarkers","args":[[40.81509526,39.92487511,41.34459792,41.30237777,40.85150926,40.77113737,41.04912086,41.000429],[-79.47316899,-78.11485045,-77.06942457,-80.26009411,-76.71188423,-77.07255968,-76.4100218,-78.47558343],10,null,null,{"interactive":true,"className":"","stroke":true,"color":"red","weight":5,"opacity":0.5,"fill":true,"fillColor":"red","fillOpacity":0.5},null,null,["2865","2497","1876","1467","1389","1197","1106","978"],null,["Armstrong","Fulton","Lycoming","Mercer","Northumberland","Snyder","Columbia","Clearfield"],{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"className":"","sticky":true},null]},{"method":"addCircleMarkers","args":[[41.51357876,40.49127491,41.06091787,40.48555024,39.87209565,40.00444354,40.91936701,39.97487056],[-79.23780995,-78.71894174,-75.34083603,-78.34907687,-77.22224271,-75.140236,-75.71107039,-75.75626498],10,null,null,{"interactive":true,"className":"","stroke":true,"color":"orange","weight":5,"opacity":0.5,"fill":true,"fillColor":"orange","fillOpacity":0.5},null,null,["931","895","735","706","634","488","365","354"],null,["Forest","Cambria","Monroe","Blair","Adams","Philadelphia","Carbon","Chester"],{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"className":"","sticky":true},null]},{"method":"addCircleMarkers","args":[[41.99413787,41.13139091,40.99325035,40.16759839,40.61464794,40.33501133,41.40341259,40.19109663],[-80.0407591,-79.00101814,-80.33754114,-77.26866271,-75.60099481,-75.11291241,-79.76286561,-80.25180083],10,null,null,{"interactive":true,"className":"","stroke":true,"color":"yellow","weight":5,"opacity":0.5,"fill":true,"fillColor":"yellow","fillOpacity":0.5},null,null,["298","248","246","234","228","226","204","190"],null,["Erie","Jefferson","Lawrence","Cumberland","Lehigh","Bucks","Venango","Washington"],{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"className":"","sticky":true},null]},{"method":"addCircleMarkers","args":[[40.310315,40.00737536,40.416105,41.77333834,39.92192531,41.02801824,41.43910064,41.4480994,41.74420644],[-79.47134118,-78.49116474,-77.9827661,-77.25788076,-76.72576052,-76.66470527,-75.61218345,-76.5147922,-77.89879229],10,null,null,{"interactive":true,"className":"","stroke":true,"color":"blue","weight":5,"opacity":0.5,"fill":true,"fillColor":"blue","fillOpacity":0.5},null,null,["186","120","94","82","82","72","62","48","20"],null,["Westmoreland","Bedford","Huntingdon","Tioga","York","Montour","Lackawanna","Sullivan","Potter"],{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"className":"","sticky":true},null]},{"method":"addCircleMarkers","args":[40.81509526,-79.47316899,10,null,null,{"interactive":true,"className":"","stroke":true,"color":"green","weight":5,"opacity":0.5,"fill":true,"fillColor":"green","fillOpacity":0.5},null,null,"2865",null,"Armstrong",{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"className":"","sticky":true},null]}],"limits":{"lat":[39.87209565,41.99413787],"lng":[-80.33754114,-75.11291241]}},"evals":[],"jsHooks":[]}</script>
```

```r
head(dat)
```

```
## # A tibble: 6 × 9
##   countyname.x   county `County Code text` Longitude Latitude `Georeferenced L…`
##   <chr>           <dbl> <chr>                  <dbl>    <dbl> <chr>             
## 1 Armstrong           3 03                     -79.5     40.8 POINT (-79.473168…
## 2 Fulton             29 29                     -78.1     39.9 POINT (-78.114850…
## 3 Lycoming           41 41                     -77.1     41.3 POINT (-77.069424…
## 4 Mercer             43 43                     -80.3     41.3 POINT (-80.260094…
## 5 Northumberland     49 49                     -76.7     40.9 POINT (-76.711884…
## 6 Snyder             55 55                     -77.1     40.8 POINT (-77.072559…
## # … with 3 more variables: countyname.y <chr>, tot_value <dbl>, quartiles <int>
```
This interactive map shows us that the best county (in regrards to housing permits) is Armstrong (green).  In regards to the other counties, the top quartile is blue, the second quartile is yellow, the third quartile is orange, and the worst/bottom quartile is red.  I would reccomend my friend to move to following counties such as Potter, Tiago, Westmoreland, Bedford, Huntingdon, York, Montour, Sullivan, and Lackawanna.  
