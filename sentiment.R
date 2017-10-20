install.packages("data.table")
library(data.table)

data = fread("File Location", 
             strip.white=T, sep=",", header=T, na.strings=c(""," ", "NA","nan", "NaN", "nannan"))
View(data)


library(dplyr)


library(tidytext)


#Original Data
tidy_text <- data %>%
  unnest_tokens(word, Tweet)
tidy_text[1:20]

#Removing stop words
data(stop_words)
tidy_text <- tidy_text %>%
  anti_join(stop_words)

#Count most common words
tidy_text %>%
  count(word, sort = TRUE) 

#Plot of word counts
library(ggplot2)
tidy_text %>%
  count(word, sort = TRUE) %>%
  filter(n > 25) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_bar(stat = "identity") +
  xlab(NULL) +
  coord_flip()

#Sentiment Analysis
nrcjoy <- get_sentiments("nrc") %>% 
  filter(sentiment == "joy")

tidy_text %>%
  inner_join(nrcjoy) %>%
  count(word, sort = TRUE)

#Sentiment score
sentiment <- tidy_text %>%
  inner_join(get_sentiments("bing")) %>%
  count(word, sentiment, sort = TRUE)

head(sentiment)

random.words <- sample(sentiment$sentiment, 100, replace = TRUE, prob = NULL)

counts <- as.data.frame(table(random.words))
counts
summary(random.words)

#WORD CLOUD
library(wordcloud)

tidy_text %>%
  anti_join(stop_words) %>%
  count(word) %>%
  with(wordcloud(word, n, max.words = 50))

#Reshaping the wordcloud
library(reshape2)

tidy_text %>%
  inner_join(get_sentiments("bing")) %>%
  count(word, sentiment, sort = TRUE) %>%
  acast(word ~ sentiment, value.var = "n", fill = 0) %>%
  comparison.cloud(colors = c("#F8766D", "#00BFC4"),
                   max.words = 25)

