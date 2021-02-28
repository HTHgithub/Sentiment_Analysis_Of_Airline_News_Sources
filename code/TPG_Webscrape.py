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
site_name = "TPG"

# Open and read the list of article URLs from The Points Guy
with open('TPG_Urls.csv') as urls:
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
        article_content = soup.find('div', {'class': 'beam-the-content'}).text
        article_content = article_content.translate(str.maketrans('', '', string.punctuation)).lower().replace('\n','').replace('\t','').replace('’','').replace('“','').replace('”','')

        # This site does not have comments so setting the comments for every article to an empty string
        article_comments = ""

        # Getting and cleaning the article date
        article_date = soup.find('div', {'class': 'timestamp'}).text
        article_date = article_date.translate(str.maketrans('', '', string.punctuation)).lower().replace('\n','').replace('\t','').replace('’','').replace('“','').replace('”','')

        # Getting the metadata JSON from the webpage
        pat = re.compile('var tpg = {(.*)};')
        m = pat.search(str(article_author))
        meta_data = m.group(0).replace('var tpg = ','').replace(';','')
        meta_data = json.loads(meta_data)

        # Extracting the author from the meta data
        article_author = meta_data["author"]

        # Getting and cleaning the title of the article
        article_title = soup.find('h1', {'class': 'title'}).text
        article_title = article_title.translate(str.maketrans('', '', string.punctuation)).lower().replace('\n','').replace('\t','').replace('’','').replace('“','').replace('”','')

        # Extracting the tags from the metadata
        article_tags = meta_data["eVar25"]
        article_tags = article_tags.translate(str.maketrans('', '', string.punctuation)).lower().replace('\n','').replace('\t','').replace('’','').replace('“','').replace('”','')

        # Writing the scraped data to a csv
        csv_path = 'C:/Users/Harmon/Desktop/MSDS/Practicum 1/'
        with open('raw_data.csv', 'a', newline='', encoding='utf-8') as csvfile:
            spamwriter = csv.writer(csvfile, delimiter=',')
            spamwriter.writerow([article_date, article_author, article_title, article_tags, article_content, article_comments, site_name])
