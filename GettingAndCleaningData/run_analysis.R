features <- read.table("UCI HAR Dataset/features.txt")
features <- as.character(features[,2])

colNames <- c("MeanBodyAcc-Time-XAxis", "MeanBodyAcc-Time-YAxis", "MeanBodyAcc-Time-ZAxis",
              "STDBodyAcc-Time-XAxis", "STDBodyAcc-Time-YAxis", "STDBodyAcc-Time-ZAxis",
              "MeanGravityAcc-Time-XAxis", "MeanGravityAcc-Time-YAxis", "MeanGravityAcc-Time-ZAxis",
              "STDGravityAcc-Time-XAxis", "STDGravityAcc-Time-YAxis", "STDGravityAcc-Time-ZAxis",
              "MeanBodyAccJerk-Time-XAxis", "MeanBodyAccJerk-Time-YAxis", "MeanBodyAccJerk-Time-ZAxis",
              "STDBodyAccJerk-Time-XAxis", "STDBodyAccJerk-Time-YAxis", "STDBodyAccJerk-Time-ZAxis",
              "MeanBodyGyro-Time-XAxis", "MeanBodyGyro-Time-YAxis", "MeanBodyGyro-Time-ZAxis",
              "STDBodyGyro-Time-XAxis", "STDBodyGyro-Time-YAxis", "STDBodyGyro-Time-ZAxis",
              "MeanBodyGyroJerk-Time-XAxis", "MeanBodyGyroJerk-Time-YAxis", "MeanBodyGyroJerk-Time-ZAxis",
              "STDBodyGyroJerk-Time-XAxis", "STDBodyGyroJerk-Time-YAxis", "STDBodyGyroJerk-Time-ZAxis",
              "MeanBodyAccMag-Time", "STDBodyAccMag-Time", "MeanGravityAccMag-Time", "STDGravityAccMag-Time", 
              "MeanBodyAccJerkMag-Time", "STDBodyAccJerkMag-Time", "MeanBodyGyroMag-Time", "STDBodyGyroMag-Time",
              "MeanBodyGyroJerkMag-Time", "STDBodyGyroJerkMag-Time",
              "MeanBodyAcc-Freq-XAxis","MeanBodyAcc-Freq-YAxis","MeanBodyAcc-Freq-ZAxis",
              "STDBodyAcc-Freq-XAxis","STDBodyAcc-Freq-YAxis","STDBodyAcc-Freq-ZAxis",
              "MeanBodyAccJerk-Freq-XAxis", "MeanBodyAccJerk-Freq-YAxis", "MeanBodyAccJerk-Freq-ZAxis",
              "STDBodyAccJerk-Freq-XAxis", "STDBodyAccJerk-Freq-YAxis", "STDBodyAccJerk-Freq-ZAxis",
              "MeanBodyGyro-Freq-XAxis", "MeanBodyGyro-Freq-YAxis", "MeanBodyGyro-Freq-ZAxis",
              "STDBodyGyro-Freq-XAxis", "STDBodyGyro-Freq-YAxis", "STDBodyGyro-Freq-ZAxis",
              "MeanBodyAccMag-Freq", "STDBodyAccMag-Freq", "MeanBodyBodyAccJerkMag-Freq", "STDBodyBodyAccJerkMag-Freq",
              "MeanBodyBodyGyroMag-Freq", "STDBodyBodyGyroMag-Freq", "MeanBodyBodyGyroJerkMag-Freq", "STDBodyBodyGyroJerkMag-Freq")

activityLabels <- c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING")

meanFilter <- grepl(".-mean\\(.", features)
stdFilter <- grepl(".std\\(.", features)
colFilter <- meanFilter | stdFilter

trainMeasurements <- read.table("UCI HAR Dataset/train/X_train.txt")
trainMeasurements <- trainMeasurements[,colFilter]
names(trainMeasurements) <- colNames

testMeasurements <- read.table("UCI HAR Dataset/test/X_test.txt")
testMeasurements <- testMeasurements[,colFilter]
names(testMeasurements) <- colNames

trainSubjID <- read.table("UCI HAR Dataset/train/subject_train.txt")
trainSubjID <- trainSubjID[,1]
trainMeasurements <- cbind(trainMeasurements, subjectID = trainSubjID)

testSubjID <- read.table("UCI HAR Dataset/test/subject_test.txt")
testSubjID <- testSubjID[,1]
testMeasurements <- cbind(testMeasurements, subjectID = testSubjID)

trainActivity <- read.table("UCI HAR Dataset/train/y_train.txt")
trainActivity <- trainActivity[,1]
trainActivity <- factor(trainActivity, levels=c(1,2,3,4,5,6), labels=activityLabels)
trainMeasurements <- cbind(trainMeasurements, activity = trainActivity)

testActivity <- read.table("UCI HAR Dataset/test/y_test.txt")
testActivity <- testActivity[,1]
testActivity <- factor(testActivity, levels=c(1,2,3,4,5,6), labels=activityLabels)
testMeasurements <- cbind(testMeasurements, activity = testActivity)

measurements <- rbind(trainMeasurements, testMeasurements)

myList <- by(measurements,measurements[,"activity"],function(x)
  {
    by(x,x$subjectID,function(y)
      {
        filteredDF <- y[,-c(67,68)]
        sapply(filteredDF,mean)
      })
  })

m <- matrix(0, ncol = 68, nrow = 0)
df <- data.frame(m)
names(df) <- c(colNames,"subjectID", "activity")
activity <- 1
for(filteredByActivity in myList)
{
  subjectID <- 1
  for(filteredByID in filteredByActivity)
  {
    filteredByID <- c(filteredByID,subjectID=subjectID)
    filteredByID <- c(filteredByID,activity=activity)
    df[nrow(df)+1,] <- filteredByID
    subjectID <- subjectID+1
  }
  activity <- activity+1
}

df[,"activity"] <- factor(df[,"activity"], levels=c(1,2,3,4,5,6), labels=activityLabels)

write.table(df, "final.txt", row.name=FALSE)