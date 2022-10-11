#Task 12
#10/6
library(tidyverse)
library(readr)
library(dbplyr)

RandomLetters <- read_lines("https://github.com/WJC-Data-Science/DTS350/raw/master/randomletters.txt")
RandomLetters_Num <- read_lines("https://github.com/WJC-Data-Science/DTS350/raw/master/randomletters_wnumbers.txt")
str_length(RandomLetters)
str_length(RandomLetters_Num)

#1
my_quote <- c((str_sub(RandomLetters, start=1, end=1)))

for (i in seq(1, floor(str_length(RandomLetters)/1700))) {
  my_quote <- str_c(my_quote, str_sub(RandomLetters, start = i*1700, end = i*1700)) 
}

my_quote

my_quote2 <- str_split(my_quote, "\\.")[[1]][1]

my_quote2

#2
message <- c()
No_Numbers <- str_extract_all(RandomLetters_Num, ("\\d+"))

for(i in  seq(1, length(No_Numbers[[1]]))) {
  message[i] = letters[as.numeric(No_Numbers[[1]][i])]
}

message
#experts of ten possess more data than judgement

#3
str_extract_all(RandomLetters, "(.)(.)(.)(.)\\4\\3\\2\\1")

#4
remove_spaces_periods <- RandomLetters %>%
  str_remove_all(" ") %>%
  str_remove_all("\\.")

str_extract_all(remove_spaces_periods, ("[aeiou]{7}"))
#7 characters