source("Client.R")
source("dl_coxph.R")
client <- Client("http://35.157.139.38:5000/api", "varsha", "password", 1) #please replace with correct username and password
client$authenticate()

# Parameters used to interpret the hub's datastore
expl_vars <- c("Treatment_ChemoRadiotherapy", "T3orHigher", 
              "HPV_HPV_Positive","HPV_HPV_Negative" ,"N2orHigher")
#expl_vars <- c("N2orHigher")
time_col <- "overall_survival_in_days"
censor_col <- "event_overall_survival"

results <- dcoxph(client, expl_vars, time_col, censor_col)
results

# # #create input from results
Treatment_ChemoRadiotherapy = c(results$coef[1])
T3orHigher = c(results$coef[2])
HPV_HPV_Positive = c(results$coef[3])
HPV_HPV_Negative = c(results$coef[4])
N2orHigher = c(results$coef[5])
inputDf1 = data.frame(Treatment_ChemoRadiotherapy,T3orHigher,HPV_HPV_Positive,HPV_HPV_Negative,N2orHigher)
#inputDf1 = data.frame(Treatment_ChemoRadiotherapy)
library(jsonlite)
input=toJSON(inputDf1)
input

# # # create and post task
source("validate_task.R")
task = postTask(client,input)
print(task)