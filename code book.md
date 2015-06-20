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
 [UCI Machine Learning Repository](https://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) or 
[Project Data Set] (https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) site is studied and a tidy 
data set is worked out for useful analysis The tidy set involves only the data associated with  the mean and standard deviation of 
multiple variables associated  with the data files 
 
##Study design and data processing
The original data  was collected from the Samsung Galaxy phones from 30 volunteers by various experiments 
Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a 
smart phone (Samsung Galaxy S II) on the waist Using its embedded accelerometer and gyroscope, number of observations were captured  for 
the 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The obtained dataset has been randomly partitioned 
into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data
The "Data Set Information" in the  [UCI Machine Learning Repository](https://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) 
 or the README.txt contains more information

The data set contains following files 

* README.txt
* features_info.txt: Shows information about the variables used on the feature vector
* features.txt: List of all features
* activity_labels.txt: Labels for  the x_train and x_test with their activity name
* train/X_train.txt: Training set
* train/y_train.txt: Training labels
* test/X_test.txt: Test set
* test/y_test.txt: Test labels

The entire data set is partitioned into X_train.txt and X_test.txt The corresponding activity numbers for the observations are in y_train.txt 
and y_test.txt respectively.So the complete data set must be compiled by combining these two data sets The column headers are in features.txt  

The project requires to select only variables that have mean() and std()  There are 66 variables that fit this criteria The tidy data requires 
data aggregated for all the subjects ( ie30) for all activities (i.e. 6) So the final tidy data set is expected to have 6 * 30 = 180 rows  for all 
subjects and activities and  66 variables + subject + activities = 68 columns 

###Collection of the raw data
The following link explains how the original data is collected and pre-processed from the  30 volunteers 
[UCI Machine Learning Repository- Data Set](https://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI%20HAR%20Dataset.names)

###Notes on the original (raw) data 
There are total 30 volunteers (or subjects) The train data set contains 70% of the volunteer population and the test data set contains 30%.
So the train data set  contains activities 21 subjects (volunteers) and the test data set contains 9 subjects.  There are 7352 observations on the train
data set and 2947 observations on the test data set.  Out of the total 10299 observations the no of observations for each subject is not equal
as seen below. 
``` {r}
## Here sel_data is the data set containing variables selected for this project
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

Also the variable names for mean() and std() mentioned within features_info.txt is different than that is provided in features.txt. The incorrect variable 
names need to be cleaned. 

features_info.txt variable names
---
```
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag
```
features.txt variable names from the data set
---
```
[64] "fBodyBodyAccJerkMag-std()"   "fBodyBodyGyroMag-mean()"     "fBodyBodyGyroMag-std()"     
[67] "fBodyBodyGyroJerkMag-mean()" "fBodyBodyGyroJerkMag-std()" 
```
##Creating the tidy datafile
  
###Guide to create the tidy data file
Following are the  steps to create the tidy data file. The names within the () at  the end represent the actual names of variables within the script:
	
	1. Download the data files from [Project Data Set] (https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)
	2. load the  "features.txt" from "UCI HAR Dataset" directory  into a data table (fact)
	3. Load the "activity_labels.txt" from "UCI HAR Dataset" directory  into a data table (act_lab)
	4. Observe the values and organization of variables and data in these two files 
	5. Change the directory to "test" to get the "test" observations
	6. Load the "subject_test.txt" (to get the subject number for each of the observation) into a data table (subject_test) 
	7. Load the "X_test.txt" into a data table (x_test)
	8. Load the "y_test.txt" into a data table (to get the activity number of the observation)(y_test)
	9. Observe the values and organization of variables and data in these three files from steps 6,7 & 8
	10. Change the directory to "train" to get the "train" observations
	11. Load the "subject_train.txt" (to get the subject number for each of the observation) into a data table (subject_train)
	12. Load the "X_train.txt" into a data table (x_train)
	13. Load the "y_train.txt" into a data table (to get the activity number of the observation) (y_train)
	14. Observe the values and organization of variables and data in these two files from steps 11,12 & 13
	15. Form one data set by  combining the train and test data sets.Attach the column headers and row headers as shown below:
		a. Attach X_train data  below the X_test data (data)
		b. Attach the column names for the observations from step 2 on top of this data set (data)
		c. Retain only the columns containing mean() and std() in their variables. care is taken not to include variables like meanFreq() (sel_data)
		d. Attach the subject_train below the subject_train data (subjects)
		e. Attach the y_train data below y_test data (activities)
		f. Attach subjects,activities as  "Subjects" and "Activities1" columns to the sel_data data table.
		g. Add a column "Activities" by resolving the activity numbers on "Activities1" to activity labels using act_lab data set from step 2
		h. Drop Activities1 column 
		i. Replace the column names which are erroneously defined with the correct name. 
		j. Now sel_data contains required columns in the required format.
	16. Clean the observations data by aggregating into subjects and activities as follows:
		a. Melt the data using Subjects and Activities as id column (melt_data)
		b. Aggregate (get the mean) the molten data by Activities,Subjects,Variables columns. This will get one value for each subject,activity 
			and a variable combination.
		c. Assign a tidy data set by transposing  the molten data into a wide format so we get tidy_data in the following format.
		  "Activities", "Subjects" ,"tBodyAcc-mean()-X" ,"tBodyAcc-mean()-Y","tBodyAcc-mean()-Z","tBodyAcc-std()-X","tBodyAcc-std()-Y" etc

###Cleaning of the data
 The above guide gives a great detail on the steps. This section concentrates on specific steps that specify the cleaning activities:
 Step 15 (c) - Retain only the columns containing mean() and std() in their variables. care is taken not to include variables like meanFreq() (sel_data)
 This step uses grep to pick columns that have mean() or std() as part of their name. 
 ```
 sel_col_nm <- grep("*.(mean|std)\\(\\)*",colnames(data))
 sel_data <- data[,sel_col_nm]
 ```
  
 Step 15 (g) - Add a column "Activities" by resolving the activity numbers on "Activities1" to activity labels using act_lab data set from step 2
 This step is accomplished by looking up the activity labels from act_lab dataset based on the Activities number in Activities1 variable. 
 
 ```
 Activities = as.character(act_lab$V2)[sel_data$Activities1]
 ```
 Step 15 (i) -  Replace the column names which are erroneously defined with the correct name. 
 The following code replaces the columns that contains "BodyBody" with "Body" as specified in the section "Notes on Original (Raw) Data"
 ```
 colnames(sel_data) <- sub("BodyBody","Body",colnames(sel_data))
 ```
 Step 16: Clean the observations data by aggregating into subjects and activities as follows:
 The following code melts the columns, aggregates it and converts to wide format. Pls. note that change to Subjects variables is changed to factor 
 for easy manipulation.
 ```
 melt_data <- melt(sel_data,id.vars = c("Subjects","Activities"))
 sel_data <- sel_data %>% mutate(Subjects1 = factor(Subjects)) %>% select (-Subjects) %>% rename(Subjects = Subjects1)
 melt_data <- melt(sel_data,id.vars = c("Subjects","Activities"))
 act_sub_var <- group_by(melt_data, Activities,Subjects,variable)
 sum_data <- summarize(act_sub_var,mean(value))
 tidy_data <- dcast(sum_data, Activities+Subjects ~ variable, value.var = "mean(value)")

 ```
 
 
Short, high-level description of what the cleaning script does [link to the readme document that describes the code in greater detail]()
 
##Description of the variables in the tiny_data.txt file
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
