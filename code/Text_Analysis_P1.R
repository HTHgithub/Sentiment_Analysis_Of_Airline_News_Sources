#############################################################
# Installing packages that might be needed for cleaning and analysis
#############################################################
install.packages("tm")  # for text mining
install.packages("SnowballC") # for text stemming
install.packages("wordcloud") # word-cloud generator 
install.packages("RColorBrewer") # color palettes
install.packages("syuzhet") # for sentiment analysis
install.packages("ggplot2") # for plotting graphs
install.packages("quantmod")
install.packages("tidyquant")
remove.packages("rlang")
install.packages("rlang")
remove.packages("glue")
install.packages("glue")
install.packages("rsample")
install.packages("tibbletime")
install.packages("smooth")

update.packages("recipes")

#############################################################
# Loading required packages
#############################################################
library("tm")
library("SnowballC")
library("wordcloud")
library("RColorBrewer")
library("syuzhet")
library("ggplot2")
library("dplyr")
#library("sqldf")
library("stringr")
library("rlang")
library("tidyquant")
library("quantmod")
library("recipes")
library("tibbletime")
library(ggpubr)

#############################################################
# Importing, cleaning, and formatting the data
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

# Removing the "american express" tag
dat$article_tags = str_replace_all(dat$article_tags,"american express", "")

#############################################################
# Subsetting the data by certain factors
#############################################################

#OMMAT Data
ommat_all = dplyr::filter(dat,dat$site == "OMAAT")

#TPG Data
tpg_all = dplyr::filter(dat,dat$site == "TPG")

# American Airlines data
aa = grep("(.*)american(.*)",dat$article_tags)
aa_o = grep("(.*)american(.*)",ommat_all$article_tags)
aa_t = grep("(.*)american(.*)",tpg_all$article_tags)

# Delta data
delta = grep("(.*)delta(.*)",dat$article_tags)
delta_o = grep("(.*)delta(.*)",ommat_all$article_tags)
delta_t = grep("(.*)delta(.*)",tpg_all$article_tags)

# United data
united = grep("(.*)united(.*)",dat$article_tags)
united_o = grep("(.*)united(.*)",ommat_all$article_tags)
united_t = grep("(.*)united(.*)",tpg_all$article_tags)

tech = grep("(.*)tech(.*)",dat$article_tags)
length(tech)

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
syuzhet_vector = get_sentiment(dat$article_content, method="syuzhet")
head(syuzhet_vector)
summary(syuzhet_vector)

# Creating a vector of sentiment scores from the article content using the "Bing" Method
bing_vector = get_sentiment(dat$article_content, method = "bing")

# Creating a vector of sentiment scores from the article comments using the "afinn" Method
afinn_vector = get_sentiment(ommat_all$article_comments, method = "afinn")
bcv = get_sentiment(ommat_all$article_comments, method = "bing")

# plotting article sentiment by airline
quickplot(bing_vector[aa], xlab = "Sentiment Score", ylab="Count", main="American Airlines Article Sentiment Score")
quickplot(bing_vector[delta], xlab = "Sentiment Score", ylab="Count", main="Delta Airlines Article Sentiment Score")
quickplot(bing_vector[united], xlab = "Sentiment Score", ylab="Count", main="United Airlines Article Sentiment Score")

# plotting comment sentiment by airline
quickplot(afinn_vector[aa_o], xlab = "Sentiment Score", ylab="Count", main="American Airlines Comment Sentiment Score")
quickplot(afinn_vector[delta_o], xlab = "Sentiment Score", ylab="Count", main="Delta Airlines Comment Sentiment Score")
quickplot(afinn_vector[united_o], xlab = "Sentiment Score", ylab="Count", main="United Airlines Comment Sentiment Score")

quickplot(bing_vector[aa_o])
quickplot(bing_vector[aa_t])

quickplot(bing_vector[delta_o])
quickplot(bing_vector[delta_t])

quickplot(bing_vector[united_o])
quickplot(bing_vector[united_t])


t.test(bing_vector[aa_o],bing_vector[aa_t], var.equal = TRUE)
t.test(bing_vector[delta_o],bing_vector[delta_t], var.equal = TRUE)
t.test(bing_vector[united_o],bing_vector[united_t], var.equal = TRUE)


# Looking at normality of article sentiment of airlines
ggqqplot(bing_vector[aa], main="QQ Plot of American Airlines Article Sentiment")
ggqqplot(bing_vector[delta], main="QQ Plot of Delta Airlines Article Sentiment")
ggqqplot(bing_vector[united], main="QQ Plot of United Airlines Article Sentiment")

# Looking at differences in variance of article sentiment scores between airlines
var.test(bing_vector[aa], bing_vector[delta], alternative = "two.sided")
var.test(bing_vector[aa], bing_vector[united], alternative = "two.sided")
var.test(bing_vector[united], bing_vector[aa], alternative = "two.sided")

# Testing if there is a significant difference in article sentiment mean between airlines
t.test(bing_vector[aa],bing_vector[delta], var.equal = TRUE)
t.test(bing_vector[aa],bing_vector[united], var.equal = TRUE)
t.test(bing_vector[united],bing_vector[delta], var.equal = TRUE)

mean(bing_vector[aa])
mean(bing_vector[delta])
mean(bing_vector[united])

# Looking at normality of comment sentiment of airlines
ggqqplot(afinn_vector[aa])
ggqqplot(afinn_vector[delta])
ggqqplot(afinn_vector[united])

# Looking at differences in variance of article sentiment scores between airlines
var.test(afinn_vector[aa_o], afinn_vector[delta_o], alternative = "two.sided")
var.test(afinn_vector[aa_o], afinn_vector[united_o], alternative = "two.sided")
var.test(afinn_vector[united_o], afinn_vector[aa_o], alternative = "two.sided")

# Testing if there is a significant difference in article sentiment mean between airlines
wilcox.test(afinn_vector[aa_o],afinn_vector[delta_o], var.equal = TRUE)
wilcox.test(afinn_vector[aa_o],afinn_vector[united_o], var.equal = TRUE)
wilcox.test(afinn_vector[united_o],afinn_vector[delta_o], var.equal = TRUE)

mean(afinn_vector[aa_o])
mean(afinn_vector[delta_o])
mean(afinn_vector[united_o])

mean(bcv[aa])
mean(bcv[delta])
mean(bcv[united])

# Creating a vector of sentiment scores from the article comments using the "Syuzhet" Method
sv_comments = get_sentiment(dat$article_comments, method="syuzhet")

quickplot(dat$article_date,syuzhet_vector)


# Using a different type of sentiment score for
d = get_nrc_sentiment(dat$article_content)


###########################################################
# Testing Emotion analysis of different articles
###########################################################
#transpose
td = data.frame(t(d))
#The function rowSums computes column sums across rows for each level of a grouping variable.
td_new = data.frame(rowSums(td[2:1435]))
#Transformation and cleaning
names(td_new)[1] = "count"
td_new = cbind("sentiment" = rownames(td_new), td_new)
rownames(td_new) = NULL
td_new2 = td_new[1:8,]
#Plot One - count of words associated with each sentiment
quickplot(sentiment, data=td_new2, weight=count, geom="bar", fill=sentiment, ylab="count")+ggtitle("Article Sentiments")


#############################################################
# Testing Area for experimenting with different code and analysis techniques
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

aa_o = grep("(.*)american(.*)",ommat_all$article_tags)
aa_t = grep("(.*)american(.*)",tpg_all$article_tags)

delta = grep("(.*)delta(.*)",dat$article_tags)
length(delta)

delta_o = grep("(.*)delta(.*)",ommat_all$article_tags)
delta_t = grep("(.*)delta(.*)",tpg_all$article_tags)

united = grep("(.*)united(.*)",dat$article_tags)
length(united)

united_o = grep("(.*)united(.*)",ommat_all$article_tags)
united_t = grep("(.*)united(.*)",tpg_all$article_tags)

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



ggplot(data = dat[aa,], aes(x =  dat$article_date[aa], y = bing_vector[aa])) +
  geom_point() +
  geom_smooth(method = "lm")

ggplot(data = dat[delta,], aes(x =  dat$article_date[delta], y = bing_vector[delta])) +
  geom_point() +
  geom_smooth(method = "lm")

ggplot(data = dat[united,], aes(x =  dat$article_date[united], y = bing_vector[united])) +
  geom_point() +
  geom_smooth(method = "lm")




ggplot(data = dat[aa,], aes(x =  dat$article_date[aa], y = bing_vector[aa])) +
  stat_summary_bin(fun.y="sum", geom="point", bins=104)

ggplot(data = dat[delta,], aes(x =  dat$article_date[delta], y = bing_vector[delta])) +
  stat_summary_bin(fun.y="sum", geom="bar", bins=24)

ggplot(data = dat[united,], aes(x =  dat$article_date[united], y = bing_vector[united])) +
  stat_summary_bin(fun.y="sum", geom="bar", bins=24)



getSymbols("AAL", from='2019-01-01', to='2021-01-31', warnings = FALSE, auto.assign = TRUE)
getSymbols("DAL", from='2019-01-01', to='2021-01-31', warnings = FALSE, auto.assign = TRUE)
getSymbols("UAL", from='2019-01-01', to='2021-01-31', warnings = FALSE, auto.assign = TRUE)

aal = tq_get('AAL',from='2019-01-01', to='2021-01-31', get="stock.prices")

head(AAL)

afinn_vector = get_sentiment(dat$article_content, method = "afinn")

ggplot(data = dat[aa,], aes(x = dat$article_date[aa], y = bing_vector[aa])) +
  stat_summary_bin(fun.y="mean", geom="point", bins=24) +
  geom_point(data = AAL, aes(x= Index, y=AAL.Open), color = "cyan") +
  labs()

ggplot(data = dat[aa,], aes(x = dat$article_date[aa], y = afinn_vector[aa], color="Sentiment")) +
  stat_summary_bin(fun.y="mean", geom="point", bins=24) +
  stat_summary_bin(fun.y="mean", geom="line", bins=24) +
  geom_point(data = AAL, aes(x= Index, y=AAL.Open, color = "Stock Price")) +
  labs(title="Sentiment Scores and Stock Price of AA", x="Article Date", y="", colour = "Legend") +
  theme(legend.position = "right") +
  guides(color = "legend") 


ggplot(data = dat[delta,], aes(x = dat$article_date[delta], y = afinn_vector[delta], color="Sentiment")) +
  stat_summary_bin(fun.y="mean", geom="point", bins=24) +
  stat_summary_bin(fun.y="mean", geom="line", bins=24) +
  geom_point(data = DAL, aes(x= Index, y=DAL.Open, color = "Stock Price")) +
  labs(title="Sentiment Scores and Stock Price of Delta", x="Article Date", y="", colour = "Legend") +
  theme(legend.position = "right") +
  guides(color = "legend") 

ggplot(data = dat[united,], aes(x = dat$article_date[united], y = afinn_vector[united], color="Sentiment")) +
  stat_summary_bin(fun.y="mean", geom="point", bins=24) +
  stat_summary_bin(fun.y="mean", geom="line", bins=24) +
  geom_point(data = UAL, aes(x= Index, y=UAL.Open, color = "Stock Price")) +
  labs(title="Sentiment Scores and Stock Price of United", x="Article Date", y="", colour = "Legend") +
  theme(legend.position = "right") +
  guides(color = "legend") 


cor.test(AAL$AAL.close,bing_vector[aa])

length(AAL$AAL.Close)


AAL$AAL.Close

bin_test = dat

bin_test = cbind(bin_test,bing_vector,afinn_vector)

bin_aa = as_tibble(bin_test[aa,])

head(bin_aa)

aa_avg_sent = bin_aa %>% 
  arrange(article_date) %>%
  as_tbl_time(index = article_date) %>%
  collapse_by("monthly", side="start", clean = TRUE) %>%
  group_by(article_date) %>%
  summarise(sent_bing = mean(bing_vector))

head(aa_avg_sent)

AAL_df = as.data.frame(AAL)


ccf(aa_avg_sent$sent_bing, as.numeric(AAL$AAL.Close),type = c("correlation"))

ccf(aa_avg_sent$sent_bing,type = c("correlation"))

ccf(bing_vector[aa], as.numeric(AAL$AAL.Close),type = c("correlation"), ylab = "Cross-Correlation")

ccf(bing_vector[delta], as.numeric(AAL$AAL.Close),type = c("correlation"), ylab = "Cross-Correlation")

ccf(bing_vector[united], as.numeric(AAL$AAL.Close),type = c("correlation"), ylab = "Cross-Correlation")

ccf(afinn_vector[aa_o], as.numeric(AAL$AAL.Close),type = c("correlation"), ylab = "Cross-Correlation")

ccf(afinn_vector[delta_o], as.numeric(AAL$AAL.Close),type = c("correlation"), ylab = "Cross-Correlation")

ccf(afinn_vector[united_o], as.numeric(AAL$AAL.Close),type = c("correlation"), ylab = "Cross-Correlation")

ccf(as.numeric(AAL$AAL.Close),afinn_vector[aa],type = c("correlation"), ylab = "Cross-Correlation")


?ccf

index(AAL)

AAL %>% 
  as_tbl_time(index = index(AAL)) %>%
  collapse_by("monthly", side="start", clean = TRUE) %>%
  group_by(AAL$AAL.Index) %>%
  summarise(mean_price = mean(AAL$AAL.Close))

?cut

?geom_smooth

?geom_line

??syuzhet
?get_sentiment

test = c(1:1435)

test[aa] = "aa"
test
test[delta] = "delta"
test[united] = "united"
test

?acf

??es
anno = annotateString(dat$article_content[1])

quickplot(bing_vector[aa], xlab = "Sentiment Score", ylab="Count", main="American Airlines Article Sentiment Score")
quickplot(bing_vector[delta], xlab = "Sentiment Score", ylab="Count", main="Delta Airlines Article Sentiment Score")
quickplot(bing_vector[united], xlab = "Sentiment Score", ylab="Count", main="United Airlines Article Sentiment Score")

