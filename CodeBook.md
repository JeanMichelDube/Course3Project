#Code Book for the Course R Project script run_analysis.R

# First task : Merge the training and the test sets to create one data set.

## Install and compile required packages : downloader, data.table and plyr.

## Download and unzip the data (skip this step if data has been dowloanded and unzipped)

##Read subject file for train and test, merge them and prepare column name

dtSubjectTrain reads "subject_train.txt"

dtSubjectTest reads "subject_test.txt"

fullSubject binds dtSubjectTrain and dtSubjectTest, and renames column name V1 as Subject

##Read activity file for train and test, merge them and prepare column name

colTrain reads "y_train.txt"

colTest reads "y_test.txt"

fullActivity binds colTrain and colTest, and renames column name V1 as Activity

##Link subject to activities

SubjectActivity makes that link

##Read data file for train and test, merge them and add them to SubjectActivity table

dataTrain reads "x_train.txt"

dataTest reads "x_test.txt"

fulldata binds dataTrain and dataTest

finaldata binds SubjectActivity and fulldata

# Second task : Extracts only the measurements on the mean and standard deviation for each measurement.

##Read features and identify finaldata column names

features reads "features.txt" and we add a column to match data, addiding a V to line number.

line2 indentifies columns containing mean and std

##Create list of columns to keep for finaldata

featuresMS extracts lines from line2

featuresno extracts data for match

##Match to data table

finaldataMS only keeps mean and std from the data set created during the first task

#Third Task : Use descriptive activity names to name the activities in the data set

##Read activity labels

activityLabels reads "activity_labels.txt" and renames column V2 as ActivityName

##Merge Data with Activity Labels Name

mergedata merges data from task 2 to activity labels

##Repalce Activity column name and delete unused column

finaldataMSAct is mergedata tidied up.

##Write first table : finaldataMSAct appears as data_with_labels.txt on repo.

#Fourth Task : Appropriately labels the data set with descriptive variable names.

##Extract, then replace Column Names

longNames extracts column names from featuresMS

finaldataMSActNam replaces column names

#Fifth task: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

TidyData is the data sorted required as by the fifth task

##Write second table : TidyData appears as tidy_data.txt on repo.
