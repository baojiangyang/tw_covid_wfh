
# Tweets collection with API (Key steps and command example)

### Step 1: search Tweets by query with Premium API

#### Example:  
##### query: "working from home" lang:en profile_country:"US" 
##### time range: 2020-05-03 2020-06-02 

#### Command: 
##### cd tw_covid_wfh/tweets_collectors/premium 
##### python keyword_search.py '"working from home" lang:en profile_country:"US"' 2020-05-03 2020-06-02 working_from_home 

#### Output file: 
##### working_from_home_2020-05-03_2020-06-02.jsonl 


### Step 2: JSONL to CSV after reformating fields

#### Command: 
##### cd tw_covid_wfh/tweets_collectors/sandbox 
##### python jsonl_to_csv_transformer.py "/home/paperspace/research/twitter/tw_covid_wfh/tweets_collectors/premium/work_remotely_2020-05-03_2020-06-02.jsonl" "work_remotely_2020-05-03_2020-06-02.csv"
##### output file: work_remotely_2020-05-03_2020-06-02.csv



### Step 3: Query related tweets -> User tweets history with SANDBOX API

#### Command: 
##### cd tw_covid_wfh/tweets_collectors/sandbox 
##### python collect_history.py "work_remotely_2020-05-03_2020-06-02.csv" "<outputname>.csv"



# BERT MODEL 
