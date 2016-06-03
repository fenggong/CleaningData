# Here are the data for the project: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# You should create one R script called run_analysis.R that does the following. 
# Merges the training and the test sets to create one data set. 
# Extracts only the measurements on the mean and standard deviation for each measurement.
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names.
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each 
# activity and each subject.
# 
# set work directory to the data directory
setwd("/Users/fenggongwang/Downloads/UCI HAR Dataset")

# 1. Merges the training and the test sets to create one data set
# - Read data 
x_train <- read.table("./train/X_train.txt")
y_train <- read.table("./train/y_train.txt")
subject_train <- read.table("./train/subject_train.txt")

x_test <- read.table("./test/X_test.txt")
y_test <- read.table("./test/y_test.txt")
subject_test <- read.table("./test/subject_test.txt")

# - Merge the train and test data 
x_train_test <- rbind(x_train, x_test)
y_train_test <- rbind(y_train, y_test)
subject_train_test <- rbind(subject_train, subject_test)
train_test <- cbind(subject_train_test, y_train_test, x_train_test)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# - read features
features <- read.table("./features.txt")
# - extract features on the mean or standard deviation
features_extract <- grepl("mean|std", features[[2]])
x_train_test_extract <- x_train_test[, features_extract]

# 3. Uses descriptive activity names to name the activities in the data set
# - read activity label
activity_labels <- read.table("./activity_labels.txt")
# - change activity numbers to descriptive labels
y_train_test[,1] <- activity_labels[y_train_test[,1],2]
# 4. Appropriately labels the data set with descriptive variable names.
# - set names
colnames(x_train_test_extract) <- features[features_extract,2]
colnames(y_train_test) <- "activity"
colnames(subject_train_test) <- "subject"
train_test_extract <- cbind(subject_train_test, y_train_test, x_train_test_extract)
names(train_test_extract) <- gsub("\\(|\\)", "", names(train_test_extract))
names(train_test_extract) <- gsub("^t", "time", names(train_test_extract))
names(train_test_extract) <- gsub("Acc","Acceleration",names(train_test_extract))
names(train_test_extract) <- gsub("GyroJerk","AngularAcceleration",names(train_test_extract))
names(train_test_extract) <- gsub("Gyro","AngularSpeed",names(train_test_extract))
names(train_test_extract) <- gsub("Mag","Magnitude",names(train_test_extract))
names(train_test_extract) <- gsub("^f","frequency",names(train_test_extract))
names(train_test_extract) <- gsub("Freq","Frequency",names(train_test_extract))
names(train_test_extract) <- gsub("std","standardDeviation",names(train_test_extract))
# 
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each 
# activity and each subject
# 
library(dplyr)
average_activity_subject <- aggregate(train_test_extract[,3:ncol(train_test_extract)], list(train_test_extract$activity, train_test_extract$subject), mean)
colnames(average_activity_subject)[1:2] <- c("activity", "subject")
write.table(average_activity_subject, file = "./average_activity_subject.txt", row.names = FALSE)
# 
# 
# 