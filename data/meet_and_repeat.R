# Vitus Besel, 1.12.2020, this file contains data wrangling for exercise 7

library(dplyr)
library(tidyr)
# 1) read in data
BPRS <- read.csv("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", stringsAsFactors = F, sep = " ")
RATS <- read.csv("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", stringsAsFactors = F, sep =  "\t")

# Explore dimension and structure
dim(BPRS)   # 40 obs of 11 "variables"
str(BPRS)
# 40 male subjects were randomly assigned to one of two treatment groups and rated on the brief psychiatric rating scale (BPRS) over 9 weeks
dim(RATS)  # 16 obs of 13 variables
str(RATS)
# data from a nutrition study conducted in three groups of rats. The groups were put on different diets, and each animal’s body weight (grams) was recorded repeatedly (approximately) weekly, except in week seven when two recordings were taken) over a 9-week period

# 2) Factor variables
RATS$ID <- factor(RATS$ID)
RATS$Group <- factor(RATS$Group)
BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)

# 3) Convert to long form
BPRSL <-  BPRS %>% gather(key = weeks, value = bprs, -treatment, -subject)
# Extract the week number
BPRSL <-  BPRSL %>% mutate(week = as.integer(substr(weeks,5,5)))
# Convert data to long form
RATSL <- RATS %>%
  gather(key = WD, value = Weight, -ID, -Group) %>%
  mutate(Time = as.integer(substr(WD,3,4))) 

# Explore dimension and structure
dim(BPRSL)   # 360 obs of 5 "variables"
str(BPRSL)
# Variables are not longer the singular weeks, instead week is now one single integer variable. Subjects can be told apart in the subject variable
# which is a categorial variable, so is "treatment"
dim(RATSL)  # 176 obs of 5 variables
str(RATSL)
# Also here variables are not longer the singular days, instead there is one time variable. Subjects can be told apart in the subject variable

# save
write.csv(RATSL, file = "data/rats.csv")
write.csv(BPRSL, file = "data/bprs.csv")
