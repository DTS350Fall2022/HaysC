---
title: "Task 3"
author: "Claire Hays"
date: "9/1/2022"
output: 
  html_document:
    theme: cosmo
    keep_md: true
editor_options: 
  chunk_output_type: console
---



#Task 3 due 9/6

setwd("~/Desktop/DTS 350/HaysClaire/Week2/Task3")
##for class task we are looking at the iris data
?iris
head(iris)
tail(iris)


#pic 1
ggplot(data = iris) + 
  geom_point(mapping = aes(x = Sepal.Length, y = Sepal.Width, color = Species, shape = Species))



#pic 2
ggplot(data = iris) + 
  geom_point(mapping = aes(x = Petal.Width, y = Petal.Length, color = Species, shape = Species)) +
  facet_wrap(~ Species, nrow = 1)



#pic3
ggplot(data = iris) + 
  geom_point(mapping = aes(x = Petal.Length, y = Petal.Width, color = Species, shape = Species)) +
  geom_smooth(method = "lm",(aes(x=Petal.Length, y=Petal.Width)))



#pic4
ggplot(iris, mapping = aes(x = Sepal.Length, fill = Species)) +
  geom_histogram(alpha = 8/8, color = " black", bins = 20) +
  geom_vline(aes(xintercept = mean(Sepal.Length)), linetype=2, color = "gray")



#question...
#which specie has the highest petal.length AND petal.width?
#picture #2 helps us answer this question using a facet.  
#we can easily compare the three different species and the lengths/widths of them
#it clearly shows that virginica has the highest length and width
  
