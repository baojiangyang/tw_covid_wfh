import tweepy
import csv
import json

if True: # diaryofchrisyang
    consumer_key = ''
    consumer_secret = ''

    access_token = ''
    access_token_secret = ''
if False: # ucf
    consumer_key = ''
    consumer_secret = ''

    access_token = ''
    access_token_secret = ''

# AUTH

auth = tweepy.OAuthHandler(consumer_key, consumer_secret)

auth.set_access_token(access_token, access_token_secret)

api = tweepy.API(auth, wait_on_rate_limit=True)

print("done auth!")

#public_tweets = api.home_timeline()
#for tweet in public_tweets:
#    print(tweet.text)
def loc_to_state(s):
    us_state_abbrev = {
            'Alabama': 'AL',
            'Alaska': 'AK',
            'American Samoa': 'AS',
            'Arizona': 'AZ',
            'Arkansas': 'AR',
            'California': 'CA',
            'Colorado': 'CO',
            'Connecticut': 'CT',
            'Delaware': 'DE',
            'District of Columbia': 'DC',
            'Florida': 'FL',
            'Georgia': 'GA',
            'Guam': 'GU',
            'Hawaii': 'HI',
            'Idaho': 'ID',
            'Illinois': 'IL',
            'Indiana': 'IN',
            'Iowa': 'IA',
            'Kansas': 'KS',
            'Kentucky': 'KY',
            'Louisiana': 'LA',
            'Maine': 'ME',
            'Maryland': 'MD',
            'Massachusetts': 'MA',
            'Michigan': 'MI',
            'Minnesota': 'MN',
            'Mississippi': 'MS',
            'Missouri': 'MO',
            'Montana': 'MT',
            'Nebraska': 'NE',
            'Nevada': 'NV',
            'New Hampshire': 'NH',
            'New Jersey': 'NJ',
            'New Mexico': 'NM',
            'New York': 'NY',
            'North Carolina': 'NC',
            'North Dakota': 'ND',
            'Northern Mariana Islands':'MP',
            'Ohio': 'OH',
            'Oklahoma': 'OK',
            'Oregon': 'OR',
            'Pennsylvania': 'PA',
            'Puerto Rico': 'PR',
            'Rhode Island': 'RI',
            'South Carolina': 'SC',
            'South Dakota': 'SD',
            'Tennessee': 'TN',
            'Texas': 'TX',
            'Utah': 'UT',
            'Vermont': 'VT',
            'Virgin Islands': 'VI',
            'Virginia': 'VA',
            'Washington': 'WA',
            'West Virginia': 'WV',
            'Wisconsin': 'WI',
            'Wyoming': 'WY'
            }



    ss = s.strip()
    reverse = dict(map(reversed, us_state_abbrev.items()))

    if ss in us_state_abbrev.keys():
        return us_state_abbrev[ss]
    if ss in reverse.keys():
        return ss


    if len(s) > 0 and len(s.split(',')) > 1:

        places = s.split(',')
        for p in places:
            ps = p.strip()
            if ps in us_state_abbrev.keys():
                return us_state_abbrev[ps]
            if ps in reverse.keys():
                return ps
    return ''




def search_qualified_tweets(search_term, date_since, date_until):
    data = [] # empty list to which tweet_details obj will be added
    counter = 0 # counter to keep track of each iteration
    for tweet in tweepy.Cursor(api.search, q='\"{}\" -filter:retweets'.format(search_term)
            , count=200
            , lang='en'
            , locations = [-125,25,-65,48]
            , since = date_since
            , until = date_until
            , tweet_mode='extended'
            ).items():
        ## only original tweets
        if True:
            tweet_details = {}
            tweet_details['name'] = tweet.user.screen_name
            tweet_details['tweet'] = tweet.full_text
            tweet_details['retweets'] = tweet.retweet_count
            #tweet_details['location'] = tweet.user.location
            tweet_details['created'] = tweet.created_at.strftime("%d-%b-%Y")
            tweet_details['followers'] = tweet.user.followers_count

            #Iterate through different types of geodata to get the variable primary_geo
            if tweet.place:
                tweet_details['location'] = tweet.place.full_name + ", " + tweet.place.country
                tweet_details["geo_type"] = "Tweet place"
            else:
                tweet_details['location'] = tweet.user.location
                tweet_details["geo_type"] = "User location"
                #Add only tweets with some geo data to .json. Comment this if you want to include all tweets.
                if tweet_details['location'] and len(loc_to_state(tweet_details['location']))>0 \
                        and tweet.retweet_count == 0:
                            data.append(tweet_details)

            counter += 1
            if(counter % 5000 == 0): print('collected' + str(counter) + 'valid tweets')
            #if counter == 1000000:
            #    break
            #else:
            #    pass
    search_term_reformated = search_term.replace(" ", "_")
    with open('data/{}.json'.format(search_term_reformated), 'w') as f:
        json.dump(data, f)
        print('done!')



def search_qualified_tweets_twitterAPI(search_term, date_since, date_until):
    data = [] # empty list to which tweet_details obj will be added
    counter = 0 # counter to keep track of each iteration
    for tweet in tweepy.Cursor(api.search, q='\"{}\" -filter:retweets'.format(search_term)
            , count=200
            , lang='en'
            , locations = [-125,25,-65,48]
            , since = date_since
            , until = date_until
            , tweet_mode='extended'
            ).items():
        ## only original tweets
        if True:
            tweet_details = {}
            tweet_details['name'] = tweet.user.screen_name
            tweet_details['tweet'] = tweet.full_text
            tweet_details['retweets'] = tweet.retweet_count
            #tweet_details['location'] = tweet.user.location
            tweet_details['created'] = tweet.created_at.strftime("%d-%b-%Y")
            tweet_details['followers'] = tweet.user.followers_count

            #Iterate through different types of geodata to get the variable primary_geo
            if tweet.place:
                tweet_details['location'] = tweet.place.full_name + ", " + tweet.place.country
                tweet_details["geo_type"] = "Tweet place"
            else:
                tweet_details['location'] = tweet.user.location
                tweet_details["geo_type"] = "User location"
                #Add only tweets with some geo data to .json. Comment this if you want to include all tweets.
                if tweet_details['location'] and len(loc_to_state(tweet_details['location']))>0 \
                        and tweet.retweet_count == 0:
                            data.append(tweet_details)

            counter += 1
            if(counter % 5000 == 0): print('collected' + str(counter) + 'valid tweets')
            #if counter == 1000000:
            #    break
            #else:
            #    pass
    search_term_reformated = search_term.replace(" ", "_")
    with open('data/{}.json'.format(search_term_reformated), 'w') as f:
        json.dump(data, f)
        print('done!')



def get_n_recent_tweets(screen_name, n = 3240, since_id = 1200068469913530369):
    alltweets = []
    # make initial request for most recent tweets (200 is the maximum allowed count)
    try: # handle protected tweets
        new_tweets = api.user_timeline(screen_name = screen_name,count=200, since_id = since_id )
        # save most recent tweets
        alltweets.extend(new_tweets)
        # save the id of the oldest tweet less one
        if len(alltweets) == 0:
            return [['1234', 'protected', '1990-01-01', '', 0]]
        else:
            oldest = alltweets[-1].id - 1
        print(oldest)
        if n>200 and oldest >= since_id:
            # keep grabbing tweets until there are no tweets left to grab
            while len(new_tweets) > 0:
                #print("getting tweets before %s" % (oldest))
                # all subsiquent requests use the max_id param to prevent duplica
                new_tweets = api.user_timeline(screen_name = screen_name,count=200,max_id=oldest, since_id = since_id)
                # save most recent tweets
                alltweets.extend(new_tweets)
                # update the id of the oldest tweet less one
                oldest = alltweets[-1].id - 1
                #print("...%s tweets downloaded so far" % (len(alltweets)))

        # transform the tweepy tweets into a 2D array that will populate the csv
        #outtweets = [[tweet.id_str
        #    , tweet.user.screen_name
        #    , tweet.created_at.strftime("%d-%b-%Y")
        #    , tweet.text
        #    , tweet.retweet_count
        #    #, tweet.user.followers_count
        #    ] for tweet in alltweets]
        
        outtweets = []
        for tweet in alltweets:
            if tweet.lang == 'en':
            #if not tweet.retweeted and ('RT @' not in tweet.text) and tweet.lang == 'en':
                outtweets.append([tweet.id_str
                    , tweet.user.screen_name
                    , tweet.created_at.strftime("%d-%b-%Y")
                    , tweet.text
                    , tweet.retweet_count
                    ])
        if len(outtweets)>0:
            return outtweets
    except tweepy.TweepError:
        print("Failed to run the command on that user, Skipping...")
    # if error occurs return a default void tweet
    return [['1234', '', '1990-01-01', '', 0]]

