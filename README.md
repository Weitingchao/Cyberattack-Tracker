# ps239t-final-project
## Short Description 
In this project, I try to gather and clean data regarding cyber attacks happening from 2005 to 2019. My goal is to do some analysis and visualization.  For the first part, I clean the data by selecting the interested column, sepearating columns (The "Response" column), and adding a few more columns for later analysis. For example, I add logical variable to categorize state power and whether the cyberattack is sponsored by multiple countries. I also wonder how the frequency, so make another short table to record the time gap between each sponsors by selected states.  After these prepossesses, I am able to conduct some analysis and try to answer my research questions.   Finally, I present those findings with ggplot2 plots.   
## Dependencies 
1. R, 3.6.2 
2. Excel 2016  I include `library()`commands at the beginning of every script to upload packages needed.    
## Files  :  
#### Description/  
1. Narrative.Rmd: Gives briefly introduction of the project, main challenges I encountered and solutions I tried. Finally the results is presented as well as some possible further works.  
2. Narrative.pdf: A knitted pdf of 00_Narrative.Rmd.  
3. Slides.html: Here is the link of my talk slides:file:///C:/Users/weitin/OneDrive/datacleaning%20assignment/analysis/Presentation_2.html  
#### Code/ 
1. 01_collect-data.R: Collects data from Cyber Operations Tracker, cleans the data, and exports it to the file 02_cyber_2_cleaned.csv  2. 02_analysis.R: Conducts descriptive analysis of the data, producing the tables and visualizations found in the Results directory.  
#### Data/  
1. 01_cyberdata: Cyber Operations Tracker,  available here: https://www.cfr.org/interactive/cyber-operations  
2. 02_cyber_2_cleaned: The cleanded data, with following variables: 
    - *Title*: the title of the incident
    - *Date*: Date of the incident
    - *Affiliations*:  orginization which the sponsor is spected to afflicated with
    - *Description:* some short descriptions retrieved from news 
    - *Response_type*: whether the victim respond to the cyber incident 
    - *link*: the link regarding the response. 
    - *Victims*: victim name Category: the victim is civil society, government, military, or private sector. 
    - *Sponsor*: sponsor name 
    - *Type*: six types of cyber operations are distrubuted denial of service, espionage, defacement, data destuction, sabotage, and doxing.  
    - *Year*: year state_victim: yes if the victim is categorized as civil society, government, or military. 
    - *state_cat* : I identify the sponsor of a incident as cyber super power if it is China, United States, or Russian Federation , middle power otherwise.   
#### Results/  
##### Trend 
    - *01_plots.jpeg*: Present a general trend of cyberattacks over time.  

##### Type 
02_-1_plots.jpeg: Summarizes types of cyber incidents happening between 2005-2019, presented in total numbers. 
02-2_plots.jpeg: Summarizes types of cyber incidents happening between 2005-2019, presented in percentage. 
02-3_plots.jpeg: Summarizes types of cyber incidents happening between 2005-2019 and groups by every four years,  presented in sum numbers.  
02-4_plots.jpeg: Summarizes types of cyber incidents happening between 2005-2019 and groups by every four years,  presented in percentages.  

##### Sponsor 
03_-1_plots.jpeg: Summarized sponsors of cyber incidents 
03_-2_plots.jpeg: Summarized top five soponsors and presents in percentages.   
##### 04 Frequency 
04_-1_plots.jpeg: Demostrates the day gap of every cyber attackes. 
04_-2_plots.jpeg: Demostrates the day gap of every cyber attackes which top 5 sponsors launched.  

## More Information 
I am welcome to any comments or suggestions, feel free to contact me via mail: `weitin.chao111@gmail.com`
