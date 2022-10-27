---
title: "Case Study 8"
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
```


```r
sales_dat <- tempfile()
download("https://github.com/WJC-Data-Science/DTS350/raw/master/sales.csv", sales_dat, mode = "wb")
dat <- read_csv(sales_dat)
```

```
## Rows: 15656 Columns: 4
## ── Column specification ────────────────────────────────────────────────────────
## Delimiter: ","
## chr  (2): Name, Type
## dbl  (1): Amount
## dttm (1): Time
## 
## ℹ Use `spec()` to retrieve the full column specification for this data.
## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
```

```r
head(dat)
```

```
## # A tibble: 6 × 4
##   Name       Type           Time                Amount
##   <chr>      <chr>          <dttm>               <dbl>
## 1 Tacontento Food(prepared) 2016-05-16 19:01:00    3  
## 2 Tacontento Food(prepared) 2016-05-16 19:01:00    1.5
## 3 Tacontento Food(prepared) 2016-05-16 19:04:00    3  
## 4 Tacontento Food(prepared) 2016-05-16 19:04:00    3  
## 5 Tacontento Food(prepared) 2016-05-16 19:04:00    1.5
## 6 Tacontento Food(prepared) 2016-05-16 19:04:00    1
```

```r
str(dat)
```

```
## spec_tbl_df [15,656 × 4] (S3: spec_tbl_df/tbl_df/tbl/data.frame)
##  $ Name  : chr [1:15656] "Tacontento" "Tacontento" "Tacontento" "Tacontento" ...
##  $ Type  : chr [1:15656] "Food(prepared)" "Food(prepared)" "Food(prepared)" "Food(prepared)" ...
##  $ Time  : POSIXct[1:15656], format: "2016-05-16 19:01:00" "2016-05-16 19:01:00" ...
##  $ Amount: num [1:15656] 3 1.5 3 3 1.5 1 3 3 1.5 3 ...
##  - attr(*, "spec")=
##   .. cols(
##   ..   Name = col_character(),
##   ..   Type = col_character(),
##   ..   Time = col_datetime(format = ""),
##   ..   Amount = col_double()
##   .. )
##  - attr(*, "problems")=<externalptr>
```

```r
summary(dat)
```

```
##      Name               Type                Time                    
##  Length:15656       Length:15656       Min.   :2016-04-20 19:01:00  
##  Class :character   Class :character   1st Qu.:2016-05-31 19:46:00  
##  Mode  :character   Mode  :character   Median :2016-06-15 17:16:00  
##                                        Mean   :2016-06-16 05:58:39  
##                                        3rd Qu.:2016-07-02 00:30:00  
##                                        Max.   :2016-07-20 15:53:00  
##      Amount        
##  Min.   :-194.500  
##  1st Qu.:   2.500  
##  Median :   3.000  
##  Mean   :   5.294  
##  3rd Qu.:   4.500  
##  Max.   :1026.000
```


```r
sales <- with_tz(dat, tzone = "US/Mountain")
```


```r
sales_time <- sales %>%
  mutate(Month = month(Time, label = TRUE, abbr = FALSE)) %>%
  mutate(Week = week(Time)) %>%
  mutate(Day = wday(Time, label = TRUE, abbr = FALSE)) %>%
  mutate(Hour = hour(Time)) 

head(sales_time)
```

```
## # A tibble: 6 × 8
##   Name       Type           Time                Amount Month  Week Day     Hour
##   <chr>      <chr>          <dttm>               <dbl> <ord> <dbl> <ord>  <int>
## 1 Tacontento Food(prepared) 2016-05-16 13:01:00    3   May      20 Monday    13
## 2 Tacontento Food(prepared) 2016-05-16 13:01:00    1.5 May      20 Monday    13
## 3 Tacontento Food(prepared) 2016-05-16 13:04:00    3   May      20 Monday    13
## 4 Tacontento Food(prepared) 2016-05-16 13:04:00    3   May      20 Monday    13
## 5 Tacontento Food(prepared) 2016-05-16 13:04:00    1.5 May      20 Monday    13
## 6 Tacontento Food(prepared) 2016-05-16 13:04:00    1   May      20 Monday    13
```

```r
tail(sales_time)
```

```
## # A tibble: 6 × 8
##   Name    Type               Time                Amount Month  Week Day     Hour
##   <chr>   <chr>              <dttm>               <dbl> <ord> <dbl> <ord>  <int>
## 1 Frozone Food(pre-packaged) 2016-07-09 17:58:00   5    July     28 Satur…    17
## 2 Frozone Food(pre-packaged) 2016-07-09 18:33:00   5    July     28 Satur…    18
## 3 Frozone Food(pre-packaged) 2016-07-09 18:37:00   5    July     28 Satur…    18
## 4 Frozone Food(pre-packaged) 2016-07-09 18:47:00   5    July     28 Satur…    18
## 5 Missing Missing            2016-06-17 15:12:00 150    June     25 Friday    15
## 6 Missing Missing            2016-04-20 13:01:00  -3.07 April    16 Wedne…    13
```

```r
summary(sales_time)
```

```
##      Name               Type                Time                    
##  Length:15656       Length:15656       Min.   :2016-04-20 13:01:00  
##  Class :character   Class :character   1st Qu.:2016-05-31 13:46:00  
##  Mode  :character   Mode  :character   Median :2016-06-15 11:16:00  
##                                        Mean   :2016-06-15 23:58:39  
##                                        3rd Qu.:2016-07-01 18:30:00  
##                                        Max.   :2016-07-20 09:53:00  
##                                                                     
##      Amount              Month           Week              Day      
##  Min.   :-194.500   June    :7467   Min.   :16.00   Sunday   :   3  
##  1st Qu.:   2.500   July    :4219   1st Qu.:22.00   Monday   :2221  
##  Median :   3.000   May     :3968   Median :24.00   Tuesday  :2516  
##  Mean   :   5.294   April   :   2   Mean   :24.31   Wednesday:3072  
##  3rd Qu.:   4.500   January :   0   3rd Qu.:27.00   Thursday :3200  
##  Max.   :1026.000   February:   0   Max.   :29.00   Friday   :4491  
##                     (Other) :   0                   Saturday : 153  
##       Hour     
##  Min.   : 0.0  
##  1st Qu.:11.0  
##  Median :12.0  
##  Mean   :12.8  
##  3rd Qu.:13.0  
##  Max.   :23.0  
## 
```


```r
HOURS <- sales_time %>%
  group_by(Name, Hour) %>%
  select(Name, Amount, Hour) %>%
  ggplot(aes(x=Hour, y=Amount, Color=Name)) +
  geom_col() +
  facet_wrap(~Name) +
  labs(title = "Amount Sold per Hour for Each Store",
       x = "Hour of Day",
       y = "Amount Sold") +
  theme_bw()


DAYS <- sales_time %>%
  group_by(Name, Day) %>%
  select(Name, Amount, Day) %>%
  ggplot(aes(x=Day, y=Amount, Color=Name)) +
  geom_col() +
  facet_wrap(~Name) +
  labs(title = "Amount Sold per Day of Week for Each Store",
       x = "Day of Week",
       y = "Amount Sold") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))


MONTHS <- sales_time %>%
  group_by(Name, Month) %>%
  select(Name, Amount, Month) %>%
  ggplot(aes(x=Month, y=Amount, Color=Name)) +
  geom_col() +
  facet_wrap(~Name) +
  labs(title = "Amount Sold per Month for Each Store",
       x = "Month",
       y = "Amount Sold") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))
```
I would recommend hours of operation be between 8am and 9pm, with customer traffic being the busiest between 10am and 4pm for just about every restaruant.  I also reccomend operating during the weekdays.  Weekend sales are low amongst all stores.  We are only comparing a few months of the year, but it does appear the June is the busiest month for almost all the sotres (except LeBelle). 


```r
COMPARE <- sales_time %>%
  group_by(Name) %>%
  ggplot(aes(x=Name, y=Amount, Color=Name)) +
  geom_col() +
  labs(title = "Sales Across All Stores",
       x = " ",
       y = "Sales") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))
```

I reccomend waiting to open Frozone until June.
