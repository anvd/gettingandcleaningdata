###########################################################

## Getting and Cleaning Data Course Project
## VO Duc An
## 2nd Feb 2017

## run_analysis.R

## This script performs the following steps on the data downloaded from
## https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
##   1. Merges the training and the test sets to create one data set.
##   2. Extracts only the measurements on the mean and standard deviation for each measurement.
##   3. Uses descriptive activity names to name the activities in the data set
##   4. Appropriately labels the data set with descriptive variable names.
##   5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

###########################################################

# Clean up workspace
rm(list=ls())

## Assume that the data is downloaded and extracted into "UCI HAR Dataset" folder


# Set working directory to the location where the UCI HAR Dataset was unzipped
setwd('./UCI HAR Dataset/')

# Read the features and activity labels
features = read.table('./features.txt')
activityTypes = read.table('./activity_labels.txt')

## Read the training data
trainingSubjects = read.table('./train/subject_train.txt')
trainingSet = read.table('./train/X_train.txt')
trainingLabels = read.table('./train/y_train.txt')

# Assign column names to the training data
colnames(activityTypes) = c('activityId','activityType')
colnames(trainingSubjects) = "subjectId"
colnames(trainingSet) = features[,2]
colnames(trainingLabels) = "activityId"

# Create the final training dataset by merging trainingLabels, trainingSubjects and trainingSet
finalTrainingData = cbind(trainingLabels, trainingSubjects, trainingSet)

# Read the test data
testSubjects = read.table('./test/subject_test.txt')
testSet = read.table('./test/X_test.txt')
testLabels = read.table('./test/y_test.txt')

# Assign column names to the test data
colnames(testSubjects) = "subjectId"
colnames(testSet) = features[,2]
colnames(testLabels) = "activityId"

# Create the final test data set by merging the testLabels, testSubjects and testSet
finalTestData = cbind(testLabels, testSubjects, testSet)


# 1. Merges the training and the test sets to create one data set.
finalDataSet = rbind(finalTrainingData, finalTestData)


# 2. Extracts only the measurements on the mean and standard deviation for each measurement.

# Save finalDataSet's column names to colNames variable for later use
colNames  = colnames(finalDataSet)

# Create a logicalVector that contains TRUE values for the activityId, subjectId, mean and stddev columns and FALSE for others
logicalVector = grepl("activityId|subjectId|.*mean.*|.*std.*", colNames);

# Subset finalDataSet table using the logicalVector to keep only the desired columns
finalDataSet = finalDataSet[logicalVector==TRUE]


# 3. Use descriptive activity names to name the activities in the data set

# Merge the finalDataSet with the activityTypes table to include descriptive activity names
finalDataSet = merge(finalDataSet, activityTypes, by='activityId', all.x=TRUE)


# 4. Appropriately labels the data set with descriptive variable names.

# Update the colNames vector to include the new column name of finalDataSet
colNames = colnames(finalDataSet)

# Clean up the variable names
colNames = gsub('-mean', 'Mean', colNames)
colNames = gsub('-std', 'Std', colNames)
colNames = gsub('[()]', '', colNames)


# 5. Create a second, independent tidy data set with the average of each variable for each activity and each subject. 

# Reassign the new descriptive column names to the finalDataSet
colnames(finalDataSet) = colNames

# Create a new table, finalDataSetWithoutActivityType without the activityType column
finalDataSetWithoutActivityType = finalDataSet[, names(finalDataSet) != 'activityType']

# Summarize the finalDataSetWithoutActivityType table to include just the mean of each variable for each activity and each subject
tidyData = aggregate(finalDataSetWithoutActivityType[, names(finalDataSetWithoutActivityType) != c('activityId', 'subjectId')], by=list(activityId=finalDataSetWithoutActivityType$activityId, subjectId=finalDataSetWithoutActivityType$subjectId), mean)

# Merge the tidyData with activityTypes to include descriptive activity names
tidyData = merge(tidyData, activityTypes, by='activityId', all.x=TRUE)

# Save the tidyData set to file
write.table(tidyData, './tidyData.txt', row.names=TRUE, sep='\t')
