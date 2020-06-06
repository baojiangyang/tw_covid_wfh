
# Tweets collection with API (Key steps and command example)

### Step 1: search Tweets by query with Premium API

#### Example:  
##### query: "working from home" lang:en profile_country:"US" 
##### time range: 2020-05-03 2020-06-02 
##### output file: working_from_home_xxxxx.jsonl 

#### Command: 
##### cd tw_covid_wfh/tweets_collectors/premium 
##### python keyword_search.py '"working from home" lang:en profile_country:"US"' 2020-05-03 2020-06-02 working_from_home 

#### Output file: 
##### working_from_home_2020-05-03_2020-06-02.jsonl 

# BERT MODEL 
