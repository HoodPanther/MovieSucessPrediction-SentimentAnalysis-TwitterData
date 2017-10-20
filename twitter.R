
library(dplyr)
library(twitteR)

#Enter search term
searchTerm <- "HASHTAG GOES HERE"

#Setup with the personal secret keys from your Twitter account
setup_twitter_oauth("ENTER 4 API KEYS HERE")

#Enter number of max tweets
maxTweets <- 1000

#Hit the API with the searchterm and the max number of tweets
tweets <- TweetFrame(searchTerm, maxTweets)
tweets %>% as.data.frame()
tweets

#Exporting tweets into an excel file
xx <- lapply(tweets, unlist)
max <- max(sapply(xx, length))
do.call(rbind, lapply(xx, function(z)c(z, rep(NA, max-length(z)))))
summary(xx)
write.xlsx(xx, "File path goes here")