CodeBook
--------------------------------------------------
This file describes the data, the variables, and any transformations or work that you performed to clean up the data

### Data
* `features` - data with 561 features
* `activityLabels` - activity performed by the subject, like WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING
* `trainingData` - training data of all features by subject and activity, 7,352 rows and 561 columns
* `trainingActivity` - activity associated to training data, 7,532 rows with 1 colum
* `trainingSubject` - subject associated to training data, 7,532 rows with 1 colum
* `testData` - test data of all features by subject and activity, 2,947 rows and 561 columns
* `testActivity` - activity associated to test data, 2,947 rows and 561 columns
* `testSubject` - subject associated to test data, 2,947 rows and 561 columns

### Extracted Features
* `tBodyAcc-mean()-X`
* `tBodyAcc-mean()-Y`
* `tBodyAcc-mean()-Z`
* `tBodyAcc-std()-X`
* `tBodyAcc-std()-Y`
* `tBodyAcc-std()-Z`
* `tGravityAcc-mean()-X`
* `tGravityAcc-mean()-Y`
* `tGravityAcc-mean()-Z`
* `tGravityAcc-std()-X`
* `tGravityAcc-std()-Y`
* `tGravityAcc-std()-Z`
* `tBodyAccJerk-mean()-X`
* `tBodyAccJerk-mean()-Y`
* `tBodyAccJerk-mean()-Z`
* `tBodyAccJerk-std()-X`
* `tBodyAccJerk-std()-Y`
* `tBodyAccJerk-std()-Z`
* `tBodyGyro-mean()-X`
* `tBodyGyro-mean()-Y`
* `tBodyGyro-mean()-Z`
* `tBodyGyro-std()-X`
* `tBodyGyro-std()-Y`
* `tBodyGyro-std()-Z`
* `tBodyGyroJerk-mean()-X`
* `tBodyGyroJerk-mean()-Y`
* `tBodyGyroJerk-mean()-Z`
* `tBodyGyroJerk-std()-X`
* `tBodyGyroJerk-std()-Y`
* `tBodyGyroJerk-std()-Z`
* `tBodyAccMag-mean()`
* `tBodyAccMag-std()`
* `tGravityAccMag-mean()`
* `tGravityAccMag-std()`
* `tBodyAccJerkMag-mean()`
* `tBodyAccJerkMag-std()`
* `tBodyGyroMag-mean()`
* `tBodyGyroMag-std()`
* `tBodyGyroJerkMag-mean()`
* `tBodyGyroJerkMag-std()`
* `fBodyAcc-mean()-X`
* `fBodyAcc-mean()-Y`
* `fBodyAcc-mean()-Z`
* `fBodyAcc-std()-X`
* `fBodyAcc-std()-Y`
* `fBodyAcc-std()-Z`
* `fBodyAccJerk-mean()-X`
* `fBodyAccJerk-mean()-Y`
* `fBodyAccJerk-mean()-Z`
* `fBodyAccJerk-std()-X`
* `fBodyAccJerk-std()-Y`
* `fBodyAccJerk-std()-Z`
* `fBodyGyro-mean()-X`
* `fBodyGyro-mean()-Y`
* `fBodyGyro-mean()-Z`
* `fBodyGyro-std()-X`
* `fBodyGyro-std()-Y`
* `fBodyGyro-std()-Z`
* `fBodyAccMag-mean()`
* `fBodyAccMag-std()`
* `fBodyBodyAccJerkMag-mean()`
* `fBodyBodyAccJerkMag-std()`
* `fBodyBodyGyroMag-mean()`
* `fBodyBodyGyroMag-std()`
* `fBodyBodyGyroJerkMag-mean()`
* `fBodyBodyGyroJerkMag-std()`

### Activities 
* `WALKING`
* `WALKING_UPSTAIRS`
* `WALKING_DOWNSTAIRS`
* `SITTING`
* `STANDING`
* `LAYING`

### Variables
* `allData` - contains all data combining 3 training dataframes and 3 test dataframe in just one. `cbind` and `rbind` were used to join all data. As a result, 10,299 rows with 563 variables (activity+subject+561 features)
* `featuresFiltered` - feautures that contains std() and mean() text, in order to subset data required in the assignment. As result, a vector with 66 elements
* `featuresFiltered` - Transformation that replaces parentheses by periods . in order to match with allData data frame, filled with `gsub('\\(|\\)|\\-','.',featuresFiltered$description)`
* `columnsRequired` - 66 vector plus subject and activity element
* `allMeanStd` - subsetting columns, in order to get just *mean* and *std* information, filled with `allData[,columnsRequired]` 
* `allMeanStdWithLabels` - Transformation that assign an activit label to activity id, filled with `merge(allMeanStd,activityLabels,by="activity.id")`
* `allDataMelted` - Transformation to create a column with all features by activity and subject, filled with `melt(allMeanStdWithLabels, id.vars=c("activity.id", "activity.description","subject.id"))`
* `finalData` - Transformation that creates a new variable with average information for each subject and activiry, filled with `dcast(data = allDataMelted, activity.id + activity.description + subject.id + subject.description ~ variable, fun = mean)`


### Transformations
* `allDataMelted$variable <- gsub('\\.','',allDataMelted$variable)` - Transformation, replace the . with white space in order to get better features reading
* `allDataMelted$variable <- gsub('mean','Mean',allDataMelted$variable)` - Transformation, replace with uppercase the word *mean* in order to get better features reading
* `allDataMelted$variable <- gsub('std','Std',allDataMelted$variable)` - Transformation, replace with uppercase the word *std* in order to get better features reading
* `allDataMelted[substring(allDataMelted$variable,1,1) == "t",c("variable")] <- 
        paste("time",substring(allDataMelted[substring(allDataMelted$variable,1,1) == "t",c("variable")],2),sep="")` - Transformation, replace the initial *t* with the word *time*, for better features reading
* `allDataMelted[substring(allDataMelted$variable,1,1) == "f",c("variable")] <- 
        paste("fastFourier",substring(allDataMelted[substring(allDataMelted$variable,1,1) == "f",c("variable")],2),sep="")` - Transformation, replace the initial *w* with the word *fastFourier*, for better features reading
* `allDataMelted$subject.description <- paste("subject",allDataMelted$subject.id)` - Transformation that creates a better label for subjects id, e.g. *subject 1* instead of 1 number










