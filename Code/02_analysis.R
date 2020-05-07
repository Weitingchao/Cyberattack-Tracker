
# 02_analysis & visualization.R
# This script presents some analyses as well as visualization works I perforemed to answer my research questions (as below). 

## 01.Trend of cyber operation

## 02.What is the most common types of cyber operation ? Trend by years? 

## 03.Countries are more likely to be Sponsors (top 10?)?

## 04.Frequency of cyberattacks conducted by top five countries? 

## 05.Do super power (US, China and Russia) more likely to sponsor cyber incidents, compared to middle power? 

## 06.How do victims respond to the attacks? 


## General setting
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

# Load data
cyber_2_1 <- read.csv("/Users/weitin/OneDrive/datacleaning\ assignment/analysis/02_cyber_2_cleaned.csv")

# 01. Trend of cyber operation
### More cyber incidents over years

cyber_2_1 %>% 
  ggplot(aes(x=Year))+
  geom_histogram(bins = 50)+
  labs(title = "Cyber Incidents by year")
ggsave(filename="/Users/weitin/OneDrive/datacleaning\ assignment/analysis/01_plots.pdf")


# 02. What is the most common types of cyber operation ? Trend by years? 
  
  ### What types of incidents happen more often?
  ### Ans.Espionge
df <- cyber_2_1 %>% filter (!is.na(Type)) 
df %>% 
  ggplot(aes(x = Type))+
  geom_bar()+
  labs(title = "Types of Cyber Incidents 2005-2019")
ggsave(filename="/Users/weitin/OneDrive/datacleaning\ assignment/analysis/02-1_plots.pdf")

# As precentage
cyber_2_1 %>% group_by(Type) %>% 
  summarize(count = n()) %>%  # count records by species
  mutate(pct = count/sum(count)) %>%  # find percent of total
  ggplot( aes(Type, pct, fill = Type)) + 
  geom_bar(stat='identity') + 
  geom_text(aes(label=scales::percent(pct)), position = position_stack(vjust = .5))+
  scale_y_continuous(labels = scales::percent)+labs(x = 'Type', y = 'Percent', fill = 'Type')
ggsave(filename="/Users/weitin/OneDrive/datacleaning\ assignment/analysis/02-2_plots.pdf")

## Trend by years? 


# Cyber incidents by Types (use year group)

# summarize types by year groups
cyber_2_1$Year_group<-cut(cyber_2_1$Year,c(2004,2009,2012,2016,2019))
levels( cyber_2_1$Year_group) <- list( "2005-2008"="(2004,2009]", "2009-2011" ="(2009,2012]","2012-2015"="(2012,2016]","2016-2019" = "(2016,2019]")

suma_types = cyber_2_1 %>% 
  filter(!is.na(Type)) %>%
  filter(!is.na(Year_group))%>%
  filter(!is.na(Sponsor)) %>%
  group_by(Type, Year_group, Sponsor) %>% 
  summarize(sum = n()) %>% 
  arrange(Year_group)

suma_types


ggplot(suma_types,  aes( x = Year_group, fill = Type)) + 
  geom_bar(position = "dodge")+
  labs( y = "Sum", size = 8)+
  labs(x = "Every four years", size = 8)+
  labs(title = " Cyber Incidents by Types")
ggsave(filename="/Users/weitin/OneDrive/datacleaning\ assignment/analysis/02-3_plots.pdf")

# Another presence

ggplot(suma_types,aes( x = Year_group, fill = Type)) + 
  geom_bar(position = "fill")+
  labs( y = "Sum", size = 8)+
  labs(x = "Every four years", size = 8)+
  labs(title = " Cyber Incidents by Types")
ggsave(filename="/Users/weitin/OneDrive/datacleaning\ assignment/analysis/02-4_plots.pdf")


## 3. Countries are more likely to be Sponsors 
### Sponsors

cyber_2_1 %>% 
  ggplot(aes(x = Sponsor))+
  geom_bar()+
  #scale_y_continuous(labels = scales::percent)+
  labs(title = "Sponsors of Cyber Incidents 2005-2019")+
  coord_flip()
ggsave(filename="/Users/weitin/OneDrive/datacleaning\ assignment/analysis/03-1_plots.pdf")

## Top 10 sponsors?
suma_sponstates = cyber_2_1 %>% 
  filter(!is.na(Sponsor)) %>% # clean missing value
  filter(!is.na(Year))%>% # clean missing value
  group_by(Sponsor, Year) %>% # group incidents that conducted by the same sponsor.
  summarise(sum_sponstates = n()) 
print(suma_sponstates)

suma_sponstates_2 <-suma_sponstates %>% group_by(Sponsor) %>% 
  summarize(count = n()) %>%  # count
  mutate(pct = count/sum(count)) %>%  # percentage 
  arrange(desc(count/sum(count)))   # rank them


# What are top 10?
sponstates_top10 <- suma_sponstates_2[1:11,] # take top 10 countries that sponsor cyber operations. 
sponstates_top10

# visualization
sponstates_top10 %>% 
  ggplot(aes(Sponsor, pct, fill = Sponsor))+
  geom_bar(stat='identity') + 
  geom_text(aes(label=scales::percent(pct)), position = position_stack(vjust = .5))+
  scale_y_continuous(labels = scales::percent)+labs(x = 'Sponsor', y = 'Percent', fill = 'Sponsor')+
  coord_flip()

ggsave(filename="/Users/weitin/OneDrive/datacleaning\ assignment/analysis/03-2_plots.pdf")



# 04. Frequency of cyberattacks conducted by top five countries? 
# Create a new variable to specify top 5 countries from other (not really informative to know occational sponsors)
cyber_2_1$Sponsor_maintype<-"other"

china_id<-which(cyber_2_1$Sponsor %in% "China" =="TRUE")
rf_id<-which(cyber_2_1$Sponsor %in% "Russian Federation" =="TRUE")
ir_id<-which(cyber_2_1$Sponsor %in% "Iran (Islamic Republic of)" =="TRUE")
ko_id<-which(cyber_2_1$Sponsor %in% "Korea (Democratic People's Republic of)" =="TRUE")

# Simplify country name
cyber_2_1$Sponsor_maintype[china_id]<-"China"
cyber_2_1$Sponsor_maintype[rf_id]<-"Russian Federation"
cyber_2_1$Sponsor_maintype[ir_id]<-"Iran"
cyber_2_1$Sponsor_maintype[ko_id]<-"Korea"

table(cyber_2_1$Sponsor_maintype)

# Count the frequency 
incident <- cyber_2_1$Sponsor_maintype
incident_date <- sort(cyber_2_1$Date,na.last = TRUE) # let it presents from the earlier to the latested  

df <- data.frame(event = incident, event.date = incident_date) %>%
  arrange(event, event.date) %>% 
  group_by(event) %>%
  mutate(previous = lag(event.date, 1)) %>% # creat a column with previous 
  mutate(tae.1 = event.date - lag(event.date, 1)) # the gap

df

# China               Iran              Korea              other Russian Federation 

df$event_number<-c(NA,1:137,NA,1:39,NA,1:30,NA,1:91,NA,1:87)

# Visualization
ggplot(df, aes( x = event_number, y = tae.1, color = event ))+
  geom_line()+geom_point(aes(shape=event))
labs(title = "Diffs days per event trend")
ggsave(filename="/Users/weitin/OneDrive/datacleaning\ assignment/analysis/04-1_plots.pdf")

# Present by each country
ggplot(df, aes( x = event_number, y = tae.1, color = event ))+
  geom_line()+geom_point(aes(shape=event))  + facet_wrap(~ event, nrow = 5)
labs(title = "Diffs days per event trend")
# Save plot
ggsave(filename="/Users/weitin/OneDrive/datacleaning\ assignment/analysis/04-2_plots.pdf")


## 05. Do super power (US, China and Russia) more likely to sponsor cyber incidents, compared to middle power? 
### Sponsor state + state power

# Summarize 
suma_statepower = cyber_2_1 %>% 
  filter(!is.na(state_cat)) %>% 
  group_by(state_cat,Year) %>% 
  summarise(sum = n())

suma_statepower %>% 
  filter(state_cat!="NA") %>% 
  ggplot(aes( x = Year, y = sum, color = state_cat))+
  geom_line()+
  labs(title = " Cyber Incidents by Statepower")

# Save plot
ggsave(filename="/Users/weitin/OneDrive/datacleaning\ assignment/analysis/05_plots.pdf")

## 06. How does the state response to the cyber incident? 

cyber_2_1 %>% group_by(Response_type) %>% 
  summarize(count = n()) %>%  # count records by response type
  mutate(pct = count/sum(count)) %>%  # find percent of total
  ggplot( aes(Response_type, pct, fill = Response_type)) + 
  geom_bar(stat='identity') + 
  geom_text(aes(label=scales::percent(pct)), position = position_stack(vjust = .5))+
  scale_y_continuous(labels = scales::percent)+labs(x = 'Response_type', y = 'Percent', fill = 'Response_type')

# Save plot
ggsave(filename="/Users/weitin/OneDrive/datacleaning\ assignment/analysis/06_plots.pdf")
