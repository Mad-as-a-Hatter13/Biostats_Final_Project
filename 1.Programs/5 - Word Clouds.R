# Program: Create word clouds for the tweets
# Can be run after the intial data creation in R is completed

##################################################################
wdrive <- file.path('~/YOUR DRIVE HERE')
setwd(wdrive)
#####################################################################
require(tm)
require(stringr)
require(wordcloud)
load("project_data")
ls()
#####################################################################
# Plotting the most frequent words
#####################################################################
nohandles <- str_replace_all(firstpull$text, "@\\w+", "")
wordCorpus <- Corpus(VectorSource(nohandles))
wordCorpus <- tm_map(wordCorpus, removePunctuation)
wordCorpus <- tm_map(wordCorpus, content_transformer(tolower))
wordCorpus <- tm_map(wordCorpus, 
                     removeWords, stopwords("english"))
wordCorpus <- tm_map(wordCorpus, removeWords, 
                     c("amp", "2yo", "3yo", "4yo"))
wordCorpus <- tm_map(wordCorpus, stripWhitespace)

pal <- brewer.pal(9,"YlGnBu")
pal <- pal[-(1:4)]

set.seed(123)
wordcloud(words = wordCorpus, scale=c(10,0.1), 
          max.words=100, random.order=FALSE, rot.per=0.35, 
          use.r.layout=FALSE, colors=pal)


nohandles2 <- str_replace_all(threeday$text, "@\\w+", "")
wordCorpus2 <- Corpus(VectorSource(nohandles2))
wordCorpus2 <- tm_map(wordCorpus2, removePunctuation)
wordCorpus2 <- tm_map(wordCorpus2, content_transformer(tolower))
wordCorpus2 <- tm_map(wordCorpus2, 
                     removeWords, stopwords("english"))
wordCorpus2 <- tm_map(wordCorpus2, removeWords, 
                     c("amp", "2yo", "3yo", "4yo"))
wordCorpus2 <- tm_map(wordCorpus2, stripWhitespace)

pal <- brewer.pal(9,"YlGnBu")
pal <- pal[-(1:4)]

set.seed(123)
wordcloud(words = wordCorpus2, scale=c(10,0.1), 
          max.words=100, random.order=FALSE, rot.per=0.35, 
          use.r.layout=FALSE, colors=pal)
#####################################################################
# Plotting the most tweeted people word cloud
#####################################################################
friends <- str_extract_all(firstpull$text, "@\\w+")
namesCorpus <- Corpus(VectorSource(friends))
set.seed(246)
wordcloud(words = namesCorpus,
          max.words=100, random.order=FALSE, rot.per=0.35, 
          use.r.layout=FALSE, colors=pal)

friends2 <- str_extract_all(threeday$text, "@\\w+")
namesCorpus2 <- Corpus(VectorSource(friends2))
set.seed(246)
wordcloud(words = namesCorpus2,
          max.words=100, random.order=FALSE, rot.per=0.35, 
          use.r.layout=FALSE, colors=pal)

#####################################################################
# Plotting the most tweeted hashtags word cloud
#####################################################################
hashtag <- str_extract_all(firstpull$text, "#\\w+")
hashtagCorpus <- Corpus(VectorSource(hashtag))
set.seed(369)
wordcloud(words = hashtagCorpus,
          max.words=100, random.order=FALSE, rot.per=0.35, 
          use.r.layout=FALSE, colors=pal)

hashtag2 <- str_extract_all(threeday$text, "#\\w+")
hashtagCorpus2 <- Corpus(VectorSource(hashtag2))
set.seed(369)
wordcloud(words = hashtagCorpus2,
          max.words=100, random.order=FALSE, rot.per=0.35, 
          use.r.layout=FALSE, colors=pal)