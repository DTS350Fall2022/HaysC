---
title: 'Case Study 2: Coral Bleaching'
author: "Claire Hays"
date: "9/2/2022"
output: 
  html_document:
    theme: cosmo
    keep_md: TRUE
editor_options: 
  chunk_output_type: console
---







```r
ggplot(mydata, aes(x = Year, y = Value, fill = Event)) +
  geom_bar(position = 'stack', stat = 'identity') +
  facet_wrap(~Entity, nrow = 3, scales = 'free') +
  scale_fill_manual(values = c('lightblue4', 'red4'))
```

![](Case-Study-2---Hays_files/figure-html/Plots-1.png)<!-- -->


```r
ggplot() +
  geom_smooth(mydata, mapping = aes(x = Year, y = Value, fill = Entity)) +
  facet_wrap(~Entity) 
```

```
## `geom_smooth()` using method = 'loess' and formula 'y ~ x'
```

![](Case-Study-2---Hays_files/figure-html/New Plot-1.png)<!-- -->


