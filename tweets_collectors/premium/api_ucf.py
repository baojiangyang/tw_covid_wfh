
## INIT
API_KEY = '1EfZQhitx7xPfHz25VCLpfjtR'
API_SECRET_KEY = '5GZZcn5EFinqTggFeZKH3ObuOp019vYwPxNTqNvyZM78b5VIkh'
DEV_ENVIRONMENT_LABEL = 'covidwfh'
API_SCOPE = '30day'  # 'fullarchive' for full archive, '30day' for last 31 days

import yaml
config = dict(
    search_tweets_api=dict(
        account_type='premium',
        endpoint=f"https://api.twitter.com/1.1/tweets/search/{API_SCOPE}/{DEV_ENVIRONMENT_LABEL}.json",
        consumer_key=API_KEY,
        consumer_secret=API_SECRET_KEY
    )
)

with open('twitter_keys.yaml', 'w') as config_file:
    yaml.dump(config, config_file, default_flow_style=False)

