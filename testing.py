
import pandas as pd
import requests as req
import json
import re
import string
import csv
from bs4 import BeautifulSoup as bs
from urllib.request import Request, urlopen

site = 'https://onemileatatime.com/buy-american-miles/'
hdr = {'User-Agent': 'Mozilla/5.0'}

# Making the site request, getting and parsing the html
req = Request(site,headers=hdr)
page = urlopen(req)
soup = bs(page, 'lxml')

# Separating and cleaning the article content
article_content = soup.find('div', {'class': 'entry-content'}).text
article_content = article_content.translate(str.maketrans('', '', string.punctuation)).lower().replace('\n','').replace('\t','').replace('’','').replace('“','').replace('”','')
#print(article_content)


if soup.find('ol', {'class': 'comment-list'}) is not None:
    article_comments = soup.find('ol', {'class': 'comment-list'}).text
    article_comments = article_comments.translate(str.maketrans('', '', string.punctuation)).lower().replace('\n','').replace('\t','').replace('’','').replace('“','').replace('”','')

else:
    article_comments = ''

print(article_comments)


article_date = soup.find('time', {'class': 'entry-date published updated'}).text
article_date = article_date.translate(str.maketrans('', '', string.punctuation)).lower().replace('\n','').replace('\t','').replace('’','').replace('“','').replace('”','')
#print(article_date)

article_author = soup.find('span', {'class': 'author vcard'}).text 
#print(article_author)

article_title = soup.find('h1', {'class': 'entry-title'}).text
article_title = article_title.translate(str.maketrans('', '', string.punctuation)).lower().replace('\n','').replace('\t','').replace('’','').replace('“','').replace('”','')

article_tags = soup.find('span', {'class': 'cat-links'}).text
article_tags = article_tags.translate(str.maketrans('', '', string.punctuation)).lower().replace('\n','').replace('\t','').replace('’','').replace('“','').replace('”','')


