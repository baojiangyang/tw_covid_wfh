# Deep Learning Based Emotion Analysis for WFH Related Tweets

This doc is a summary of the main contents in this repository. This repository serves as a code library for Research Paper xxxxx (TBA after reviewing process).  

Outline
 1. Tweets collector 
 1.1 premium API config
 1.2 commands
 2. Fine-tuned BERT for emotion classification 
 2.1 model training
 2.2 prediction/inference
 3. Data Analysis 
 4.1 aggregators
 4.2 visualization
 4.3 discontinuity model

## Tweets collector 

We created this tweets collector to search for tweets follows certain conditions (e.g. contains a particular keywords, location filter, retweets filter, etc.) in a given time period, using the Twitter API.

Main features of the Tweets collector includes
 - You need to have Premium API access (see [here](https://developer.twitter.com/en/products/twitter-api/premium-apis) for more details)
 - The main tweets collector builds on the ["searchtweets" package](https://twitterdev.github.io/search-tweets-python/searchtweets.html) which has integration with Twitter Premium API
 - You need Python 3 environment
 - Output is in jsonl format
 - In repository, there are also example codes to convert jsonl format to csv tables

To run the tweets collector, you need to specify an advanced "query" and start/end date
> `mkdir tweets && cd tweets`
> `git clone git@github.com:youngchrisyang/tw_covid_wfh`

###  Example:

*Query*:  

> "working from home" lang:en profile_country:"US"

*Time range*: 

> Between 2020-05-03 and 2020-06-02

*Output file name*:  

> working_from_home_2020-05-03_2020-06-02.jsonl

*Commands:*
> `cd tw_covid_wfh/tweets_collectors/premium`
> `python keyword_search.py '"working from home" lang:en profile_country:"US"' 2020-05-03 2020-06-02 working_from_home`

*If you need to convert the .jsonl file to a .csv file:*
> `cd tw_covid_wfh/tweets_collectors/sandbox`
> `python jsonl_to_csv_transformer.py <jsonl file name> <csv file name>`

## Fine-tuned BERT models for emotion classification 

Environment:

> Python 3
> Tensorflow 1.12
> CUDA 10.0

**Step 1**: Reformat training data to generate text-label pair

> `cd tw_covid_wfh/bert_models/`
> `python affect_binary_data.py <label name>`

**Step 2**: Model training - fine tuning the BERT model

> `python affect_binary_model.py <label name> <learning rate> <number of epoches>`

**Step 3**: Model inference - making predictions with text data as input
> `python affect_binary_predictor.py <label name>`


