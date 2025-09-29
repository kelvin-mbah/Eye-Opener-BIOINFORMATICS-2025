#Install and Load Required Packages----
install.packages('package name')
library(tidyverse)

#Load the data into R  ----
data <- read.csv(file.choose())

#Explore the file and data structure
dim(data)             #check for dimension of data
str(data)             #check for the data structure

#check the number of rows and columns as well as their names
ncol(data)
nrow(data)
colnames(data)
rownames(data)

#check for the summary and class of the data
summary(data$AF)
class(data)
class(data$AF)


#Selecting entire columns and rows ----

#Selecting columns
colnames(data)           #check column names
data[rows, columns]
data[,c(1,4,5)]         #select column (1,4, and 5)

#Alternatively we can use the select function in dplyr package
select('data', "names of columns you want to select--exactly as seen in data as R is case sensitive")
select(data, SAMPLE, REF, ALT)        #Default selection
select(data, SAMPLE,REF,ALT) %>% head(4)   #use the pipe function (%>%) and head to select the number of rows for column
select(data, -CALLER) %>% head(3)     #select everything except CALLER column
select(data, c(1,4,5)) %>% tail(4)    #select column 1,4,5 and show only the last 4 rows of it data

#Transform the dataframe into a TIBBLE
Data <- as.tibble(data)
select(Data, c(1,4,5))  %>% head(3)
select(Data, SAMPLE, REF, ALT)  %>% is.na()   #Check if theres na in the column selected


#Filtering rows
Data[1:10, -16]    #Filter from row 1 to 10 in all columns excluding caller

Data[Data$SAMPLE == 'SRR13500958',] #Using base R code
filter(Data, SAMPLE == 'SRR13500958') %>% head(3)  #Using dyplr function
Data %>% filter(SAMPLE == 'SRR13500958') %>% select(c(2,3,4,5)) %>% head(3)
Data %>% filter(SAMPLE == 'SRR13500958') %>% select(CHROM, POS, REF, ALT, DP)

#To select only values which DP>=500 for the sample
Data %>% filter(SAMPLE == 'SRR13500958' & DP >= 500) %>% select(CHROM, POS,REF, ALT, DP)
Data %>% filter(SAMPLE == 'SRR13500958' & DP >= 1000) %>% select(CHROM, POS,REF, ALT, DP)

#Compute Operations/Math -----

#count specific rows and columns
Data %>% count(SAMPLE, EFFECT)             #Distribution of effect on samples and count
Data %>% count(SAMPLE, GENE, sort = TRUE) %>% head() #Distribution of genes per sample and count

max(Data$ALT_DP)
mean(Data$DP)

Data_log <- Data %>% mutate(DP_log2 = log2(DP))
Data_LOG <- Data_log[, -17]
select(Data_log, SAMPLE, REF, ALT, POS, DP, DP_log2) %>% head()

#The SPLIT-APPLY-COMBINE APPROACH
Data %>% group_by(SAMPLE) %>% summarize(max(DP))
Data_log %>% group_by(EFFECT) %>% summarize(min(DP_log2))

#DATA VISUALIZATION ----

#Define the data 
library(ggplot2)
ggplot(data = Data)              #Link ggplot to our data frame

#Define the aesthetics
ggplot(data = Data, aes(x = SAMPLE, y = DP))    #Link ggplot to specific variable using aesthetics

#Define the plot type using geometrics
ggplot(data = Data, aes(x= SAMPLE, y = DP)) +
  geom_point()       #USING POINT AS PLOT TYPE

ggplot(data = Data, aes(x= SAMPLE, y = DP)) +
  geom_boxplot()    #USING BOXPLOT AS PLOT TYPE

#AXIS TRANSFRORMATION
ggplot(data = Data, aes(x= SAMPLE, y = DP)) +
  geom_point() + ylim(0,10000)  

ggplot(data = Data, aes(x= SAMPLE, y = DP)) +
  geom_boxplot()  + ylim(0,10000)
#ALTERNATIVELY USING SCALE_Y_CONTINOUS
ggplot(data = Data, aes(x= SAMPLE, y = DP)) +
  geom_boxplot()  + scale_y_continuous(name = 'dp', limits = c(0,10000))

ggplot(data = Data, aes(x= SAMPLE, y = DP)) +
  geom_point() + scale_y_continuous(name = 'dp', limits = c(0,10000))

#ALTERNATIVELY USING SCALE TO LOG
# Points 
ggplot(data = Data, aes(x=SAMPLE, y=DP)) + geom_point() + scale_y_continuous(trans='log10')

ggplot(data = Data, aes(x=SAMPLE, y=DP)) + geom_point() + scale_y_log10()

#Boxplots
ggplot(data = Data, aes(x= SAMPLE, y = DP)) +
  geom_boxplot() + scale_y_continuous(trans = 'log10')

ggplot(data = Data, aes(x= SAMPLE, y = DP)) +
  geom_boxplot() + scale_y_log10()

#ADVANCE THE PLOTTING BY ADDING COLORS, SHAPES, AND LEGEND
ggplot(data = Data, aes(x=SAMPLE, y=DP, colour = SAMPLE)) + geom_point() + scale_y_log10() 

ggplot(data = Data, aes(x= SAMPLE, y = DP, fill = SAMPLE)) +
  geom_boxplot() + scale_y_log10() 

#cOLORS FOR FILLING (WITH MANUAL)
ggplot(data = Data, aes(x=SAMPLE, y=DP, fill= SAMPLE)) + geom_boxplot() + ylim(0,10000) + scale_fill_manual(values=c("#cb6015", "#e1ad01", "#6d0016", "#808000", "#4e3524"))

#USING RCOLORBREWER
library(RColorBrewer)
ggplot(data = Data, aes(x = SAMPLE, y = DP, fill = SAMPLE)) +
  geom_boxplot() + ylim(0,10000) + scale_fill_brewer(palette = 'Spectral')

display.brewer.all()  #To check color in brewer

#CHANGE LEGEND POSITION USING THEMES
ggplot(data = Data, aes(x = SAMPLE, y = DP, fill = EFFECT)) + 
  geom_boxplot() + ylim(0, 10000) + scale_fill_brewer(palette = 'Spectral') +
  theme(legend.position = 'right')

#CHANGE TITLES USING LAB
ggplot(data = Data, aes(x = SAMPLE, y = DP, fill = SAMPLE)) + 
  geom_boxplot() + 
  scale_y_log10() + scale_fill_brewer(palette = 'Spectral') +
  theme(legend.position = 'top') + 
  labs(title = 'DP_per_Sample', x = 'Sample_ID', y = 'Dp')

#CHANGE SHAPE AND SIZE OF PLOT TYPE
ggplot(data = Data, aes(x= SAMPLE, y = DP)) +
  geom_point(shape = 21, fill = 'Yellow', color = "black", size = 6) +
  ylim(0,10000) + 
  ggtitle('DP per Sample') +xlab('Sample_ID') + ylab('Dp')

ggpubr::show_point_shapes()


####VARIANT DATA RESULT PLOT####
#Distribution of DP values per chromosome and per samples

ggplot(data = Data, aes(x = CHROM, y = DP, fill = SAMPLE)) +
  geom_boxplot() + scale_y_log10(10000) + scale_color_brewer(palette = 'Spectral') +
  theme(legend.position = 'top') + labs(title = 'Distribution of DP per CHROM', x = 'Chrom', y = 'Dp') +
  facet_grid(.~ SAMPLE)

#THE VARIANT EFFECT PER SMAPLE
p_EFFECT <- ggplot(data = Data, aes(x=EFFECT, fill= SAMPLE)) + scale_fill_brewer(palette="RdBu") + labs(title="Effect_per_Sample") + theme(legend.position="bottom")
p_EFFECT + geom_bar()

p_EFFECT_flip <- ggplot(data = Data, aes(y=EFFECT, fill= SAMPLE)) + scale_fill_brewer(palette="RdBu") + labs(title="Effect_per_Sample") + theme(legend.position="bottom")
p_EFFECT_flip + geom_bar()
