
import sys

SEARCH_QUERY = sys.argv[1]
print(SEARCH_QUERY)
#SEARCH_QUERY = 'wfh lang:en profile_country:"US"'
FROM_DATE = sys.argv[2]
TO_DATE = sys.argv[3]


RESULTS_PER_CALL = 500  # 100 for sandbox, 500 for paid tiers
#TO_DATE = '2020-05-28' # format YYYY-MM-DD HH:MM (hour and minutes optional)
#FROM_DATE = '2020-04-28'  # format YYYY-MM-DD HH:MM (hour and minutes optional)

MAX_RESULTS = 300000  # Number of Tweets you want to collect

# Script prints an update to the CLI every time it collected another X Tweets
PRINT_AFTER_X = 1000

FILENAME = str(sys.argv[4]) + '_'+ str(FROM_DATE) + '_' + str(TO_DATE) +'.jsonl'



import json
from searchtweets import load_credentials, gen_rule_payload, ResultStream

premium_search_args = load_credentials("twitter_keys.yaml",
                                       yaml_key="search_tweets_api",
                                       env_overwrite=False)

rule = gen_rule_payload(SEARCH_QUERY,
                        results_per_call=RESULTS_PER_CALL,
                        from_date=FROM_DATE,
                        to_date=TO_DATE
                        )
print(rule)


from searchtweets import ResultStream

rs = ResultStream(rule_payload=rule,
                  max_results=MAX_RESULTS,
                  **premium_search_args)
print(rs)

with open(FILENAME, 'a', encoding='utf-8') as f:
    n = 0
    for tweet in rs.stream():
        n += 1
        if n % PRINT_AFTER_X == 0:
            print('{0}: {1}'.format(str(n), tweet['created_at']))
        json.dump(tweet, f)
        f.write('\n')
print('done')

