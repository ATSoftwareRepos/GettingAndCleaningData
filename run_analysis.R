#get directory of Samsung Data
setwd(choose.dir(caption = "Select the UCI HAR Dataset Folder"))


#create table of test data
testdata <- read.table("test\\X_test.txt")
testtasks <- read.table("test\\y_test.txt")
testsubjects <- read.table("test\\subject_test.txt")
testers <- cbind(testsubjects, testtasks)
testtable <- cbind(testers,testdata)

#create table of training data
traindata <- read.table("train\\X_train.txt")
traintasks <- read.table("train\\y_train.txt")
trainsubjects <- read.table("train\\subject_train.txt")
trainers <- cbind(trainsubjects,traintasks)
traintable <- cbind(trainers,traindata)

#merge the training and test data
mergeddata <- rbind(testtable, traintable)


#rename first two columns to SUBJECT and TASK
library(dplyr)
names(mergeddata)[1:2] <- c("SUBJECT","TASK")
mergeddata <- arrange(mergeddata,SUBJECT)

#rename data to labels in features.txt
featurelabels <- read.table("features.txt")
names(mergeddata)[3:563] <- as.character(featurelabels$V2)
validnames <- make.names(names=names(mergeddata),unique=TRUE, allow_=TRUE)
names(mergeddata) <- validnames


#extract data only for columns for mean and std dev
finaldata <- select(mergeddata, SUBJECT, TASK, contains("mean"),contains("std"))

#convert tasks to factors
finaldata$TASK <- as.factor(finaldata$TASK)
activities <- read.table("activity_labels.txt")
levels(finaldata$TASK) <- activities$V2

# create summary data
grps <- group_by(finaldata, SUBJECT, TASK) 
summarydata <- summarize_each(grps, funs(mean), 3:88)

#write summary data to Samsung Data folder
write.table(summarydata, "summarydata.txt", row.name=FALSE)
