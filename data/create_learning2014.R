# Vitus Besel, 2.11.2020, this file contains Exc2, data wrangling

# 1. Load data
X <- read.csv(url("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt"), header = T, sep = "\t")

# 2. Investigate data
str(X)
dim(X)
# -> 183 observations of 60 variables

# 3. Create analysis data set
#install.packages("dplyr")
library(dplyr)
#
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")
#
deep_columns <- select(X, one_of(deep_questions))
X$deep <- rowMeans(deep_columns)
# select the columns related to surface learning and create column 'surf' by averaging
surface_columns <- select(X, one_of(surface_questions))
X$surf <- rowMeans(surface_columns)
# select the columns related to strategic learning and create column 'stra' by averaging
strategic_columns <- select(X, one_of(strategic_questions))
X$stra <- rowMeans(strategic_columns)

keep <- c("gender", "Age", "Attitude", "deep", "stra", "surf", "Points")
X_2 <- select(X, one_of(keep))

# Exclude points == 0
X_2 <- filter(X_2, Points > 0)
str(X_2)
# 166 obs of 7 variables left

# 4.
