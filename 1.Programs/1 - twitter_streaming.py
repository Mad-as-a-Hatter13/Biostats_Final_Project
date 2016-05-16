# Final Project - Initial Pull

#Import the necessary methods from tweepy library
from tweepy.streaming import StreamListener
from tweepy import OAuthHandler
from tweepy import Stream

#Variables that contains the user credentials to access Twitter API 
access_token = "ENTER YOUR ACCESS TOKEN"
access_token_secret = "ENTER YOUR ACCESS TOKEN SECRET"
consumer_key = "ENTER YOUR API KEY"
consumer_secret = "ENTER YOUR API SECRET"

#This is a basic listener that just prints received tweets to stdout.
class StdOutListener(StreamListener):

    def on_data(self, data):
        print data
        return True

    def on_error(self, status):
        print status


if __name__ == '__main__':

    # This handles Twitter authetification and the connection to Twitter 
    # streaming API
    l = StdOutListener()
    auth = OAuthHandler(consumer_key, consumer_secret)
    auth.set_access_token(access_token, access_token_secret)
    stream = Stream(auth, l)

    # This line filter Twitter Streams to capture data by the keywords: 
    stream.filter(track=['Zika', 'Guillain-Barre','Guillain','Zika virus',
                         'Zika spread','Zika pandemic'])
    # Note that you should add your own keywords for the subject you are
    # interested in. An initial short pull can help you identify more words
    # that can be useful for a larger pull.


# After creating this program it is best to run it in console by running the
# code: 
#
# python 1_twitter_streaming.py > twitter_data.txt
# '-> Make sure you change the file name from 1 - twitter_streaming.py to
#     1_twitter_streaming.py in order to easily run this in your console.
#
# This command will take the streaming program and set it to a text file, 
# which is easier for parsing with the later programs.
# Note: This is a live data pull and so you should expect to run this, 
# depending on your preffered data size, for multiple days.
# Example: My initial pull was 32.1MB which was about 7,746 tweets
