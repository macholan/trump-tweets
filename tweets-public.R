# install.packages("twitteR")
# install.packages("googlesheets")
library(twitteR)
# library(googlesheets)

#authenticate with Twitter API using your own credentials
consumer_key <- ""
consumer_secret <- ""
access_token <- ""
access_secret <- ""

setup_twitter_oauth(consumer_key, consumer_secret, access_token = access_token, access_secret = access_secret)

#pull most recent tweets as dataframe
newtweets <- twListToDF(userTimeline('realDonaldTrump', n=200))

#create dataframe for all tweets
alltweets <- newtweets

#save the id of the oldest tweet less one
alltweets$id <- as.numeric(alltweets$id)
oldest <- min(alltweets$id) - 1

Sys.sleep(60)
#pull historical tweets
while (nrow(alltweets) <= 5000) {
  #save most recent tweets
  newtweets <- twListToDF(userTimeline('realDonaldTrump', n=200, maxID=oldest))
  #save most recent tweets
  newtweets$id <- as.numeric(newtweets$id)
  alltweets <- rbind(alltweets, newtweets)
  oldest <- min(alltweets$id) - 1
  Sys.sleep(60)
}


#download data to CSV
write.csv(alltweets,"alltweets.csv")
#OR upload sheet directly to Google Spreadsheets
trumptweets <- gs_new("alltweets", input = alltweets, trim = FALSE)
