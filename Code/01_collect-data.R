# 01_collect-data.R

# 1. Collecting Data
### I collect data from the Cyber Operations Tracker (Council of Foreign Relations) https://www.cfr.org/interactive/cyber-operations



## 01 General setting

# remove all objects
rm(list=ls())

# Unload all packages 
library(pacman)
pacman::p_unload(all)

library(tidyverse)
library(stringr)

# Add packages 
pacman::p_load(
  tidyverse, #dplyr, readr, etc.
  data.table, #fread() 
  foreign, #load data types including stata .dta files 
  magrittr, #%<>% operator
  skimr #for summerising
)


## 02 Import data
cyber <- read.csv("/Users/weitin/OneDrive/cyberdata.csv",
                  header = TRUE,
                  #stringsAsFactors = T,
                  na.strings = c("", " ", "999", "?", "NONE", "none"))

glimpse(cyber)

#select interested data
cyber_2 <-select(cyber,Title,Date, Affiliations,Description,Response,Victims,Sponsor, Type, Category)

cyber_2 %>% skimr::skim()
glimpse(cyber_2)


## 03 Constructing the Analysis Dataset

# 3-1 Try to seperate response and link

v0<-strsplit(as.character(cyber_2$Response)," ")


check0<-lengths(v0,use.names = F)
check0 # there mignt be one, four, or five spaces.
length(which(check0!=1)) # check: there are 68 which are four or five spaces. 
d0 <- data.table(target = cyber_2$Response) # take out the targeted column "sponsor"

# Delimiter may be multipal space. 
d0[, c("1", "2","3","4","5") := tstrsplit(target, " ")] # Break them into five columns. 
d1 <- sapply(d0, as.character) # Return a list with same length
d1[is.na(d1)] <- " " # now resplace all missing value as one space
d1<-as.data.frame(d1)

#d1 <- data.table(d1)

d2 <- d1 %>% 
  unite(col =Response_type , '1', '2', sep = " ")  %>% # gathering words 
  unite(col =link , '4', '5', sep = " ") # gathering link
d2 # now there's only one space delimiter

# now we have a cleaned "Response"
Sponsor_cleaned<-d2[,c("Response_type","link" )]

# Update the data
cyber_2_1<-cbind(cyber_2,Sponsor_cleaned)

#Grip incident which have responses
new_var_ind1<-grep("Confirmation",cyber_2$Response)   
new_var_ind2<-grep("Denouncement",cyber_2$Response)   
new_var_ind3<-grep("Criminal charges",cyber_2$Response)   
new_var_ind4<-grep("Sanctions",cyber_2$Response)   
new_var_ind5<-grep("Denial",cyber_2$Response) 
new_var_ind6<-grep(" ",cyber_2$Response) 

# New dataframe that contains incidents which are responded
keytopic_id<-c(new_var_ind1,new_var_ind2,new_var_ind3,new_var_ind4,new_var_ind5,new_var_ind6)
cyber_3<-cyber_2_1[keytopic_id,]
head(cyber_3)

# 3-2 Creat a column which can identify state victims
table(cyber_2_1$Category) # check
# Add a column "state_victim"
cyber_2_1  %<>%
  mutate(state_victim = ifelse(Category %like% 'Government|Civil society|Military',T, F)) 


# 3-3 Creat a column which can identify state power
table(cyber_2_1$Sponsor)
# Create three types
cyber_2_1 %<>%
  mutate(state_cat = ifelse(Sponsor %like%  'China|United States|Russian Federation', "Super Power","Middle Power")) 

#  update missing data as NA, or it would be coded as "Middle Power"
cyber_2_1$state_cat[is.na(cyber_2_1$Sponsor)]<-"NA"

# Check
cyber_2_1[is.na(cyber_2_1$Sponsor),c("Sponsor","state_cat")]

# 3-4 Clean "Date" variable

cyber_2_1 %<>%
  # Convert date variable to date type
  mutate(date_orig = Date,
         Date = lubridate::ymd(date_orig)) %>%
  # Add year variable 
  mutate(Year = year(Date)) 
head(cyber_2_1)

# 04 Summarize

### Summarize data


# summarize attacks category
suma_attackcat = cyber_2_1 %>% 
  filter(!is.na(Category))%>%
  filter(!is.na(Year))%>%
  group_by(Category, Year) %>% 
  summarise(sum=n())
print(suma_attackcat)

# summarize sponsor states
suma_sponstates = cyber_2_1 %>% 
  filter(!is.na(Sponsor)) %>%
  filter(!is.na(Year))%>%
  group_by(Sponsor, Year) %>% 
  summarise(sum_sponstates = n())
print(suma_sponstates)

# summarize victims 
suma_victims = cyber_2_1 %>% 
  filter(!is.na(Victims)) %>% 
  group_by(Victims, Year, state_victim) %>% 
  summarize(sum_victims = n())
print(suma_victims)


# Summarize statepower
suma_statepower = cyber_2_1 %>% 
  filter(!is.na(state_cat)) %>% 
  group_by(state_cat,Year) %>% 
  summarise(sum = n())

print(suma_statepower)

# reshape statepower
head(suma_statepower)
suma_statepower_reshape <- spread(suma_statepower,Year,sum) 
head(suma_statepower_reshape)

# 05 Save  cleand data

write.csv(cyber_2_1,"02_cyber_2_cleaned.csv",row.names = F)