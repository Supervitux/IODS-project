# Vitus Besel, 16.11.2020, this file contains data wrangling for exercise 5 AND 6 !
# data from https://archive.ics.uci.edu/ml/machine-learning-databases/00320/
library(dplyr)
# 2) read in data
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

# 3) Explore dimension and structure
dim(hd)   # 195 obs of 8 variables
str(hd)
dim(gii)  #195 obs of 10 variables
str(gii)

# 4) Rename
hd <- rename(hd, "Rank" = HDI.Rank, "HDI" = Human.Development.Index..HDI., "LifeExpect" = Life.Expectancy.at.Birth, "ExpYearsOfEdu" = Expected.Years.of.Education, "MeanYearsOfEdu" = Mean.Years.of.Education, "Income" = Gross.National.Income..GNI..per.Capita, "GNI" = GNI.per.Capita.Rank.Minus.HDI.Rank)
gii <- rename(gii, "Rank" = GII.Rank, "GII" = Gender.Inequality.Index..GII., "MatDeath" = Maternal.Mortality.Ratio, "BirthRate" = Adolescent.Birth.Rate, "Parliament" = Percent.Representation.in.Parliament, "SecEduFem" = Population.with.Secondary.Education..Female., "SecEduMale" = Population.with.Secondary.Education..Male., "ForceLabFem" = Labour.Force.Participation.Rate..Female., "ForceLabMale" = Labour.Force.Participation.Rate..Male.)

# 5) Mutate
#gii$SecEduRatio = mutate(gii, SecEduRatio = SecEduFem / SecEduMale)
#gii$ForceLabRatio = mutate(gii, ForceLabRatio = ForceLabFem / ForceLabMale)
gii <- mutate(gii, SecEduRatio = SecEduFem / SecEduMale)
gii <- mutate(gii, ForceLabRatio = ForceLabFem / ForceLabMale)

# 6. Join
human <- inner_join(hd, gii, by = "Country", suffix = c(".hd", ".gii"))
str(human)

write.csv(human, file = "data/human.csv")

# Data wrangling continuation for exercise 6!
# Data description:
str(human)
dim(human)
# The data contains 195 obs. of 19 variables that contribute to the human development index HDI and Gender Inequality Index including themselves.
# Therefore it contains information about birht/death rates, education etc.

############### 6. Exercise ###################
# 1. Mutate
library(stringr)
human <- read.table("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human1.txt", sep  =",", header = T)
#human <- mutate(human, GNI = as.numeric(GNI))
str_replace(human$GNI, pattern=",", replace ="") %>% as.numeric

# 2.
# columns to keep
keep <- c("Country", "Edu2.FM", "Labo.FM", "Life.Exp", "Edu.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F")

# select the 'keep' columns
human <- select(human, one_of(keep))

# 3.
# print out a completeness indicator of the 'human' data
complete.cases(human)

# print out the data along with a completeness indicator as the last column
data.frame(human[-1], comp = complete.cases(human))

# filter out all rows with NA values
human_ <- filter(human, complete.cases(human))
str(human_)
# 4.
# look at the last 10 observations of human
tail(human, n = 10)

# define the last indice we want to keep
last <- nrow(human_) - 7

# choose everything until the last 7 observations
human_ <- human_[1:last, ]

# add countries as rownames
rownames(human_) <- human_$Country

# 5. 
# remove the Country variable
human_ <- select(human_, -Country)
# save
write.csv(human_, file = "data/human.csv")
