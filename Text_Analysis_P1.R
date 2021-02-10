# Install
install.packages("tm")  # for text mining
install.packages("SnowballC") # for text stemming
install.packages("wordcloud") # word-cloud generator 
install.packages("RColorBrewer") # color palettes
install.packages("syuzhet") # for sentiment analysis
install.packages("ggplot2") # for plotting graphs
# Load
library("tm")
library("SnowballC")
library("wordcloud")
library("RColorBrewer")
library("syuzhet")
library("ggplot2")



dat = read.csv("C:/Users/Harmon/Desktop/MSDS/Practicum 1/raw_data.csv", header = TRUE)

head(dat)
dat

str(dat)


dat$article_author = as.character(dat$article_author)
dat$article_title = as.character(dat$article_title)
dat$article_content = as.character(dat$article_content)
dat$article_comments = as.character((dat$article_comments))
dat$article_tags = as.character(dat$article_tags)

content = Corpus(VectorSource(dat$article_content))
content = tm_map(content, removeNumbers)

content = tm_map(content, removeWords, stopwords("english"))

content = tm_map(content, stripWhitespace)

content = tm_map(content, stemDocument)


syuzhet_vector <- get_sentiment(dat$article_content, method="syuzhet")
head(syuzhet_vector)
summary(syuzhet_vector)

?get_sentiment


d = get_nrc_sentiment(dat$article_content)



#transpose
td<-data.frame(t(d))
#The function rowSums computes column sums across rows for each level of a grouping variable.
td_new <- data.frame(rowSums(td[2:1435]))
#Transformation and cleaning
names(td_new)[1] <- "count"
td_new <- cbind("sentiment" = rownames(td_new), td_new)
rownames(td_new) <- NULL
td_new2<-td_new[1:8,]
#Plot One - count of words associated with each sentiment
quickplot(sentiment, data=td_new2, weight=count, geom="bar", fill=sentiment, ylab="count")+ggtitle("Article Sentiments")


dat1 = cbind(dat$article_tags,syuzhet_vector,dat$site)



head(dat1)
tail(dat1)

















