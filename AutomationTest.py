
import pandas as pd
import requests as req
import json
import re
import string
import csv
from bs4 import BeautifulSoup as bs
from urllib.request import Request, urlopen

site_name = "TPG"

with open('TPG_Urls.csv') as urls:
    sr = csv.reader(urls,delimiter=',')
    for row in sr:
        #print(row[0])

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
        #print(article_content)

        article_comments = ""

        article_date = soup.find('div', {'class': 'timestamp'}).text
        article_date = article_date.translate(str.maketrans('', '', string.punctuation)).lower().replace('\n','').replace('\t','').replace('’','').replace('“','').replace('”','')
        #print(article_date)

        article_author = soup.find('script', {'id': 'tpg-global-js-js-extra'})
        pat = re.compile('var tpg = {(.*)};')
        m = pat.search(str(article_author))
        meta_data = m.group(0).replace('var tpg = ','').replace(';','')
        meta_data = json.loads(meta_data)
        #print(meta_data["author"])
        article_author = meta_data["author"]

        article_title = soup.find('h1', {'class': 'title'}).text
        article_title = article_title.translate(str.maketrans('', '', string.punctuation)).lower().replace('\n','').replace('\t','').replace('’','').replace('“','').replace('”','')

        article_tags = meta_data["eVar25"]
        article_tags = article_tags.translate(str.maketrans('', '', string.punctuation)).lower().replace('\n','').replace('\t','').replace('’','').replace('“','').replace('”','')
        #print(article_tags)


        csv_path = 'C:/Users/Harmon/Desktop/MSDS/Practicum 1/'
        with open('backup_data.csv', 'a', newline='', encoding='utf-8') as csvfile:
            spamwriter = csv.writer(csvfile, delimiter=',')
            spamwriter.writerow([article_date, article_author, article_title, article_tags, article_content, article_comments, site_name])


#article_date,article_author,article_title,article_tags,article_content,article_comments,site_name