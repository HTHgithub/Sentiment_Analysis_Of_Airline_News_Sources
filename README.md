
## Sentiment Analysis of Airline News Sources

I work as a developer for a major airline which is currently going through a technology transformation. As part of this transformation, one question that was recently posed was, "How does our technology stack compare to other airlines?" After some discussion it was decided that there was no real way to know. However, in this conversation it was thought that certain airlines had a reputation for being more technologically advanced and reporting more on technology. This got me thinking about how different airlines are reported on and how this reporting impacts public opinion.<br>
<br>
To try and answer these questions text and sentiment analysis was performed on a couple of popular travel websites that do reporting on major airlines. The goal was to use the written article and any available comments to try and find patterns or differences on how different airlines were reported on, and if this reporting had any impact on public opinion or sentiment.


## Data

The text data for this project was scrpaed from two popular travel websites [The Points Guy](https://thepointsguy.com/) and [One Mile At A Time](https://onemileatatime.com/), with the focus being on three main airlines: American Airlines, Delta, and United. This project was limited to articles dating between January 1st, 2019 and January 31st, 2021. The data chosen to be scraped from each article, if available, was:<br>

- Date the article was published
- The author of the article
- Title of the article
- The tags of the article
- The article content or the writing of the article
- Any comments on the article if they are available
- The name of the site the data was scraped from

## Data Collection and Cleaning

The first step of data collection was to create a list of URL's from the two websites that were within the date range and written about one of the three chosen airlines. This was done manually since it only needed to be done once and automating it would have probably taken more time. The URL's were compiled into two csv's, one for each website. There were 744 article URL's from One Mile At A Time, and 691 from the The Points Guy that fit the criteria, totaling a little under 1500 articles.
<br>
<br>
Python was then used to write webscraping code for each of the two websites. This code took as input the list of URL's then iterated through the list scraping the data mentioned in the above section from each article. This scraped data from each site was then written to a common csv. During the scraping process, punctuation and some whitespace characters were removed from the article content and comments to help with analysis. Once the scraping was completed and the data was compiled into a singular file it was passed into R for further cleaning.
<br>
<br>
One of the bigger challenges was unifying the dates between the two websites as they each used different date formats. To create a single date format all of the dates were first converted to strings. The `str_replace()` function from the *stringr* library was used to replace shortened month names with the full month name (i.e. "jan" to "january"). Once this was completed and after some research into different date formats the date string were converted into date objects using the `as.Date()` method with the format `"%B %d %Y"`. This format corresponds to the full month name, followed by the day of the month, followed by the four digit year (i.e. "january 1 2021"). This conversion and unification allowed for any time based analysis to be done when analyzing the data.
<br>
<br>
The article tags was another area where some data clean up was needed. When splitting the data by different airlines the article tags were used decide what airline the article was written about. When first splitting I noticed that American Airlines had much fewer data points than either Delta or United. After looking at different subsets of tags I realized that some articles used "American" to signify American Airlines, while others used "American Airlines". After rerunning the splitting just looking for the "American" tag American Airlines has significantly *more* data points than the other two airlines. Going back to the tags I realized that a common tag was "American Express" since their credit card occasionally offered different rewards for flying on certain airlines there were a decent number of articles written about that. Since there was no comparision of different rewards programs or different credit cards planned, the tag "American Express" was simply removed from all of articles that had it as a tag. This led to a roughly even split of articles between the three airlines.

## Data Analysis

## Results

## Conclusion and Future Work

## References