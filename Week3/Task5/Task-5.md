---
title: "Task 5"
author: "Claire Hays"
date: "9/12/2022"
output: 
  html_document:
    theme: cosmo
    keep_md: true
    code_following: 'hide'
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
## ✓ ggplot2 3.3.5     ✓ purrr   0.3.4
## ✓ tibble  3.1.6     ✓ dplyr   1.0.8
## ✓ tidyr   1.2.0     ✓ stringr 1.4.0
## ✓ readr   2.1.2     ✓ forcats 0.5.1
```

```
## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
## x dplyr::filter() masks stats::filter()
## x dplyr::lag()    masks stats::lag()
```

```r
library(knitr)
library(downloader)
```


The data seemed to read in correctly as characters

```r
SoloData <- read_csv("solo-artist-followers.csv")
```

```
## Rows: 139 Columns: 5
## ── Column specification ────────────────────────────────────────────────────────
## Delimiter: ","
## chr (5): name, band, followers, band_followers, follower_difference
## 
## ℹ Use `spec()` to retrieve the full column specification for this data.
## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
```

```r
SoloData
```

```
## # A tibble: 139 × 5
##    name              band              followers band_followers follower_differ…
##    <chr>             <chr>             <chr>     <chr>          <chr>           
##  1 Daron Jones       112               1.28k     783k           −782k           
##  2 Slim              112               2.14k     783k           −781k           
##  3 Q Parker          112               3.51k     783k           −780k           
##  4 JC Chasez         *NSYNC            30.8k     1.44M          −1.41M          
##  5 Joey Fatone       *NSYNC            1.13k     1.44M          −1.44M          
##  6 Justin Timberlake *NSYNC            10.3M     1.44M          8.90M           
##  7 Ashton Irwin      5 Seconds of Sum… 130k      7.14M          −7.01M          
##  8 Abz Love          5ive              223       19.0k          −18.7k          
##  9 Jeff Timmons      98º               111       302k           −302k           
## 10 Nick Lachey       98º               142k      302k           −160k           
## # … with 129 more rows
```

```r
str(SoloData)
```

```
## spec_tbl_df [139 × 5] (S3: spec_tbl_df/tbl_df/tbl/data.frame)
##  $ name               : chr [1:139] "Daron Jones" "Slim" "Q Parker" "JC Chasez" ...
##  $ band               : chr [1:139] "112" "112" "112" "*NSYNC" ...
##  $ followers          : chr [1:139] "1.28k" "2.14k" "3.51k" "30.8k" ...
##  $ band_followers     : chr [1:139] "783k" "783k" "783k" "1.44M" ...
##  $ follower_difference: chr [1:139] "−782k" "−781k" "−780k" "−1.41M" ...
##  - attr(*, "spec")=
##   .. cols(
##   ..   name = col_character(),
##   ..   band = col_character(),
##   ..   followers = col_character(),
##   ..   band_followers = col_character(),
##   ..   follower_difference = col_character()
##   .. )
##  - attr(*, "problems")=<externalptr>
```


The data seemed to read in correctly as characters, dates, and doubles.

```r
BillboardData <- read_csv("billboard-hits.csv")
```

```
## Rows: 456 Columns: 5
## ── Column specification ────────────────────────────────────────────────────────
## Delimiter: ","
## chr  (3): name, band, title
## dbl  (1): peak_rank
## date (1): peak_date
## 
## ℹ Use `spec()` to retrieve the full column specification for this data.
## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
```

```r
str(BillboardData)
```

```
## spec_tbl_df [456 × 5] (S3: spec_tbl_df/tbl_df/tbl/data.frame)
##  $ name     : chr [1:456] "*NSYNC" "*NSYNC" "*NSYNC" "*NSYNC" ...
##  $ band     : chr [1:456] NA NA NA NA ...
##  $ title    : chr [1:456] "It's Gonna Be Me" "Music Of My Heart" "Bye Bye Bye" "This I Promise You" ...
##  $ peak_date: Date[1:456], format: "2000-07-28" "1999-10-15" ...
##  $ peak_rank: num [1:456] 1 2 4 5 5 8 11 13 19 59 ...
##  - attr(*, "spec")=
##   .. cols(
##   ..   name = col_character(),
##   ..   band = col_character(),
##   ..   title = col_character(),
##   ..   peak_date = col_date(format = ""),
##   ..   peak_rank = col_double()
##   .. )
##  - attr(*, "problems")=<externalptr>
```

```r
head(BillboardData)
```

```
## # A tibble: 6 × 5
##   name   band  title                     peak_date  peak_rank
##   <chr>  <chr> <chr>                     <date>         <dbl>
## 1 *NSYNC <NA>  It's Gonna Be Me          2000-07-28         1
## 2 *NSYNC <NA>  Music Of My Heart         1999-10-15         2
## 3 *NSYNC <NA>  Bye Bye Bye               2000-04-14         4
## 4 *NSYNC <NA>  This I Promise You        2000-12-01         5
## 5 *NSYNC <NA>  Girlfriend                2002-04-05         5
## 6 *NSYNC <NA>  A Little More Time On You 1999-02-26         8
```


remover all singers who did not hit top 100 6 times and find the corresponding bands

```r
sixtopsingers <- BillboardData %>%
  group_by(name) %>%
  filter(n() > 6, band != "", !is.na(band))
head(sixtopsingers)
```

```
## # A tibble: 6 × 5
## # Groups:   name [1]
##   name              band   title                           peak_date  peak_rank
##   <chr>             <chr>  <chr>                           <date>         <dbl>
## 1 Justin Timberlake *NSYNC SexyBack                        2006-09-08         1
## 2 Justin Timberlake *NSYNC My Love                         2006-11-10         1
## 3 Justin Timberlake *NSYNC What Goes Around...Comes Around 2007-03-02         1
## 4 Justin Timberlake *NSYNC Can't Stop The Feeling!         2016-05-27         1
## 5 Justin Timberlake *NSYNC Mirrors                         2013-06-14         2
## 6 Justin Timberlake *NSYNC Cry Me A River                  2003-01-31         3
```

```r
sixtopbands <- BillboardData %>%
  group_by(band) %>%
  filter(band %in% sixtopsingers$band)
head(sixtopbands)
```

```
## # A tibble: 6 × 5
## # Groups:   band [1]
##   name              band   title                           peak_date  peak_rank
##   <chr>             <chr>  <chr>                           <date>         <dbl>
## 1 JC Chasez         *NSYNC Blowin' Me Up                   2003-02-28        35
## 2 JC Chasez         *NSYNC Some Girls                      2004-02-13        88
## 3 Justin Timberlake *NSYNC SexyBack                        2006-09-08         1
## 4 Justin Timberlake *NSYNC My Love                         2006-11-10         1
## 5 Justin Timberlake *NSYNC What Goes Around...Comes Around 2007-03-02         1
## 6 Justin Timberlake *NSYNC Can't Stop The Feeling!         2016-05-27         1
```


recronstruct the plot from task 5
oberservations:
In general, bands have alot of ups and downs.  Destiny's Child specifically shows a steady up, down, up, down, fluctuation over the years.  Tje Jonas brothers has a high peak around 2010 and then had a hard hit for several years (were the producing any songs then?), but then they had a few more succesfull songs in 2015 and 2017.    

```r
ggplot(data = sixtopsingers, aes(x = peak_date, y = peak_rank, color = name, group = name)) +
  geom_point() +
  geom_line() +
  geom_point(data = sixtopbands, color ="black") +
  geom_line(data = sixtopbands, color = "black", linetype = "dotted") +
  facet_wrap(~ band, scales = "free") +
  xlab("peak_date") + ylab("peak_rank") +
  theme_bw() 
```

![](Task-5_files/figure-html/unnamed-chunk-5-1.png)<!-- -->


Data comes from this source:
https://www.fbi.gov/services/cjis/nics

This source is realiable (FBI) information about Background Checks
All data read in as characters or column_doubles.

```r
FireArmDat <- read_csv("nics-firearm-background-checks.csv")
```

```
## Rows: 15730 Columns: 27
## ── Column specification ────────────────────────────────────────────────────────
## Delimiter: ","
## chr  (2): month, state
## dbl (25): permit, permit_recheck, handgun, long_gun, other, multiple, admin,...
## 
## ℹ Use `spec()` to retrieve the full column specification for this data.
## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
```

```r
FireArmDat
```

```
## # A tibble: 15,730 × 27
##    month   state     permit permit_recheck handgun long_gun other multiple admin
##    <chr>   <chr>      <dbl>          <dbl>   <dbl>    <dbl> <dbl>    <dbl> <dbl>
##  1 2022-08 Alabama    20271            326   18400    13679  1315     1074     0
##  2 2022-08 Alaska       291             16    3225     3005   373      208     0
##  3 2022-08 Arizona     8278           2029   19079     9304  1947     1239     0
##  4 2022-08 Arkansas    2585            334    6885     5697   516      427    14
##  5 2022-08 Californ…  39274          14674   39236    25005  5743        0     0
##  6 2022-08 Colorado    7271            128   20557    13165  1812     1766     0
##  7 2022-08 Connecti…   9417            689    4111     1347   874        0     1
##  8 2022-08 Delaware     490              0    1913      910   104       71     0
##  9 2022-08 District…   1102              0     491       18     0       12     3
## 10 2022-08 Florida    20897              0   60229    22654  5518     3159     0
## # … with 15,720 more rows, and 18 more variables: prepawn_handgun <dbl>,
## #   prepawn_long_gun <dbl>, prepawn_other <dbl>, redemption_handgun <dbl>,
## #   redemption_long_gun <dbl>, redemption_other <dbl>, returned_handgun <dbl>,
## #   returned_long_gun <dbl>, returned_other <dbl>, rentals_handgun <dbl>,
## #   rentals_long_gun <dbl>, private_sale_handgun <dbl>,
## #   private_sale_long_gun <dbl>, private_sale_other <dbl>,
## #   return_to_seller_handgun <dbl>, return_to_seller_long_gun <dbl>, …
```

```r
str(FireArmDat)
```

```
## spec_tbl_df [15,730 × 27] (S3: spec_tbl_df/tbl_df/tbl/data.frame)
##  $ month                    : chr [1:15730] "2022-08" "2022-08" "2022-08" "2022-08" ...
##  $ state                    : chr [1:15730] "Alabama" "Alaska" "Arizona" "Arkansas" ...
##  $ permit                   : num [1:15730] 20271 291 8278 2585 39274 ...
##  $ permit_recheck           : num [1:15730] 326 16 2029 334 14674 ...
##  $ handgun                  : num [1:15730] 18400 3225 19079 6885 39236 ...
##  $ long_gun                 : num [1:15730] 13679 3005 9304 5697 25005 ...
##  $ other                    : num [1:15730] 1315 373 1947 516 5743 ...
##  $ multiple                 : num [1:15730] 1074 208 1239 427 0 ...
##  $ admin                    : num [1:15730] 0 0 0 14 0 0 1 0 3 0 ...
##  $ prepawn_handgun          : num [1:15730] 15 2 7 8 0 0 0 0 0 6 ...
##  $ prepawn_long_gun         : num [1:15730] 11 0 7 9 1 0 0 0 0 7 ...
##  $ prepawn_other            : num [1:15730] 2 1 0 0 0 0 0 0 0 3 ...
##  $ redemption_handgun       : num [1:15730] 2428 107 1214 1145 863 ...
##  $ redemption_long_gun      : num [1:15730] 933 111 453 869 418 0 0 4 0 921 ...
##  $ redemption_other         : num [1:15730] 12 2 5 2 55 0 0 0 0 6 ...
##  $ returned_handgun         : num [1:15730] 26 35 182 0 701 ...
##  $ returned_long_gun        : num [1:15730] 0 17 23 0 436 41 0 0 0 118 ...
##  $ returned_other           : num [1:15730] 0 0 2 0 82 2 0 0 18 7 ...
##  $ rentals_handgun          : num [1:15730] 0 0 0 0 0 0 0 0 0 0 ...
##  $ rentals_long_gun         : num [1:15730] 0 0 0 0 0 0 0 0 0 0 ...
##  $ private_sale_handgun     : num [1:15730] 28 4 12 7 7708 ...
##  $ private_sale_long_gun    : num [1:15730] 25 2 6 8 3463 ...
##  $ private_sale_other       : num [1:15730] 3 0 2 1 647 0 277 1 0 72 ...
##  $ return_to_seller_handgun : num [1:15730] 0 1 0 0 15 0 0 1 0 58 ...
##  $ return_to_seller_long_gun: num [1:15730] 1 0 0 1 19 0 0 0 0 41 ...
##  $ return_to_seller_other   : num [1:15730] 0 0 0 0 18 0 0 0 0 4 ...
##  $ totals                   : num [1:15730] 58549 7400 43789 18508 138358 ...
##  - attr(*, "spec")=
##   .. cols(
##   ..   month = col_character(),
##   ..   state = col_character(),
##   ..   permit = col_double(),
##   ..   permit_recheck = col_double(),
##   ..   handgun = col_double(),
##   ..   long_gun = col_double(),
##   ..   other = col_double(),
##   ..   multiple = col_double(),
##   ..   admin = col_double(),
##   ..   prepawn_handgun = col_double(),
##   ..   prepawn_long_gun = col_double(),
##   ..   prepawn_other = col_double(),
##   ..   redemption_handgun = col_double(),
##   ..   redemption_long_gun = col_double(),
##   ..   redemption_other = col_double(),
##   ..   returned_handgun = col_double(),
##   ..   returned_long_gun = col_double(),
##   ..   returned_other = col_double(),
##   ..   rentals_handgun = col_double(),
##   ..   rentals_long_gun = col_double(),
##   ..   private_sale_handgun = col_double(),
##   ..   private_sale_long_gun = col_double(),
##   ..   private_sale_other = col_double(),
##   ..   return_to_seller_handgun = col_double(),
##   ..   return_to_seller_long_gun = col_double(),
##   ..   return_to_seller_other = col_double(),
##   ..   totals = col_double()
##   .. )
##  - attr(*, "problems")=<externalptr>
```


Data comes from this source:
https://fivethirtyeight.com/features/should-travelers-avoid-flying-airlines-that-have-had-crashes-in-the-past/

This source was recommended (fivethirtyeight) and has a link to github with all the data used.
All data came in as characters or column_doubles.

```r
AirSafety <- read_csv("airline-safety.csv")
```

```
## Rows: 56 Columns: 8
## ── Column specification ────────────────────────────────────────────────────────
## Delimiter: ","
## chr (1): airline
## dbl (7): avail_seat_km_per_week, incidents_85_99, fatal_accidents_85_99, fat...
## 
## ℹ Use `spec()` to retrieve the full column specification for this data.
## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
```

```r
AirSafety
```

```
## # A tibble: 56 × 8
##    airline    avail_seat_km_p… incidents_85_99 fatal_accidents… fatalities_85_99
##    <chr>                 <dbl>           <dbl>            <dbl>            <dbl>
##  1 Aer Lingus        320906734               2                0                0
##  2 Aeroflot*        1197672318              76               14              128
##  3 Aerolinea…        385803648               6                0                0
##  4 Aeromexic…        596871813               3                1               64
##  5 Air Canada       1865253802               2                0                0
##  6 Air France       3004002661              14                4               79
##  7 Air India*        869253552               2                1              329
##  8 Air New Z…        710174817               3                0                0
##  9 Alaska Ai…        965346773               5                0                0
## 10 Alitalia          698012498               7                2               50
## # … with 46 more rows, and 3 more variables: incidents_00_14 <dbl>,
## #   fatal_accidents_00_14 <dbl>, fatalities_00_14 <dbl>
```

```r
str(AirSafety)
```

```
## spec_tbl_df [56 × 8] (S3: spec_tbl_df/tbl_df/tbl/data.frame)
##  $ airline               : chr [1:56] "Aer Lingus" "Aeroflot*" "Aerolineas Argentinas" "Aeromexico*" ...
##  $ avail_seat_km_per_week: num [1:56] 3.21e+08 1.20e+09 3.86e+08 5.97e+08 1.87e+09 ...
##  $ incidents_85_99       : num [1:56] 2 76 6 3 2 14 2 3 5 7 ...
##  $ fatal_accidents_85_99 : num [1:56] 0 14 0 1 0 4 1 0 0 2 ...
##  $ fatalities_85_99      : num [1:56] 0 128 0 64 0 79 329 0 0 50 ...
##  $ incidents_00_14       : num [1:56] 0 6 1 5 2 6 4 5 5 4 ...
##  $ fatal_accidents_00_14 : num [1:56] 0 1 0 0 0 2 1 1 1 0 ...
##  $ fatalities_00_14      : num [1:56] 0 88 0 0 0 337 158 7 88 0 ...
##  - attr(*, "spec")=
##   .. cols(
##   ..   airline = col_character(),
##   ..   avail_seat_km_per_week = col_double(),
##   ..   incidents_85_99 = col_double(),
##   ..   fatal_accidents_85_99 = col_double(),
##   ..   fatalities_85_99 = col_double(),
##   ..   incidents_00_14 = col_double(),
##   ..   fatal_accidents_00_14 = col_double(),
##   ..   fatalities_00_14 = col_double()
##   .. )
##  - attr(*, "problems")=<externalptr>
```



Data comes from this source:
https://catalog.data.gov/dataset/?q=chronic+disease+indicators&page=2

This source was recommended and is a .gov source, so should be reliable.  It has useful data for discovreing how many students are physically fit.
All the data came in as a character or double.

```r
FitStudents <- read_csv("percentage-of-physically-fit-students-lghc-indicator-8.csv")
```

```
## Rows: 37236 Columns: 14
## ── Column specification ────────────────────────────────────────────────────────
## Delimiter: ","
## chr (7): LGHC Indicator Name, Year, Strata, Strata Name, Geography, Grade Le...
## dbl (7): Numerator, Denominator, Percent, LCI, UCI, Stardard Error, RSE
## 
## ℹ Use `spec()` to retrieve the full column specification for this data.
## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
```

```r
FitStudents
```

```
## # A tibble: 37,236 × 14
##    `LGHC Indicator …` Year  Strata `Strata Name` Geography `Grade Lev` Numerator
##    <chr>              <chr> <chr>  <chr>         <chr>     <chr>           <dbl>
##  1 score 6 of 6       1998… None   All Students  Alameda   Grade 5          2711
##  2 score 6 of 6       1998… None   All Students  Alameda   Grade 7          2549
##  3 score 6 of 6       1998… None   All Students  Alameda   Grade 9          1986
##  4 score 6 of 6       1998… None   All Students  Amador    Grade 5            28
##  5 score 6 of 6       1998… None   All Students  Amador    Grade 7             5
##  6 score 6 of 6       1998… None   All Students  Amador    Grade 9            53
##  7 score 6 of 6       1998… None   All Students  Butte     Grade 5           292
##  8 score 6 of 6       1998… None   All Students  Butte     Grade 7           411
##  9 score 6 of 6       1998… None   All Students  Butte     Grade 9           383
## 10 score 6 of 6       1998… None   All Students  Calaveras Grade 5            43
## # … with 37,226 more rows, and 7 more variables: Denominator <dbl>,
## #   Percent <dbl>, LCI <dbl>, UCI <dbl>, `Stardard Error` <dbl>, RSE <dbl>,
## #   warning <chr>
```

```r
str(FitStudents)
```

```
## spec_tbl_df [37,236 × 14] (S3: spec_tbl_df/tbl_df/tbl/data.frame)
##  $ LGHC Indicator Name: chr [1:37236] "score 6 of 6" "score 6 of 6" "score 6 of 6" "score 6 of 6" ...
##  $ Year               : chr [1:37236] "1998-1999" "1998-1999" "1998-1999" "1998-1999" ...
##  $ Strata             : chr [1:37236] "None" "None" "None" "None" ...
##  $ Strata Name        : chr [1:37236] "All Students" "All Students" "All Students" "All Students" ...
##  $ Geography          : chr [1:37236] "Alameda" "Alameda" "Alameda" "Amador" ...
##  $ Grade Lev          : chr [1:37236] "Grade 5" "Grade 7" "Grade 9" "Grade 5" ...
##  $ Numerator          : num [1:37236] 2711 2549 1986 28 5 ...
##  $ Denominator        : num [1:37236] 12808 11493 10105 319 356 ...
##  $ Percent            : num [1:37236] 21.17 22.18 19.65 8.78 1.4 ...
##  $ LCI                : num [1:37236] 20.46 21.42 18.87 5.68 0.18 ...
##  $ UCI                : num [1:37236] 21.88 22.94 20.43 11.88 2.62 ...
##  $ Stardard Error     : num [1:37236] 0.36 0.39 0.4 1.58 0.62 2.77 0.73 0.85 0.82 1.59 ...
##  $ RSE                : num [1:37236] 1.7 1.76 2.04 18 44.29 ...
##  $ warning            : chr [1:37236] NA NA NA NA ...
##  - attr(*, "spec")=
##   .. cols(
##   ..   `LGHC Indicator Name` = col_character(),
##   ..   Year = col_character(),
##   ..   Strata = col_character(),
##   ..   `Strata Name` = col_character(),
##   ..   Geography = col_character(),
##   ..   `Grade Lev` = col_character(),
##   ..   Numerator = col_double(),
##   ..   Denominator = col_double(),
##   ..   Percent = col_double(),
##   ..   LCI = col_double(),
##   ..   UCI = col_double(),
##   ..   `Stardard Error` = col_double(),
##   ..   RSE = col_double(),
##   ..   warning = col_character()
##   .. )
##  - attr(*, "problems")=<externalptr>
```


