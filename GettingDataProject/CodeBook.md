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

### Variables and transformations
* `allData` - contains all data combining 3 training dataframes and 3 test dataframe in just one. `cbind` and `rbind` were used to join all data. As a result, 10,299 rows with 563 variables (activity+subject+561 features)
* `featuresFiltered` - feautures that contains std() and mean() text, in order to subset data required in the assignment. As result, a vector with 66 elements
* `featuresFiltered <- gsub('\\(|\\)|\\-','.',featuresFiltered$description)` -  Transformation that replaces parentheses by periods . in order to match with allData data frame.
* `columnsRequired` - 66 vector plus subject and activity element
* `allMeanStd <- allData[,columnsRequired]` - subsetting columns, in order to get just mean and std information
* `allMeanStdWithLabels <- merge(allMeanStd,activityLabels,by="activity.id")` - Transformation that assign an activit label to activity id
* `allDataMelted <- melt(allMeanStdWithLabels, id.vars=c("activity.id", "activity.description","subject.id"))` - Transformation to create a column with all features by activity and subject
* `allDataMelted$variable = gsub('\\.','',allDataMelted$variable)` - Transformation, replace the . with white space in order to get better features reading
* `allDataMelted$variable = gsub('mean','Mean',allDataMelted$variable)` - Transformation, replace with uppercase the word *mean* in order to get better features reading
* `allDataMelted$variable = gsub('std','Std',allDataMelted$variable)` - Transformation, replace with uppercase the word *std* in order to get better features reading
* `allDataMelted[substring(allDataMelted$variable,1,1) == "t",c("variable")] <- 
        paste("time",substring(allDataMelted[substring(allDataMelted$variable,1,1) == "t",c("variable")],2),sep="")` - Transformation, replace the initial *t* with the word *time*, for better features reading
* `allDataMelted[substring(allDataMelted$variable,1,1) == "f",c("variable")] <- 
        paste("fastFourier",substring(allDataMelted[substring(allDataMelted$variable,1,1) == "f",c("variable")],2),sep="")` - Transformation, replace the initial *w* with the word *fastFourier*, for better features reading
* `allDataMelted$subject.description <- paste("subject",allDataMelted$subject.id)` - Transformation that creates a better label for subjects id, e.g. *subject 1* instead of 1 number
* `finalData <- dcast(data = allDataMelted, activity.id + activity.description + subject.id + subject.description ~ variable, fun = mean)` - Transformation that creates a new variable with average information for each subject and activiry









