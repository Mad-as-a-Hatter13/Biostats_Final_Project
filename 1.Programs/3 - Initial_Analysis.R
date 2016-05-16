# Program: Build and clean the data, along with initial graphs
# Run after the csv files are created in python

##################################################################
wdrive <- file.path('~/YOUR DRIVE HERE')
setwd(wdrive)
##################################################################
require(plyr)
require(stringr)
require(ggplot2)

##################################################################
# Read in the data from the csv created in Python
threeday <- read.csv('three_day.csv',
                     na.strings=c("",".","NA"," "))
firstpull <- read.csv('first_pull.csv',
                      na.strings=c("",".","NA"," "))
# Eliminate the rows where there are no observations for the key
# variables from before.
threeday <- threeday[which(threeday$text!="NA"),]
threeday <- threeday[which(threeday$lang!="NA"),]
threeday <- threeday[which(threeday$tweet_time!="NA"),]

firstpull <- firstpull[which(firstpull$text!="NA"),]
firstpull <- firstpull[which(firstpull$lang!="NA"),]
firstpull <- firstpull[which(firstpull$tweet_time!="NA"),]


# Need to reformat the time of the tweet as it is in a 'messy'
# format when pulled.
threeday$tweet_time <- as.POSIXct(strptime(threeday$tweet_time, 
                    "%a %B %d %H:%M:%S %z %Y", tz = "GMT"))
Sys.timezone(location = TRUE)
# Set the time zone to your time zone as opposed to GMT.
threeday$tweet_time <- format(threeday$tweet_time, 
                            tz="America/Denver",usetz=TRUE)
threeday$tweet_time <- as.POSIXct(threeday$tweet_time, 
                                "America/Denver")

firstpull$tweet_time <- as.POSIXct(strptime(firstpull$tweet_time, 
                    "%a %B %d %H:%M:%S %z %Y", tz = "GMT"))
Sys.timezone(location = TRUE)
# Set the time zone to your time zone as opposed to GMT.
firstpull$tweet_time <- format(firstpull$tweet_time, 
                            tz="America/Denver",usetz=TRUE)
firstpull$tweet_time <- as.POSIXct(firstpull$tweet_time, 
                                "America/Denver")

save(firstpull, threeday, file = "project_data.RData")
##################################################################
# Plotting the number of tweets by specific time each tweet was
# created, bin by hour of creation.
minutes <- 60
ggplot(data=threeday, aes(x=tweet_time)) + 
  geom_histogram(aes(fill=..count..), binwidth=60*minutes) + 
  scale_x_datetime("Date") + 
  scale_y_continuous("Frequency") +
  labs(title="Zika Related Tweet Frequency May 10-12", 
       legend.position='none')

minutes <- 60
ggplot(data=firstpull, aes(x=tweet_time)) + 
  geom_histogram(aes(fill=..count..), binwidth=60*minutes) + 
  scale_x_datetime("Date") + 
  scale_y_continuous("Frequency") +
  labs(title="Zika Related Tweet Frequency April 22-24", 
       legend.position='none')

##################################################################
# Find those that were the most active tweeters
three.top.tweet <- as.data.frame(table(threeday$handle))
three.top.tweet <- three.top.tweet[order(
                   three.top.tweet$Freq, decreasing=T),]
names(three.top.tweet) <- c("User","Tweets")
head(three.top.tweet)

firstpull.top.tweet <- as.data.frame(table(firstpull$handle))
firstpull.top.tweet <- firstpull.top.tweet[order(
                       firstpull.top.tweet$Freq, decreasing=T),]
names(firstpull.top.tweet) <- c("User","Tweets")
head(firstpull.top.tweet)

colfunc <- colorRampPalette(c("dodgerblue4","darkorchid1"))

par(mfrow=c(1,2))
par(mar=c(5,10,2,2))
    with(firstpull.top.tweet[rev(1:40), ], barplot(Tweets, 
         names=User, horiz=T, las=1, xlim=c(0,400), 
         main="Top 40: April 22-24 Tweets per User", 
         col=colfunc(40)))    
    with(three.top.tweet[rev(1:40), ], barplot(Tweets, 
         names=User, horiz=T, las=1, xlim=c(0,400), 
         main="Top 40: May 10-12 Tweets per User", 
         col=colfunc(40)))

     
##################################################################
# Which Countries and Languages saw the most tweets?
three.cont <- as.data.frame(table(threeday$country))
three.cont <- three.cont[order(three.cont$Freq, decreasing=T),]
names(three.cont) <- c("User","Num")
head(three.cont)

first.cont <- as.data.frame(table(firstpull$country))
first.cont <- first.cont[order(first.cont$Freq, decreasing=T),]
names(first.cont) <- c("User","Num")
head(first.cont)

par(mfrow=c(1,2))
par(mar=c(5,10,2,2))
    with(first.cont[rev(1:5), ], barplot(Num, 
         names=User, horiz=T, las=1, xlim=c(0,400), 
         main="Top 5: April 22-24 Tweets by Country", 
         col=colfunc(5)))
    with(three.cont[rev(1:5), ], barplot(Num, 
         names=User, horiz=T, las=1, xlim=c(0,400), 
         main="Top 5: May 10-12 Tweets by Country", 
         col=colfunc(5)))

three.lang <- as.data.frame(table(threeday$lang))
three.lang <- three.lang[order(three.lang$Freq, decreasing=T),]
names(three.lang) <- c("User","Num")
head(three.lang)

first.lang <- as.data.frame(table(firstpull$lang))
first.lang <- first.lang[order(first.lang$Freq, decreasing=T),]
names(first.lang) <- c("User","Num")
head(first.lang)

par(mfrow=c(1,2))
par(mar=c(5,10,2,2))
    with(first.lang[rev(1:5), ], barplot(Num, 
         names=User, horiz=T, las=1, xlim=c(0,42000), 
         main="Top 5: April 22-24 Tweets by Language", 
         col=colfunc(5)))
    with(three.lang[rev(1:5), ], barplot(Num, 
         names=User, horiz=T, las=1, xlim=c(0,42000), 
         main="Top 5: May 10-12 Tweets by Language", 
         col=colfunc(5)))
par(mfrow=c(1,1))

##################################################################

detach("package:stringr", unload=TRUE)
detach("package:ggplot2", unload=TRUE)
detach("package:plyr", unload=TRUE)









