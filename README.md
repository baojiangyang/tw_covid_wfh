
# Tweets collection with API (Key steps and command example)

### Step 1: search Tweets by query with Premium API
####
Example:  \n 
query: "working from home" lang:en profile_country:"US" \n
time range: 2020-05-03 2020-06-02 \n
output file: working_from_home_xxxxx.jsonl \n

Command: \n
cd tw_covid_wfh/tweets_collectors/premium \n
python keyword_search.py '"working from home" lang:en profile_country:"US"' 2020-05-03 2020-06-02 working_from_home \n

Output file: \n
working_from_home_2020-05-03_2020-06-02.jsonl \n

# BERT MODEL 
