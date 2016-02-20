#Merges the training and the test sets to create one data set.

##install downloader, data.table and plyr packages.

install.packages("downloader")
library(downloader)
install.packages("data.table")
library(data.table)
install.packages("plyr")
library(plyr)

##Easily download and unzip the data
download("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",dest="dataset.zip",mode="wb")
unzip ("dataset.zip")

##Read subject file for train and test, merge them and prepare column name

dtSubjectTrain <- fread(file.path("UCI HAR Dataset","train","subject_train.txt"))
dtSubjectTest <- fread(file.path("UCI HAR Dataset","test","subject_test.txt"))
fullSubject= rbind(dtSubjectTrain,dtSubjectTest)
fullSubject= rename(fullSubject, c("V1"="Subject"))

##Read activity file for train and test, merge them and prepare column name
colTrain <- fread(file.path("UCI HAR Dataset","train","y_train.txt"))
colTest <- fread(file.path("UCI HAR Dataset","test","y_test.txt"))
fullActivity <- rbind(colTrain,colTest)
fullActivity= rename(fullActivity, c("V1"="Activity"))

##Link subject to activities and name columns
SubjectActivity <- cbind(fullSubject,fullActivity)

##Read data file for train and test, merge them and add them to SubjectActivity table
dataTrain <- fread(file.path("UCI HAR Dataset","train","x_train.txt"))
dataTest <- fread(file.path("UCI HAR Dataset","test","x_test.txt"))
fulldata <- rbind(dataTrain,dataTest)
finaldata <- cbind(SubjectActivity,fulldata)

# Extracts only the measurements on the mean and standard deviation for each measurement.

##Read features and identify finaldata column names
features <- fread(file.path("UCI HAR Dataset","features.txt"))
features$NewColumn = features[, paste0("V", as.character(features$V1))]
line2 = grep("mean\\(\\)|std\\(\\)",features$V2)

##Create list of columns to keep from finaldata
featuresMS <- features[line2]
featuresno = featuresMS$NewColumn
featuresno = c("Subject","Activity",featuresno)

##Match to data table
finaldataMS <- finaldata[,featuresno,with = FALSE]

#Use descriptive activity names to name the activities in the data set

##Read activity labels and merge with finaldataMS
activityLabels <- fread(file.path("UCI HAR Dataset","activity_labels.txt"))
activityLabels= rename(activityLabels, c("V2"="ActivityName"))

##Merge Data with Activity Labels Name
mergedata = merge(finaldataMS,activityLabels,by.x="Activity",by.y="V1",all.x=TRUE)

##Repalce Activity column name and delete unused column
mergedata$Activity = mergedata$ActivityName
finaldataMSAct = subset( mergedata, select = -ActivityName )

##Write first table
write.table(finaldataMSActNam, "data_with_labels.txt")

#Appropriately labels the data set with descriptive variable names.

##Extract, then replace Column Names
longNames = featuresMS$V2
finaldataMSActNam = setnames(finaldataMSAct,3:68,c(longNames))

#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
TidyData <- finaldataMSActNam[, lapply(.SD, mean), by = 'Subject,Activity']

##Write second table
write.table(TidyData, "tidy_data.txt")
