---
title: "Task 15"
author: "Claire Hays"
date: "10/25/2022"
output: 
  html_document:
    theme: cosmo
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
## ✔ tibble  3.1.6     ✔ dplyr   1.0.8
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
library(COR)
library(readr) 
library(haven)
library(readxl)
library(foreign)
library(stringr)
library(stringi)
library(riem)
library(plotly)
```

```
## 
## Attaching package: 'plotly'
```

```
## The following object is masked from 'package:ggplot2':
## 
##     last_plot
```

```
## The following object is masked from 'package:stats':
## 
##     filter
```

```
## The following object is masked from 'package:graphics':
## 
##     layout
```


```r
carwash_dat <- tempfile()
download("https://github.com/WJC-Data-Science/DTS350/raw/master/carwash.csv", carwash_dat, mode = "wb")
dat <- read_csv(carwash_dat)
```

```
## Rows: 533 Columns: 4
## ── Column specification ────────────────────────────────────────────────────────
## Delimiter: ","
## chr  (2): name, type
## dbl  (1): amount
## dttm (1): time
## 
## ℹ Use `spec()` to retrieve the full column specification for this data.
## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
```

```r
head(dat)
```

```
## # A tibble: 6 × 4
##   name          type     time                amount
##   <chr>         <chr>    <dttm>               <dbl>
## 1 SplashandDash Services 2016-05-13 20:27:00    1  
## 2 SplashandDash Services 2016-05-13 20:27:00    0  
## 3 SplashandDash Services 2016-05-16 19:31:00   23.6
## 4 SplashandDash Services 2016-05-16 17:09:00   18.9
## 5 SplashandDash Services 2016-05-16 17:47:00   23.6
## 6 SplashandDash Services 2016-05-16 17:50:00   23.6
```

```r
tail(dat)
```

```
## # A tibble: 6 × 4
##   name          type     time                amount
##   <chr>         <chr>    <dttm>               <dbl>
## 1 SplashandDash Services 2016-07-08 18:36:00   50  
## 2 SplashandDash Services 2016-07-08 18:50:00   30  
## 3 SplashandDash Services 2016-07-08 21:29:00  -33.6
## 4 SplashandDash Services 2016-07-08 22:42:00   10  
## 5 SplashandDash Services 2016-07-08 22:51:00   15  
## 6 SplashandDash Services 2016-07-08 23:08:00    5
```

```r
summary(dat)
```

```
##      name               type                time                    
##  Length:533         Length:533         Min.   :2016-05-13 20:27:00  
##  Class :character   Class :character   1st Qu.:2016-05-31 15:56:00  
##  Mode  :character   Mode  :character   Median :2016-06-15 20:16:00  
##                                        Mean   :2016-06-15 14:19:11  
##                                        3rd Qu.:2016-06-30 22:18:00  
##                                        Max.   :2016-07-18 16:58:00  
##      amount       
##  Min.   :-130.00  
##  1st Qu.:  15.00  
##  Median :  20.00  
##  Mean   :  25.19  
##  3rd Qu.:  30.00  
##  Max.   : 350.00
```


```r
dat <- with_tz(dat, tzone = "US/Mountain")
```


```r
dat_hours <- dat %>%
  mutate(hour = ceiling_date(time, "hour"))
```


```r
hourly_sales <- dat_hours %>%
  group_by(hour) %>%
  summarise(across(amount, sum))
```


```r
temps <- riem_measures(station = "RXE",  date_start ="2016-05-13", date_end  ="2016-07-08")
summary(temps)
```

```
##    station              valid                          lon        
##  Length:17448       Min.   :2016-05-13 00:00:00   Min.   :-111.8  
##  Class :character   1st Qu.:2016-05-26 20:28:45   1st Qu.:-111.8  
##  Mode  :character   Median :2016-06-09 19:54:00   Median :-111.8  
##                     Mean   :2016-06-09 21:26:54   Mean   :-111.8  
##                     3rd Qu.:2016-06-23 20:46:15   3rd Qu.:-111.8  
##                     Max.   :2016-07-07 23:55:00   Max.   :-111.8  
##                                                                   
##       lat             tmpf            dwpf            relh      
##  Min.   :43.83   Min.   :33.98   Min.   :17.06   Min.   :10.14  
##  1st Qu.:43.83   1st Qu.:50.00   1st Qu.:35.96   1st Qu.:31.84  
##  Median :43.83   Median :60.08   Median :40.46   Median :49.38  
##  Mean   :43.83   Mean   :61.16   Mean   :40.05   Mean   :51.53  
##  3rd Qu.:43.83   3rd Qu.:71.06   3rd Qu.:44.06   3rd Qu.:70.52  
##  Max.   :43.83   Max.   :91.40   Max.   :55.04   Max.   :96.66  
##                  NA's   :16029   NA's   :16100   NA's   :16100  
##       drct            sknt            p01i            alti      
##  Min.   :  0.0   Min.   : 0.00   Min.   :0.000   Min.   :29.62  
##  1st Qu.: 50.0   1st Qu.: 4.00   1st Qu.:0.000   1st Qu.:29.93  
##  Median :190.0   Median : 6.00   Median :0.000   Median :30.04  
##  Mean   :144.6   Mean   : 7.03   Mean   :0.007   Mean   :30.04  
##  3rd Qu.:220.0   3rd Qu.:10.00   3rd Qu.:0.000   3rd Qu.:30.13  
##  Max.   :360.0   Max.   :27.00   Max.   :0.170   Max.   :30.38  
##  NA's   :205     NA's   :144     NA's   :15729   NA's   :4      
##       mslp            vsby             gust          skyc1          
##  Min.   :1001    Min.   : 1.250   Min.   :14.00   Length:17448      
##  1st Qu.:1010    1st Qu.:10.000   1st Qu.:17.00   Class :character  
##  Median :1014    Median :10.000   Median :19.00   Mode  :character  
##  Mean   :1014    Mean   : 9.952   Mean   :20.36                     
##  3rd Qu.:1017    3rd Qu.:10.000   3rd Qu.:22.00                     
##  Max.   :1025    Max.   :10.000   Max.   :39.00                     
##  NA's   :16181   NA's   :376      NA's   :16495                     
##     skyc2              skyc3            skyc4             skyl1      
##  Length:17448       Length:17448       Mode:logical   Min.   :  500  
##  Class :character   Class :character   NA's:17448     1st Qu.: 5500  
##  Mode  :character   Mode  :character                  Median : 8000  
##                                                       Mean   : 7622  
##                                                       3rd Qu.:10000  
##                                                       Max.   :12000  
##                                                       NA's   :12725  
##      skyl2           skyl3        skyl4           wxcodes         
##  Min.   : 1100   Min.   : 2400   Mode:logical   Length:17448      
##  1st Qu.: 4700   1st Qu.: 5500   NA's:17448     Class :character  
##  Median : 7500   Median : 8000                  Mode  :character  
##  Mean   : 7057   Mean   : 7786                                    
##  3rd Qu.: 9000   3rd Qu.:10000                                    
##  Max.   :12000   Max.   :12000                                    
##  NA's   :15820   NA's   :16718                                    
##  ice_accretion_1hr ice_accretion_3hr ice_accretion_6hr peak_wind_gust 
##  Mode:logical      Mode:logical      Mode:logical      Min.   :26     
##  NA's:17448        NA's:17448        NA's:17448        1st Qu.:27     
##                                                        Median :28     
##                                                        Mean   :29     
##                                                        3rd Qu.:32     
##                                                        Max.   :35     
##                                                        NA's   :17407  
##  peak_wind_drct  peak_wind_time          feel          metar          
##  Min.   :170.0   Length:17448       Min.   :29.73   Length:17448      
##  1st Qu.:210.0   Class :character   1st Qu.:51.08   Class :character  
##  Median :220.0   Mode  :character   Median :60.08   Mode  :character  
##  Mean   :218.5                      Mean   :59.79                     
##  3rd Qu.:240.0                      3rd Qu.:69.81                     
##  Max.   :260.0                      Max.   :86.85                     
##  NA's   :17407                      NA's   :16100                     
##  snowdepth     
##  Mode:logical  
##  NA's:17448    
##                
##                
##                
##                
## 
```

```r
temperatures <- temps %>%
  with_tz(tzone = "US/Mountain") %>%
  mutate(hour = ceiling_date(valid, "hour")) %>%
  drop_na(tmpf) %>%
  filter(tmpf != " ") %>%
  select(hour, tmpf)
```


```r
merged <- merge(temperatures, hourly_sales, by = "hour")
```


```r
new_dat <- merged %>%
  mutate(hour = hour(hour)) %>%
  group_by(hour) %>%
  select(hour, tmpf, amount) %>%
  ggplot(aes(x=tmpf, y=amount, color=hour)) +
  geom_point() +
  facet_wrap(~hour) +
  labs(title = "Relationship Between Sales and Temperature",
       x = "Temperature",
       y = "Sales") +
  theme_bw() 
```

