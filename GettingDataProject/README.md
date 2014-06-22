README
--------------------------------------------------
This is a readme file that explain how the script run_analysis.r works. The file is the final r code that process and create a tidy data. It works with data recolected from Samsung II smartphones devices. This data was used in a research about wareable computing and that it can be used for machine learning researches. It was download in the UCI website: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The Readme file starts explaning the steps to accomplish the project of Getting and Cleaning Data after you create a folder and download the data sets unzipped.

I devided this Readme into 3 parts: 
- Reading Data
- Data Processing
- Final Data

### Reading Data
For data reading you can use read.table because all data sets are txt files. You can assign column names in same command.
First, I read features and activities and load them to data frames. Then the training and test related files.
These files are:
- X files: files containing all data values from the Samsung experiments
- Y files: files containing the associated activity to X dat
- Subject Files: subjects that participaded in the experiment

```{r}
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
```

### Data Processing

First I combined training datasets, then test data sets with colmn bind. The results of this are 2 new dataframes that can be combined with row binding in order to have only one dataframe that we could use in the rest of the project:

```{r}
allData <- rbind(
        cbind(trainingSubject,trainingData,trainingActivity),
        cbind(testSubject,testData,testActivity)
)
```

I created a new variable called featureFiltered. It contains all features that have mean() or std() pattern. It is better to include parentheses (), because without it you could select features as angle(tBodyAccMean,gravity), and I interpreted that as a result of a function that use a Mean as a paramater and not a mean feature. You could use sqldf package to select this patterns with *like* clause.

```{r}
featuresFiltered <- sqldf("select description from features where Description like '%mean()%' 
                          or description like '%std()%'")
```

I created a vector with the columns required, and added subject.id and activity.id this vector. With this vector I can subset Data with mean and std features for each activiy and subject.

```{r}
columnsRequired <- c("subject.id",featuresFiltered,"activity.id")

#new variable with Mean and Std columns
allMeanStd <- allData[,columnsRequired]
```


Then I merged activity.id with its label, and apply a melt function in order to have all features and its activity description in one tidy dataset

```{r}
allMeanStdWithLabels <- merge(allMeanStd,activityLabels,by="activity.id")

allDataMelted <- melt(allMeanStdWithLabels, id.vars=c("activity.id", "activity.description","subject.id"))
```

### Final Data

After the information was processed, we could assing better names to features. For all those that starts with *t*, I used paste function and substring to replace the t with *time* word, and the *f* replaced by fastFourier. I realized this with the following code:

```{r}
allDataMelted$variable = gsub('\\.','',allDataMelted$variable)
allDataMelted$variable = gsub('mean','Mean',allDataMelted$variable)
allDataMelted$variable = gsub('std','Std',allDataMelted$variable)

allDataMelted[substring(allDataMelted$variable,1,1) == "t",c("variable")] <- 
        paste("time",substring(allDataMelted[substring(allDataMelted$variable,1,1) == "t",c("variable")],2),sep="")

allDataMelted[substring(allDataMelted$variable,1,1) == "f",c("variable")] <- 
        paste("fastFourier",substring(allDataMelted[substring(allDataMelted$variable,1,1) == "f",c("variable")],2),sep="")

allDataMelted$subject.description <- paste("subject",allDataMelted$subject.id)
```

Finally, I applied dcast function to data with FUN=mean to calculate average, in order to have a tidy wide data, for better reading, one observation per row, by subject and activity ID, so final data has 180 rows (because 30 subject * 6 activities) with 66 Columns features or variables (mean and std columns)
I decided this after reading Hadley Wickham Tidy Data book that says: "*each variable is a column, each observation is a row*".

Then I created the csv file that I uploaded to Coursera whith the ordered final data.

```{r}
finalData <- dcast(data = allDataMelted, activity.id + activity.description + subject.id + subject.description ~ variable, fun = mean)

finalData <- arrange(finalData,activity.id,subject.id)

write.csv(finalData,"tidyData.csv")

```

