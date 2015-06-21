###########################################################################################################
# R Code : run_analysis.R
# Author : Srinivasan BV Sastry
# Date   : Jun-21-2015 
#
# This run_analysis.R code prepares a tidy data based on 
# "Human Activity Recognition Using Smart phones Dataset Version 10" data set 
# collected from  the https://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) 
# It is assumed that this r code is placed in the  "UCI HAR Dataset" directory after the data set
# is extracted before execution.
#
# The README.md and "code book.md" describes the columns and steps in greated detail
# args : no arguments
# 
# Improvements  :  1, The existence of the files and read status of the files can be checked by 
# for next ver.       creating a new function 
#                  2. The descriptive column names can  be read from a file rather than embedded in the 
#                     code
# #########################################################################################################

# Load the required libraries   
        library(dplyr)
        library(reshape2)
        
# load the  "features.txt" from "UCI HAR Dataset" directory  into a data table
        fact <- read.table("features.txt")

# Load the "activity_labels.txt" from "UCI HAR Dataset" directory  into a data table
        act_lab <- read.table("activity_labels.txt")
        
# Load the subject_test, x_test and y_test data from test directory
        setwd("./test")
        subject_test <- read.table("subject_test.txt")
        x_test <- read.table("X_test.txt")
        y_test <- read.table("y_test.txt")
        
# Load the subject_train, x_train and y_train data from train directory 
        setwd("../train")
        subject_train <- read.table("subject_train.txt")
        x_train <- read.table("X_train.txt")
        y_train <- read.table("y_train.txt")
        
# Attach X_train data  below the X_test data (data)
        data <- rbind(x_test)
        data <- rbind(data,x_train)
        
# Attach the column names for the observations 
        colnames(data) <- fact[,2]
        
# Retain only the columns containing mean() and std() in their variables
        sel_col_nm <- grep("*.(mean|std)\\(\\)*",colnames(data))
        sel_data <- data[,sel_col_nm]
        last_col = ncol(sel_data)

# Form the subjects information for the observations
        subjects <- rbind(subject_test)
        subjects <- rbind(subjects,subject_train)
        
# Attach the subjects information to the sel_data (selected data) data set and
# provide a column name 
        sel_data <- cbind(sel_data,subjects)
        colnames(sel_data)[last_col+1] <- "Subjects"
 
# Form the Activities information for the observations
        activities <- rbind(y_test)
        activities <- rbind(activities, y_train)
    
# Attach the Activities information to the sel_data (selected data) data set and
# provide a column name

        sel_data <- cbind(sel_data,activities)
        colnames(sel_data)[last_col+2] <- "Activities1"
        
# Add a column "Activities" by resolving the activity numbers on "Activities1" 
# to activity labels using  act_lab data set
        Activities = as.character(act_lab$V2)[sel_data$Activities1]
        sel_data <- cbind(sel_data,Activities)
        sel_data <- select(sel_data, -Activities1)

# Replace the column names which are erroneously defined with the correct names

        colnames(sel_data) <- sub("BodyBody","Body",colnames(sel_data))

# Add a Subjects column as a factor for easy computation.
        sel_data <- sel_data %>% mutate(Subjects1 = factor(Subjects)) %>% select (-Subjects) %>% rename(Subjects = Subjects1)

# Melt the data using Subjects and Activities as id column      
        melt_data <- melt(sel_data,id.vars = c("Subjects","Activities"))

# group by Activities,Subjects, variable to get the mean value of each variable 
# by Activities and Subjects
        act_sub_var <- group_by(melt_data, Activities,Subjects,variable)
        sum_data <- summarize(act_sub_var,mean(value))

# Flip the data to a wider tidy data set  
        tidy_data <- dcast(sum_data, Activities+Subjects ~ variable, value.var = "mean(value)")

# Change the Variable names to descriptive names.
        colnames(tidy_data) <- c("Activities",
                                 "Subjects",
                                 "Mean value of the time domain body acceleration signals across X - axis",
                                 "Mean value of the time domain body acceleration signals across  Y - axis",
                                 "Mean value of the time domain body acceleration signals across  Z - axis",
                                 "Standard Deviation of the time domain body acceleration signals across X - axis",
                                 "Standard Deviation of the time domain body acceleration signals across Y - axis",
                                 "Standard Deviation of the time domain body acceleration signals across Z- axis",
                                 "Mean value of the time domain gravity accelation signals across X - axis",
                                 "Mean value of the time domain gravity accelation signals across Y - axis",
                                 "Mean value of the time domain gravity accelation signals across Z - axis",
                                 "Standard deviation  of the time domain gravity accelation signals across X - axis",
                                 "Standard deviation  of the time domain gravity accelation signals across Y - axis",
                                 "Standard deviation  of the time domain gravity accelation signals across Z - axis",
                                 "Mean value of the time domain body acceleration Jerk signals across X - axis",
                                 "Mean value of the time domain body acceleration Jerk signals across Y - axis",
                                 "Mean value of the time domain body acceleration Jerk signals across Z - axis",
                                 "Standard deviation of the time domain body acceleration Jerk signals across X - axis",
                                 "Standard deviation of the time domain body acceleration Jerk signals across Y - axis",
                                 "Standard deviation of the time domain body acceleration Jerk signals across Z - axis",
                                 "Mean value of the time domain body gyro signals across X - axis",
                                 "Mean value of the time domain body gyro signals across Y - axis",
                                 "Mean value of the time domain body gyro signals across Z - axis",
                                 "Standard deviation  of the time domain body gyro signals across X - axis",
                                 "Standard deviation of the time domain body gyro signals across Y - axis",
                                 "Standard deviation  of the time domain body gyro signals across Z - axis",
                                 "Mean value of the time domain body gyro Jerk signals across X - axis",
                                 "Mean value of the time domain body gyro Jerk signals across Y - axis",
                                 "Mean value of the time domain body gyro Jerk signals across Z - axis",
                                 "Standard Deviation of the time domain body gyro Jerk signals across X - axis",
                                 "Standard Deviation of the time domain body gyro Jerk signals across Y - axis",
                                 "Standard Deviation of the time domain body gyro Jerk signals across Z - axis",
                                 "Mean value of the time domain body acceleration magnitude values",
                                 "Standard deviation  of the time domain body acceleration magnitude values",
                                 "Mean value of the time domain gravity magnitude values",
                                 "Standard Deviation of the time domain gravity magnitude values",
                                 "Mean value of the time domain body acceleration Jerk magnitude values",
                                 "Standard deviation of the time domain body acceleration Jerk magnitude values",
                                 "Mean value of the time domain body acceleration gyro magnitude values",
                                 "Standard deviation of the time domain body acceleration gyro magnitude values",
                                 "Mean value of the time domain body acceleration gyro jerk magnitude values",
                                 "Standard deviation of the time domain body acceleration gyro Jerk magnitude values",
                                 "Mean value of the frequency  domain body acceleration signals across X - axis",
                                 "Mean value of the frequency  domain body acceleration signals across Y - axis",
                                 "Mean value of the frequency  domain body acceleration signals across Z - axis",
                                 "Standard deviation  of the frequency  domain body acceleration signals across X - axis",
                                 "Standard deviation  of the frequency  domain body acceleration signals across Y - axis",
                                 "Standard deviation of the frequency  domain body acceleration signals across Z - axis",
                                 "Mean value of the frequency domain body acceleration Jerk signals across X - axis",
                                 "Mean value of the frequency domain body acceleration Jerk signals across  Y- axis",
                                 "Mean value of the frequency domain body acceleration Jerk signals across Z - axis",
                                 "Standard deviation  of the frequency domain body acceleration Jerk signals across X - axis",
                                 "Standard deviation of the frequency domain body acceleration Jerk signals across  Y- axis",
                                 "Standard deviation of the frequency domain body acceleration Jerk signals across Z - axis",
                                 "Mean value of the frequency domain body gyro signals across X - axis",
                                 "Mean value of the frequency domain body gyro signals across  Y - axis",
                                 "Mean value of the frequency domain body gyro signals across  Z- axis",
                                 "Standard deviation of the frequency domain body gyro signals across X - axis",
                                 "Standard deviation value of the frequency domain body gyro signals across  Y - axis",
                                 "Standard deviation value of the frequency domain body gyro signals across  Z- axis",
                                 "Mean value of the frequency domain body acceleration magnitude values",
                                 "Standard Deviation  of the frequency domain body acceleration magnitude values",
                                 "Mean value of the frequency domain body acceleration Jerk magnitude values",
                                 "Standard deviation of the frequency domain body acceleration Jerk magnitude values",
                                 "Mean value of the frequency domain body acceleration gyro magnitude values",
                                 "Standard deviation  of the frequency domain body acceleration gyro magnitude values",
                                 "Mean value of the frequency domain body acceleration gyro jerk magnitude values",
                                 "Standard deviation  of the frequency domain body acceleration gyro jerk magnitude values"
        )
# Write the tidy data to a text file.

        write.table(tidy_data,file = "tidy_data.txt",row.name=FALSE)


