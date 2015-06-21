# Read me file  for Getting and Cleaning Data  project
The read me explains how the 5 steps were achieved and the code to create them. The order of the steps is not necessarily the same as 
requested by the project because when creating the code, it was better to follow the sequence given in the detailed steps for performance 
reason. As an example, it was better to remove the unwanted columns before the entire data set is collated. 

#### Project Step 1: Merges the training and the test sets to create one data set.
	 This step of the project is achieved  from the following detailed steps 1 through 16 (b).
#### Project Step 2 :Extracts only the measurements on the mean and standard deviation for each measurement. 
	 This project step is achieved from the detailed step  13 (c).
#### Project Step 3: Uses descriptive activity names to name the activities in the data set.
     This project step is achieved from the detail step 13(g).
#### Project Step 4: Appropriately labels the data set with descriptive variable names.
     This project step is achieved from the detail step 14(d).
#### Project Step 5 : From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
	 This project step is achieved from the detail step.

## Detail Steps to create the Tidy data file	
Following are the  steps to create the tidy data file. The names within the () at  the end represent the actual names of variables within the script:

	1.	Load the (dplyr) and (reshaape2) libraries that are needed for this project. 
	2.	Download the data files from [Project Data Set] (https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)
	3.	load the  "features.txt" from "UCI HAR Dataset" directory  into a data table (fact)
	4.	Load the "activity_labels.txt" from "UCI HAR Dataset" directory  into a data table (act_lab)
	5.	Change the directory to "test" to get the "test" observations
	6.	Load the "subject_test.txt" (to get the subject number for each of the observation) into a data table (subject_test) 
	7.	Load the "X_test.txt" into a data table (x_test)
	8.	Load the "y_test.txt" into a data table (to get the activity number of the observation)(y_test)
	9.	Change the directory to "train" to get the "train" observations
	10.	Load the "subject_train.txt" (to get the subject number for each of the observation) into a data table (subject_train)
	11.	Load the "X_train.txt" into a data table (x_train)
	12.	Load the "y_train.txt" into a data table (to get the activity number of the observation) (y_train)
	13.	Form one data set by combining the train and test data sets. Attach the column headers and row headers as shown below:
		a.	Attach X_train data  below the X_test data (data)
		```
		data <- rbind(x_test)
        data <- rbind(data,x_train)
		```
		b.	Attach the column names for the observations from step 2 on top of this data set (data)
		```
		colnames(data) <- fact[,2]
		```
		c.	Retain only the columns containing mean() and std() in their variables. 
		    care is taken not to include variables like meanFreq() (sel_data)
		```	
		sel_col_nm <- grep("*.(mean|std)\\(\\)*",colnames(data))
		sel_data <- data[,sel_col_nm]
		```
		d.	Attach the subject_train below the subject_test data (subjects)
		```
		subjects <- rbind(subject_test)
        subjects <- rbind(subjects,subject_train)
		```
		e.	Attach the y_train data below y_test data (activities)
		```
		activities <- rbind(y_test)
        activities <- rbind(activities, y_train)
		```
		f.	Attach subjects,activities as  "Subjects" and "Activities1" columns to the sel_data data table.
		```
		sel_data <- cbind(sel_data,activities)
        colnames(sel_data)[last_col+2] <- "Activities1"
		```
		g.	Add a column "Activities" by resolving the activity numbers on "Activities1" to activity labels using 
		    act_lab data set from step 2
		```
		Activities = as.character(act_lab$V2)[sel_data$Activities1]
        ```		
		h.	Drop Activities1 column 
		i.	Replace the column names which are erroneously defined with the correct name.  Please note that even though we are going to 
		    replace the column names with more descriptive names. However if these descriptive names are not required then this step will 
			get cleaner names.
		```
		colnames(sel_data) <- sub("BodyBody","Body",colnames(sel_data))
		```
		j.	Now sel_data contains required columns in the required format.
	14.	Clean the observations data by aggregating into subjects and activities as follows:
		 ```
		melt_data <- melt(sel_data,id.vars = c("Subjects","Activities"))
        act_sub_var <- group_by(melt_data, Activities,Subjects,variable)
        sum_data <- summarize(act_sub_var,mean(value))
        tidy_data <- dcast(sum_data, Activities+Subjects ~ variable, value.var = "mean(value)")
		```

		a.	Melt the data using Subjects and Activities as id column (melt_data)
		b.	Aggregate (get the mean) the molten data by Activities,Subjects,Variables columns. 
			This will get one value for each subject,activity and a variable combination.
		c.	Assign a tidy data set by transposing  the molten data into a wide format so we get tidy_data in the following format.
		 "Activities", "Subjects" ,"tBodyAcc-mean()-X" ,"tBodyAcc-mean()-Y","tBodyAcc-mean()-Z","tBodyAcc-std()-X","tBodyAcc-std()-Y" etc
		d. Assign the column names of the tidy data set with more descriptive names of the variables. 
		  Please note that these names are really long as required by the project.
		  
## Reading the tidy data into R.
```
   # Download the tidy_data.txt file from the coursera project submission
   # Substitute the file_path with the actual file path where the tidy_data.txt was downloaded.
    data <- read.table(file_path, header = TRUE) 
    View(data)
```
##Sources
[Code Book Template from DSS Community Site] (https://gist.github.com/JorisSchut/dbc1fc0402f28cad9b41)

[David's personal course project FAQ] (https://class.coursera.org/getdata-015/forum/thread?thread_id=26)

[Tidy Data and Assignment] (https://class.coursera.org/getdata-015/forum/thread?thread_id=27)

[Coursera Discussion Forums](https://class.coursera.org/getdata-015/forum/list?forum_id=10009)

[Stack Overflow - various pages](www.stackoverflow.com)

[An Introduction to reshape2](http://seananderson.ca/2013/10/19/reshape.html) 

CRAN Pages

