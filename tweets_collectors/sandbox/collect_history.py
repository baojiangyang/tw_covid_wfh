import tweepy
import csv
import json
import pandas as pd
import sys
from sandbox_utils import search_qualified_tweets, loc_to_state, get_n_recent_tweets


file_name = sys.argv[1]
hist_file_name = sys.argv[2]
#search_term_reformated = search_term.replace(" ", "_")
df = pd.read_csv(file_name)

print(df.head(10))

print(df.shape)

print(df.screen_name.nunique())

df_users = df.screen_name.unique()
#wfh_users = wfh['name'].sample(n = 10)
print(type(df_users))


tweets_from_names = []

for i in df_users: 
    twts = get_n_recent_tweets(i)
    print('get ' + str(len(twts)) + ' tweets from user:' + str(i))
    tweets_from_names.extend(twts)

print(tweets_from_names[0])
print(len(tweets_from_names))

#data = tweets_to_df(tweets_from_names)

#with open('data/{}.json'.format('sample_users'), 'w') as f:
#    json.dump(data, f)
#    print('done!')
df_tweets  = pd.DataFrame(tweets_from_names, columns =['id', 'name','created','text','retweet_counts']) 
print(df_tweets.head(10)) 


#print(data.shape)
#print(data.head(10))
#print(data.name.nuniqe())



df_tweets.to_csv(hist_file_name, index = False)



