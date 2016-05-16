# Program: Builds and models the sentiment analysis of the data.
# Run after the first R-Script as it calls the data set(s) you create
# from it.
##################################################################
wdrive <- file.path('~/YOUR DRIVE HERE')
setwd(wdrive)
#####################################################################
require(syuzhet)
require(lubridate)
require(ggplot2)
require(scales)
require(reshape2)
require(dplyr)
load("project_data")
ls()
#####################################################################

firstpull$text <- as.character(firstpull$text)
threeday$text <- as.character(threeday$text) 

mySentiment <- get_nrc_sentiment(firstpull$text)
firstpull <- cbind(firstpull, mySentiment)
mySentiment2 <- get_nrc_sentiment(threeday$text)
threeday <- cbind(threeday, mySentiment2)

sentimentTotals <- data.frame(colSums(firstpull[,c(25:32)]))
names(sentimentTotals) <- "count"
sentimentTotals <- cbind("sentiment" = rownames(sentimentTotals), 
                         sentimentTotals)
rownames(sentimentTotals) <- NULL
sentimentTotals2 <- data.frame(colSums(threeday[,c(25:32)]))
names(sentimentTotals2) <- "count"
sentimentTotals2 <- cbind("sentiment" = rownames(sentimentTotals2), 
                         sentimentTotals2)
rownames(sentimentTotals2) <- NULL

ggplot(data = sentimentTotals, aes(x = sentiment, y = count)) +
        geom_bar(aes(fill = sentiment), stat = "identity") +
        theme(legend.position = "none") +
        xlab("Sentiment") + ylab("Total Count") + 
        ggtitle("April 22-24: Total Sentiment Score for All Tweets")
ggplot(data = sentimentTotals2, aes(x = sentiment, y = count)) +
        geom_bar(aes(fill = sentiment), stat = "identity") +
        theme(legend.position = "none") +
        xlab("Sentiment") + ylab("Total Count") + 
        ggtitle("May 10-12: Total Sentiment Score for All Tweets")

#####################################################################
firstpull$timestamp <- with_tz(ymd_hms(firstpull$tweet_time), 
                               "America/Denver")
threeday$timestamp <- with_tz(ymd_hms(threeday$tweet_time), 
                               "America/Denver")

posnegtime <- firstpull %>% 
        group_by(timestamp = cut(timestamp, breaks="hour")) %>%
        summarise(negative = mean(negative),
                  positive = mean(positive)) %>% melt
names(posnegtime) <- c("timestamp", "sentiment", "meanvalue")
posnegtime$sentiment = factor(posnegtime$sentiment,
                              levels(posnegtime$sentiment)[c(2,1)])
posnegtime$timestamp <- as.POSIXct(posnegtime$timestamp, 
                                   format="%Y-%m-%d %H:%M:%S")

posnegtime2 <- threeday %>% 
        group_by(timestamp = cut(timestamp, breaks="hour")) %>%
        summarise(negative = mean(negative),
                  positive = mean(positive)) %>% melt
names(posnegtime2) <- c("timestamp", "sentiment", "meanvalue")
posnegtime2$sentiment = factor(posnegtime2$sentiment,
                              levels(posnegtime2$sentiment)[c(2,1)])
posnegtime2$timestamp <- as.POSIXct(posnegtime2$timestamp, 
                                   format="%Y-%m-%d %H:%M:%S")

ggplot(data = posnegtime, aes(x = timestamp, y = meanvalue, 
                              group = sentiment)) +
        geom_line(size = 2.5, alpha = 0.7, aes(color = sentiment)) +
        geom_point(size = 0.5) +
        ylim(0, NA) + 
        scale_colour_manual(values = c("springgreen4", 
                                       "firebrick3")) +
        theme(legend.title=element_blank(), axis.title.x = 
        element_blank()) + ylab("Average sentiment score") + 
        ggtitle("April 22-24: Sentiment Over Time")

ggplot(data = posnegtime2, aes(x = timestamp, y = meanvalue, 
                              group = sentiment)) +
        geom_line(size = 2.5, alpha = 0.7, aes(color = sentiment)) +
        geom_point(size = 0.5) +
        ylim(0, NA) + 
        scale_colour_manual(values = c("springgreen4", 
                                       "firebrick3")) +
        theme(legend.title=element_blank(), axis.title.x = 
        element_blank()) + ylab("Average sentiment score") + 
        ggtitle("May 10-12: Sentiment Over Time")

#####################################################################
allsentiment <- firstpull %>% group_by(timestamp = cut(timestamp, 
                                             breaks="hour")) %>%
        summarise(anger = mean(anger), 
                  anticipation = mean(anticipation), 
                  disgust = mean(disgust), 
                  fear = mean(fear), 
                  joy = mean(joy), 
                  sadness = mean(sadness), 
                  surprise = mean(surprise), 
                  trust = mean(trust)) %>% melt
names(allsentiment) <- c("timestamp", "sentiment", "meanvalue")
allsentiment$timestamp <- as.POSIXct(allsentiment$timestamp, 
                                     format="%Y-%m-%d %H:%M:%S")

allsentiment2 <- threeday %>% group_by(timestamp = cut(timestamp, 
                                             breaks="hour")) %>%
        summarise(anger = mean(anger), 
                  anticipation = mean(anticipation), 
                  disgust = mean(disgust), 
                  fear = mean(fear), 
                  joy = mean(joy), 
                  sadness = mean(sadness), 
                  surprise = mean(surprise), 
                  trust = mean(trust)) %>% melt
names(allsentiment2) <- c("timestamp", "sentiment", "meanvalue")
allsentiment2$timestamp <- as.POSIXct(allsentiment2$timestamp, 
                                     format="%Y-%m-%d %H:%M:%S")

ggplot(data = allsentiment, aes(x = timestamp, y = meanvalue, 
                                group = sentiment)) +
        geom_line(size = 2.5, alpha = 0.7, aes(color = sentiment)) +
        geom_point(size = 0.5) +
        ylim(0, 0.6) +
        theme(legend.title=element_blank(), axis.title.x = 
                element_blank()) +
        ylab("Average sentiment score") + 
        ggtitle("April 22-24: Specific Sentiment Over Time")

ggplot(data = allsentiment2, aes(x = timestamp, y = meanvalue, 
                                group = sentiment)) +
        geom_line(size = 2.5, alpha = 0.7, aes(color = sentiment)) +
        geom_point(size = 0.5) +
        ylim(0, 0.6) +
        theme(legend.title=element_blank(), axis.title.x = 
                element_blank()) +
        ylab("Average sentiment score") + 
        ggtitle("May 10-12: Specific Sentiment Over Time")

#####################################################################

detach("package:syuzhet", unload=TRUE)
detach("package:lubridate", unload=TRUE)
detach("package:ggplot2", unload=TRUE)
detach("package:scales", unload=TRUE)
detach("package:reshape2", unload=TRUE)
detach("package:dplyr", unload=TRUE)

