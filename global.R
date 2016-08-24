library(shiny)
library(shinydashboard)
library(ggplot2)
library(plyr)
library(scales)
library(DT)
library(plotly)
library(feather)

select_all <- "--select--"
default_omschrijving <- "Plaatsen van een spiraal ter voorkoming van zwangerschap"

colors = c("red", "blue")

#read data
# prices <- read.csv(file = "prijslijst.csv", skip=2)
# colnames(prices) <- c("naam", "plaats", "code", "product", "omschrijving", "tarief")
# prices$tarief <- gsub("€ ", "", prices$tarief)
# prices$tarief <- as.numeric(prices$tarief)

prices <- read_feather('prices.feather')

# #calculate difference per treatment
df_diff <- aggregate(tarief ~ omschrijving, data = prices, function(x) return(max(x) - min(x)))
df_diff <- df_diff[order(df_diff$tarief, decreasing = TRUE),]
# ggplot(data=df, aes(x=omschrijving, y=tarief)) + geom_bar(stat="identity")
omschrijving_list <- as.list(as.character(df_diff$omschrijving))
default_omschrijving <- omschrijving_list[[1]]

m = list(
  l = 300,
  r = 40,
  b = 50,
  t = 50,
  pad = 0
)

#top 10
# desc <- unique(prices$omschrijving)
# #for(i in 1:length(desc)){
# for(i in 1:3){  
#   df <- prices[prices$omschrijving == desc[i],]
#   df <- df[!is.na(df$tarief),]
#   df <- df[order(df$tarief, decreasing = FALSE),]
#   
#   print(df)
#   #print top 3
#   namen <- df$naam
#   for(j in 1:3){
#     df2 <- df[df$naam == namen[j],]
#     print(paste(df2$naam, df2$tarief))
#   }
# }


#relatief cause not all hospitals offer the same service

## loop over treatment codes to set diff
#calc avg_price
# avg_price <- aggregate(tarief ~ code, data = prices, FUN = mean)
# 
# getAvgPrice <- function(avg_price, code){
#   return(avg_price[avg_price$code == code, c("tarief")])
# }
# 
# #add diff tarief
# for(i in 1:nrow(prices)){
#   if (i %% 1000 == 0){
#     print(i)
#   }
#   prices[i,"avg_tarief"] <- getAvgPrice(avg_price, prices[i, ]$code)
#   prices[i,"diff_tarief"] <- prices[i,"avg_tarief"] - prices[i,]$tarief
# }
price_diff <- aggregate(diff_tarief ~ naam, data = prices, function(x) return(mean(x)))
# #cheapest first
price_diff <- price_diff[order(price_diff$diff_tarief, decreasing = FALSE),]

# len <- aggregate(x = prices$naam, by=list(naam = prices$naam), FUN=length)
# names(len) <- c("naam", "count")
# len <- len[order(len$count, decreasing = TRUE),]
# len <- len[len$count < 500, ]


