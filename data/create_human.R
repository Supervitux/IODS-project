# Vitus Besel, 16.11.2020, this file contains data wrangling for exercise 5
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
