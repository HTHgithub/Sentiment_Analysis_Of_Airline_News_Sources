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
library("dplyr")
#library("sqldf")
library("stringr")

#############################################################
# Importing and formatting the data
#############################################################

# Reading in the data
dat = read.csv("C:/Users/Harmon/Desktop/MSDS/Practicum 1/raw_data.csv", header = TRUE)

# Looking at the different data
head(dat)
dat
str(dat)

# Converting the data from factors to characters
dat$article_author = as.character(dat$article_author)
dat$article_title = as.character(dat$article_title)
dat$article_content = as.character(dat$article_content)
dat$article_comments = as.character((dat$article_comments))
dat$article_tags = as.character(dat$article_tags)
dat$article_date = as.character(dat$article_date)
dat$site = as.character(dat$site)

# replacing shortened months with full months to standardize the format
dat$article_date = str_replace(dat$article_date,"jan ","january ")
dat$article_date = str_replace(dat$article_date,"feb ","february ")
dat$article_date = str_replace(dat$article_date,"mar ","march ")
dat$article_date = str_replace(dat$article_date,"apr ","april ")
dat$article_date = str_replace(dat$article_date,"jun ","june ")
dat$article_date = str_replace(dat$article_date,"jul ","july ")
dat$article_date = str_replace(dat$article_date,"aug ","august ")
dat$article_date = str_replace(dat$article_date,"sep ","september ")
dat$article_date = str_replace(dat$article_date,"oct ","october ")
dat$article_date = str_replace(dat$article_date,"nov ","november ")
dat$article_date = str_replace(dat$article_date,"dec ","december ")
dat$article_date = str_replace(dat$article_date,"4d ago","january 30 2021")

# Converting date from characters to a date format
dat$article_date = as.Date(dat$article_date,"%B %d %Y")

#############################################################
# Subsetting the data by certain factors
#############################################################

#OMMAT Data
ommat_all = dplyr::filter(dat,dat$site == "OMAAT")

#TPG Data
tpg_all = dplyr::filter(dat,dat$site == "TPG")

#############################################################
# Sentiment Analysis and Testing
#############################################################

# Method for stripping some additional words from the text
content = Corpus(VectorSource(dat$article_content))
content = tm_map(content, removeNumbers)
content = tm_map(content, removeWords, stopwords("english"))
content = tm_map(content, stripWhitespace)
content = tm_map(content, stemDocument)

# Creating a vector of sentiment scores from the article content using the "Syuzhet" Method
syuzhet_vector <- get_sentiment(dat$article_content, method="syuzhet")
head(syuzhet_vector)
summary(syuzhet_vector)

# Creating a vector of sentiment scores from the article comments using the "Syuzhet" Method
sv_comments <- get_sentiment(dat$article_comments, method="syuzhet")

quickplot(dat$article_date,syuzhet_vector)


# Using a different type of sentiment score for
d = get_nrc_sentiment(dat$article_content)


###########################################################
# Emotion analysis of different articles
###########################################################
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


#############################################################
# Testing Area
#############################################################

?filter

dplyr::filter(dat, article_date == "4d ago")

dplyr::filter(dat, grepl(article_tags,"american airlines"))

dat$article_date = str_replace(dat$article_date,"jan ","january ")
dat$article_date = str_replace(dat$article_date,"feb ","february ")
dat$article_date = str_replace(dat$article_date,"mar ","march ")
dat$article_date = str_replace(dat$article_date,"apr ","april ")
dat$article_date = str_replace(dat$article_date,"jun ","june ")
dat$article_date = str_replace(dat$article_date,"jul ","july ")
dat$article_date = str_replace(dat$article_date,"aug ","august ")
dat$article_date = str_replace(dat$article_date,"sep ","september ")
dat$article_date = str_replace(dat$article_date,"oct ","october ")
dat$article_date = str_replace(dat$article_date,"nov ","november ")
dat$article_date = str_replace(dat$article_date,"dec ","december ")
dat$article_date = str_replace(dat$article_date,"4d ago","january 30 2021")
dat$article_date

#%B %d %Y


?which

length(dat$article_tags)

# Splitting tags by differentt criteria
aa = grep("(.*)american(.*)",dat$article_tags)
length(aa)

delta = grep("(.*)delta(.*)",dat$article_tags)
length(delta)

united = grep("(.*)united(.*)",dat$article_tags)
length(united)

tech = grep("(.*)tech(.*)",dat$article_tags)
length(tech)





which(grepl(dat$article_tags,"american airlines"))

dat$article_tags[aa]

dat$article_tags[delta]

dat$article_tags[tech]

tech1 = grep("(.*)technology(.*)",dat$article_content)
length(tech1)

dat$article_tags[tech1]

dat$article_title[tech1]

syuzhet_vector[tech1]



tech1

aa

which(tech1 == aa)



summary(syuzhet_vector)

hs = which(syuzhet_vector >= 14.575)
hs

dat$article_tags[hs]

aa %in% hs

length(intersect(aa,hs))
length(intersect(delta,hs))
length(intersect(united,hs))





sv_comments
sv_comments[aa]

#OMMAT Data
ommat_all = dplyr::filter(dat,dat$site == "OMAAT")
ommat_ind = grep("(.*)OMAAT(.*)",dat$site)

#TPG Data
tpg_all = dplyr::filter(dat,dat$site == "TPG")
tpg_ind = grep("(.*)TPG(.*)",dat$site)

dat$site


quickplot()

test = str_replace_all(dat$article_tags,"american express", "")

aa = grep("(.*)american(.*)",test)
length(aa)

mean(syuzhet_vector[aa])
mean(syuzhet_vector[delta])
mean(syuzhet_vector[united])

mean(sv_comments[aa])
mean(sv_comments[delta])
mean(sv_comments[united])

ggplot(data = ommat_all, aes(x = ommat_all$article_date, y = syuzhet_vector[ommat_ind])) +
  geom_point() +
  geom_smooth(method = "lm")

ggplot(data = tpg_all, aes(x = tpg_all$article_date, y = syuzhet_vector[tpg_ind])) +
  geom_point() +
  geom_smooth(method = "lm")



ggplot(data = dat[aa,], aes(x =  dat$article_date[aa], y = syuzhet_vector[aa])) +
  geom_point() +
  geom_smooth(method = "lm")

ggplot(data = dat[delta,], aes(x =  dat$article_date[delta], y = syuzhet_vector[delta])) +
  geom_point() +
  geom_smooth(method = "lm")

ggplot(data = dat[united,], aes(x =  dat$article_date[united], y = syuzhet_vector[united])) +
  geom_point() +
  geom_smooth(method = "lm")
