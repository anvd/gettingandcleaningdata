## Getting and Cleaning Data Course Project
VO Duc An

### Description
This file contains the detailed description of the steps performed by the accompanied run_analysis.R

### Step 1. Merge the training and the test sets to create one data set.
	+ Read the features and activity labels
	+ Read the training data
	+ Assign column names to the training data
	+ Create the final training dataset by merging trainingLabels, trainingSubjects and trainingSet
	+ Read the test data
	+ Assign column names to the test data
	+ Create the final test data set by merging the testLabels, testSubjects and testSet
	+ Merges the training and the test sets to create one data set

## Step 2. Extract only the measurements on the mean and standard deviation for each measurement. 
	+ Save finalDataSet's column names to colNames variable for later use
	+ Create a logicalVector that contains TRUE values for the activityId, subjectId, mean and stddev columns and FALSE for others
	+ Subset finalDataSet table using the logicalVector to keep only the desired columns

## Step 3. Use descriptive activity names to name the activities in the data set
	+ Merge the finalDataSet with the activityTypes table to include descriptive activity names

## Step 4. Appropriately label the data set with descriptive activity names.
	+ Updating the colNames vector to include the new column name of finalDataSet
	+ Clean up the variable names

## Step 5. Create a second, independent tidy data set with the average of each variable for each activity and each subject. 
	+ Reassign the new descriptive column names to the finalDataSet
	+ Create a new table, finalDataSetWithoutActivityType without the activityType column
	+ Summarize the finalDataSetWithoutActivityType table to include just the mean of each variable for each activity and each subject
	+ Merge the tidyData with activityTypes to include descriptive activity names
	+ Save the tidyData set to file