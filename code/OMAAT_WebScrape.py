# importing necessary libraries for scraping and cleaning
import pandas as pd
import requests as req
import json
import re
import string
import csv
from bs4 import BeautifulSoup as bs
from urllib.request import Request, urlopen

# setting a constant for the site name 
site_name = "OMAAT"

# Open and read the list of article URLs from One Mile At A Time
with open('OMAAT_Urls.csv') as urls:
    sr = csv.reader(urls,delimiter=',')

    # Loop through every row in the URL csv and scrape the corresponding webpage
    for row in sr:

        # Setting the site URL and setting the headers to be a common browser
        site = row[0]
        hdr = {'User-Agent': 'Mozilla/5.0'}

        # Making the site request, getting and parsing the html
        req = Request(site,headers=hdr)
        page = urlopen(req)
        soup = bs(page, 'lxml')

        # Separating and cleaning the article content
        article_content = soup.find('div', {'class': 'entry-content'}).text
        article_content = article_content.translate(str.maketrans('', '', string.punctuation)).lower().replace('\n','').replace('\t','').replace('’','').replace('“','').replace('”','')

        # Scraping and cleaning article comments if they exist
        # Set comments to empty string if there are none
        if soup.find('ol', {'class': 'comment-list'}) is not None:
            article_comments = soup.find('ol', {'class': 'comment-list'}).text
            article_comments = article_comments.translate(str.maketrans('', '', string.punctuation)).lower().replace('\n','').replace('\t','').replace('’','').replace('“','').replace('”','')
        else:
            article_comments = ''

        # Getting and cleaning the article date
        article_date = soup.find('time', {'class': 'entry-date published updated'}).text
        article_date = article_date.translate(str.maketrans('', '', string.punctuation)).lower().replace('\n','').replace('\t','').replace('’','').replace('“','').replace('”','')

        # Getting the author of the article
        article_author = soup.find('span', {'class': 'author vcard'}).text 

        # Getting the title of the article
        article_title = soup.find('h1', {'class': 'entry-title'}).text
        article_title = article_title.translate(str.maketrans('', '', string.punctuation)).lower().replace('\n','').replace('\t','').replace('’','').replace('“','').replace('”','')

        # Getting the article tags
        article_tags = soup.find('span', {'class': 'cat-links'}).text
        article_tags = article_tags.translate(str.maketrans('', '', string.punctuation)).lower().replace('\n','').replace('\t','').replace('’','').replace('“','').replace('”','')

        # Writing the scraped data to a csv
        csv_path = 'C:/Users/Harmon/Desktop/MSDS/Practicum 1/'
        with open('raw_data.csv', 'a', newline='', encoding='utf-8') as csvfile:
            spamwriter = csv.writer(csvfile, delimiter=',')
            spamwriter.writerow([article_date, article_author, article_title, article_tags, article_content, article_comments, site_name])
