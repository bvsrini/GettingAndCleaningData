---
title: "Getting and Cleaning Data- Coursera Project"
author: "Srinivasan BV Sastry"
date: "Jun-18-2015"
output:
  html_document:
    keep_md: yes
---
 
## Project Description
The project involves using the data collected from the accelerometers from the Samsung Galaxy S Smart phone, working with it and 
prepare a clean data set "Human Activity Recognition Using Smart phones Dataset Version 10" data set collected from  the 
(http://archiveicsuciedu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) or 
(https://d396qusza40orccloudfrontnet/getdata%2Fprojectfiles%2FUCI%20HAR%20Datasetzip) site is studied and a tidy 
data set is worked out for useful analysis The tidy set involves only the data associated with  the mean and standard deviation of 
multiple variables associated  with the data files 
 
##Study design and data processing
The original data  was collected from the Samsung Galaxy phones from 30 volunteers by various experiments 
Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a 
smart phone (Samsung Galaxy S II) on the waist Using its embedded accelerometer and gyroscope, number of observations were captured  for 
the 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz The obtained dataset has been randomly partitioned 
into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data
The "Data Set Information" in the (http://archiveicsuciedu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) or the READMEtxt contains more
information

The data set contains following files 

* READMEtxt
* features_info.txt: Shows information about the variables used on the feature vector
* features.txt: List of all features
* activity_labels.txt: Labels for  the x_train and x_test with their activity name
* train/X_train.txt: Training set
* train/y_train.txt: Training labels
* test/X_test.txt: Test set
* test/y_test.txt: Test labels

The entire data set is partitioned into X_traintxt and X_testtxt The corresponding activity numbers for the observations are in y_traintxt 
and y_testtxt respectivelySo the complete data set must be compiled by combining these two data sets The column headers are in featurestxt  

The project requires to select only variables that have mean() and std()  There are 66 variables that fit this criteria The tidy data requires 
data aggregated for all the subjects ( ie30) for all activities (i.e. 6) So the final tidy data set is expected to have 6 * 30 = 180 rows  for all 
subjects and activities and  66 variables + subject + activities = 68 columns 

###Collection of the raw data
The following link explains how the original data is collected and pre-processed from the  30 volunteers 
(https://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI%20HAR%20Dataset.names)

###Notes on the original (raw) data 
There are total 30 volunteers (or subjects) The train data set contains 70% of the volunteer population and the test data set contains 30%.
So the train data set  contains activities 21 subjects (volunteers) and the test data set contains 9 subjects.  There are 7352 observations on the train
data set and 2947 observations on the test data set.  Out of the total 10299 observations the no of observations for each subject is not equal
as seen below. 
``` {r}
>  as.list(summarize (group_by(sel_data,Subjects),n()))
$Subjects
 [1] 1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30
Levels: 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30

$`n()`
 [1] 347 302 341 317 302 325 308 281 288 294 316 320 327 323 328 366 368 364 360 354 408 321 372 381
[25] 409 392 376 382 344 383

attr(,"drop")
[1] TRUE
```
There are multiple rows of observations for the same subjects and activities without any additional information on them that separates them like date and time of 
observation. So in order to prepare a tidy data we need to aggregate them. 

Also the variable names for mean() and std() mentioned within features_info.txt is different than that is provided in features.txt
```
features_info.txt variable names
---------------------------
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag

features.txt variable names from the data set
----------------------------------------------
[64] "fBodyBodyAccJerkMag-std()"   "fBodyBodyGyroMag-mean()"     "fBodyBodyGyroMag-std()"     
[67] "fBodyBodyGyroJerkMag-mean()" "fBodyBodyGyroJerkMag-std()" 
```
##Creating the tidy datafile
 
###Guide to create the tidy data file
Description on how to create the tidy data file (1 download the data, )/
 
###Cleaning of the data
Short, high-level description of what the cleaning script does [link to the readme document that describes the code in greater detail]()
 
##Description of the variables in the tiny_datatxt file
General description of the file including:
 - Dimensions of the dataset
 - Summary of the data
 - Variables present in the dataset
 
(you can easily use Rcode for this, just load the dataset and provide the information directly form the tidy data file)
 
###Variable 1 (repeat this section for all variables in the dataset)
Short description of what the variable describes
 
Some information on the variable including:
 - Class of the variable
 - Unique values/levels of the variable
 - Unit of measurement (if no unit of measurement list this as well)
 - In case names follow some schema, describe how entries were constructed (for example time-body-gyroscope-z has 4 levels of descriptors Describe these 4 levels) 
 
(you can easily use Rcode for this, just load the dataset and provide the information directly form the tidy data file)
 
####Notes on variable 1:
If available, some additional notes on the variable not covered elsewehere If no notes are present leave this section out
 
##Sources
Sources you used if any, otherise leave out
 
##Annex
If you used any code in the codebook that had the echo=FALSE attribute post this here (make sure you set the results parameter to hide as you do not want the results to show again)
