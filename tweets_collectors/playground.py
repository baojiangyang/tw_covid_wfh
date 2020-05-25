import tweepy
import csv
import json
import pandas as pd
from tw_utils import search_qualified_tweets, loc_to_state, get_n_recent_tweets
import sys

search_term = sys.argv[1]
print(search_term)
#search_terms = ['wfh', 'work from home', 'work remotely']
#date_since = "2020-05-14"
#date_until = "2020-05-22"
date_since = sys.argv[2]
date_until =sys.argv[3]

print('Starting to stream...')
search_qualified_tweets(search_term, date_since, date_until)
search_term_reformated = search_term.replace(" ", "_")
df = pd.read_json('data/{}.json'.format(search_term_reformated))

print(df.head(10))
print(df.shape)
print(df.created.unique())
print('finished collecting data for query: ' + str(search_term))

