# Final Project - Dataset Creation
import json
import pandas as pd


# Specify the path for your text file that you created with the initial pull
tweets_data_path = '~/data_file_created_here.txt'

# Transforms text file by line into a Python list
tweets_data = []
tweets_file = open(tweets_data_path, "r")
for line in tweets_file:
    try:
        tweet = json.loads(line)
        tweets_data.append(tweet)
    except:
        continue
tweet_frame = pd.DataFrame(tweets_data)
tweet_frame.isnull().sum()
    
# Transforms our list to a data frame for specific variables. See the 'tweet'
# dictionary file to reference specific elements in the data frame creation
tweets = pd.DataFrame()

# Adding in basic tweet information
tweets['text'] = map(lambda tweet:tweet['text'] if 'text' in tweet \
    else ' ', tweets_data)
tweets['lang'] = map(lambda tweet: tweet['lang'] if 'text' in tweet \
    else ' ', tweets_data)
tweets['country'] = map(lambda tweet: tweet['place']['country'] \
    if 'text' in tweet and tweet['place'] != None else None, tweets_data)
tweets['tweet_time'] = map(lambda tweet: tweet['created_at'] \
    if 'text' in tweet else ' ', tweets_data)

# Basic user information
tweets['name'] = map(lambda tweet: tweet['user']['name'] if 'text' in tweet \
    else ' ', tweets_data)
tweets['handle'] = map(lambda tweet: tweet['user']['screen_name'] \
    if 'text' in tweet else ' ', tweets_data)

# Capturing Tweeter influence via tweet retweets and favorites
tweets['retweet'] = map(lambda tweet: tweet['retweeted'] \
    if 'text' in tweet else ' ', tweets_data)
tweets['retweet_count'] = map(lambda tweet: tweet['retweet_count']\
    if 'text' in tweet else ' ', tweets_data)
tweets['faves'] = map(lambda tweet: tweet['favorite_count']\
    if 'text' in tweet else ' ', tweets_data)

# Capturing Tweeter influence via followers(ing) and verification
tweets['followers'] = map(lambda tweet: tweet['user']\
    ['followers_count'] if 'text' in tweet else ' ', tweets_data)
tweets['following'] = map(lambda tweet: tweet['user']\
    ['friends_count'] if 'text' in tweet else ' ', tweets_data)
tweets['verified'] = map(lambda tweet: tweet['user']\
    ['verified'] if 'text' in tweet else ' ', tweets_data)
tweets['Number_Tweets'] = map(lambda tweet: tweet['user']\
    ['statuses_count'] if 'text' in tweet else ' ', tweets_data)

# Location Specifics
tweets['geo_available'] = map(lambda tweet: tweet['user']\
    ['geo_enabled'] if 'text' in tweet else ' ', tweets_data)
tweets['coordinates'] = map(lambda tweet: tweet['coordinates'] \
    if 'text' in tweet else ' ', tweets_data)
tweets['geo'] = map(lambda tweet: tweet['geo'] \
    if 'text' in tweet else ' ', tweets_data)
tweets['place'] = map(lambda tweet: tweet['place'] \
    if 'text' in tweet else ' ', tweets_data)
tweets['coordinates'] = map(lambda tweet: tweet['coordinates'] \
    if 'text' in tweet else ' ', tweets_data)
tweets['location'] = map(lambda tweet: tweet['user']\
    ['location'] if 'text' in tweet else ' ', tweets_data)
tweets['time_zone'] = map(lambda tweet: tweet['user']\
    ['time_zone'] if 'text' in tweet else ' ', tweets_data)

# Miscellaneous information
tweets['number_tweets'] = map(lambda tweet: tweet['user']\
    ['statuses_count'] if 'text' in tweet else ' ', tweets_data)
tweets['default_profile'] = map(lambda tweet: tweet['user']\
    ['default_profile_image'] if 'text' in tweet else ' ', tweets_data)
tweets['account_start'] = map(lambda tweet: tweet['user']\
    ['created_at'] if 'text' in tweet else ' ', tweets_data)
tweets['quoted_tweet'] = map(lambda tweet: tweet['is_quote_status'] \
    if 'text' in tweet else ' ', tweets_data)

# Note you can look at the dictionary 'tweet' to find other variables
# that you might find interesting. Also, the above tweets may not be of
# interest for you, feel free to adopt the code as you need.

# Transform the data to a CSV file for R analysis
df = tweets
df.to_csv('name_of_your_dataset.csv', encoding='utf-8')  
