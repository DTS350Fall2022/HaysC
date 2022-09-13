---
title: "Case Study 3"
author: "Claire Hays"
date: "9/12/2022"
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
library(dplyr)
library(gapminder)
```

First graph

```r
dat <- filter(gapminder, country != "Kuwait")
head(dat)
```

```
## # A tibble: 6 × 6
##   country     continent  year lifeExp      pop gdpPercap
##   <fct>       <fct>     <int>   <dbl>    <int>     <dbl>
## 1 Afghanistan Asia       1952    28.8  8425333      779.
## 2 Afghanistan Asia       1957    30.3  9240934      821.
## 3 Afghanistan Asia       1962    32.0 10267083      853.
## 4 Afghanistan Asia       1967    34.0 11537966      836.
## 5 Afghanistan Asia       1972    36.1 13079460      740.
## 6 Afghanistan Asia       1977    38.4 14880372      786.
```

```r
ggplot(data = dat) +
  geom_point(mapping = aes(x = lifeExp, y = gdpPercap, color = continent, size = pop)) +
  facet_wrap(~ year, nrow = 1) +
  scale_y_continuous(trans = "sqrt") +
  scale_size_continuous(name = "Population (100k)") +
  xlab("Life Expectancy") +
  ylab("GDP per capita") +
  theme_bw()
```

![](Case-Study-3_files/figure-html/unnamed-chunk-2-1.png)<!-- -->


create a weighted mean and then the second graph

```r
weighted_mean <- dat %>%
  group_by(year, continent) %>%
  summarize(w_avg = weighted.mean(gdpPercap), population = pop/100000)
```

```
## `summarise()` has grouped output by 'year', 'continent'. You can override using
## the `.groups` argument.
```

```r
 ggplot() +
  geom_point(dat, mapping = aes(x = year, y = gdpPercap, color = continent)) +
  geom_path(dat, mapping = aes(x = year, y = gdpPercap, color = continent)) +
  geom_point(weighted_mean, mapping = aes(x = year, y = w_avg, size = population)) +
  facet_wrap(~continent, nrow = 2) +
  xlab("Year") + ylab("GDP Per Capita") +
  scale_size_continuous(name = "Population (100k)") +
  theme_bw()
```

![](Case-Study-3_files/figure-html/unnamed-chunk-3-1.png)<!-- -->

