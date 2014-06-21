#Install and load reshape packages if you dont have them
#install.packages("reshape")
#install.packages("reshape2")
#library(reshape)
#library(reshape2)


############# READING DATA #############

#Reading Features
features <- read.table(file="UCI HAR Dataset/features.txt", col.names= c("no","description"))
#Reading Activities
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt",col.names=c("activity.id","activity.description"))

#Reading Training Data and its respective Activity and Subject
trainingData <- read.table(file="UCI HAR Dataset/train/X_train.txt", col.names=features$description)
trainingActivity <- read.table(file="UCI HAR Dataset/train/Y_train.txt",col.names=c("activity.id"))
trainingSubject <- read.table(file="UCI HAR Dataset/train/subject_train.txt",col.names=c("subject.id"))

#Reading Test Data, Activity and Subject
testData <- read.table(file="UCI HAR Dataset/test/X_test.txt", col.names=features$description)
testActivity <- read.table(file="UCI HAR Dataset/test/Y_test.txt",col.names=c("activity.id"))
testSubject <- read.table(file="UCI HAR Dataset/test/subject_test.txt",col.names=c("subject.id"))


############# COMBINING DATA #############


#first, I combined by column 3 Training dataframe, and same for Test dataframes
#then I combined all and create a new variable

allData <- rbind(
        cbind(trainingSubject,trainingData,trainingActivity),
        cbind(testSubject,testData,testActivity)
)


############# SUBSETTING AND FILTERING DATA #############

#Selecting fetaures with sqldf package, the features that contains mean and std in text
featuresFiltered <- sqldf("select description from features where Description like '%mean()%' 
                          or description like '%std()%'")
#ommiting parenthesis and minus sign, in order to do a merge with the combined Data
#when you combine data, R automatically replace ()- with a period .
featuresFiltered <- gsub('\\(|\\)|\\-','.',featuresFiltered$description)

#making a vector of columns required in order to minimize columns, and let just the filtered one
#subject.id, and activity.id are added manually
columnsRequired <- c("subject.id",featuresFiltered,"activity.id")

#new variable with Mean and Std columns
allMeanStd <- allData[,columnsRequired]


############# MERGING DATA WITH LABELS #############

#merging activity.id with its label, merge automatically sort data, so is better to
#use it here than before you combined column and rows

allMeanStdWithLabels <- merge(allMeanStd,activityLabels,by="activity.id")

#melt data so you can calculate more easy avarage of each activity
allDataMelted <- melt(allMeanStdWithLabels, id.vars=c("activity.id", "activity.description","subject.id"))


############# ASSIGNING BETTER LABELS TO COLUMNS AND SUBJECT DATA #############

allDataMelted$variable = gsub('\\.','',allDataMelted$variable)
allDataMelted$variable = gsub('mean','Mean',allDataMelted$variable)
allDataMelted$variable = gsub('std','Std',allDataMelted$variable)


allDataMelted[substring(allDataMelted$variable,1,1) == "t",c("variable")] <- 
        paste("time",substring(allDataMelted[substring(allDataMelted$variable,1,1) == "t",c("variable")],2),sep="")

allDataMelted[substring(allDataMelted$variable,1,1) == "f",c("variable")] <- 
        paste("fastFourier",substring(allDataMelted[substring(allDataMelted$variable,1,1) == "f",c("variable")],2),sep="")

allDataMelted$subject.description <- paste("subject",allDataMelted$subject.id)


############# SUMMARIZING DATA #############

#dcast data with FUN=mean to calculate average, in order to have a tidy wide data, for better reading,
#one observation per row, as Hadley Wickham recommends in his Tidy Data book
#"each variable is a column, each observation is a row"

finalData <- dcast(data = allDataMelted, activity.id + activity.description + subject.id + subject.description ~ variable, fun = mean)

############# FINAL DATA ORDERED BY ACTIVITY AND SUBJECT #############

finalData <- arrange(finalData,activity.id,subject.id)

write.csv(finalData,"tidyData.csv")


