---
title: "Code book for Week 3 Project"
author: "Richard Scranton"
date: "02/20/2015"
output: html_document
---


Description of Tidy Data Set
----------------------------

Each raw measurement is taken from the embedded accelerometers and gyroscopes of Samsung "smart phones." With a constant measurement period of 50 milliseconds standardized around "g", the gravitational constant, and constrained to +/- 1, the measurement domain for all 66 measurements can be said to encompass approximately 1/10th of a Newton.  More specifics of the measurement regime can be read in the data set description accompanying the raw data at:

[https://d396qusza40orc.cloudfront.net/getdata/projectfiles/UCI HAj Dataset.zip]

Rationalized Data Naming
------------------------

rational | original
--------|--------------
subject | NA
activity | NA
AverageTimeBodyAccelMeanX | tBodyAcc-mean()-X
AverageTimeBodyAccelMeanY | tBodyAcc-mean()-Y
AverageTimeBodyAccelMeanZ | tBodyAcc-mean()-Z
AverageTimeBodyAccelStddevX | tBodyAcc-std()-X
AverageTimeBodyAccelStddevY | tBodyAcc-std()-Y
AverageTimeBodyAccelStddevZ | tBodyAcc-std()-Z
AverageTimeGravityAccelMeanX | tGravityAcc-mean()-X
AverageTimeGravityAccelMeanZ | tGravityAcc-mean()-Y
AverageTimeGravityAccelMeanY | tGravityAcc-mean()-Z
AverageTimeGravityAccelStddevX | tGravityAcc-std()-X
AverageTimeGravityAccelStddevY | tGravityAcc-std()-Y
AverageTimeGravityAccelStddevZ | tGravityAcc-std()-Z
AverageTimeBodyAccelJerkMeanX | tBodyAccJerk-mean()-X
AverageTimeBodyAccelJerkMeanY | tBodyAccJerk-mean()-Y
AverageTimeBodyAccelJerkMeanZ | tBodyAccJerk-mean()-Z
AverageTimeBodyAccelJerkStddevX | tBodyAccJerk-std()-X
AverageTimeBodyAccelJerkStddevY | tBodyAccJerk-std()-Y
AverageTimeBodyAccelJerkStddevZ | tBodyAccJerk-std()-Z
AverageTimeBodyGyroMeanX | tBodyGyro-mean()-X
AverageTimeBodyGyroMeanY | tBodyGyro-mean()-Y
AverageTimeBodyGyroMeanZ | tBodyGyro-mean()-Z
AverageTimeBodyGyroStddevX | tBodyGyro-std()-X
AverageTimeBodyGyroStddevY | tBodyGyro-std()-Y
AverageTimeBodyGyroStddevZ | tBodyGyro-std()-Z
AverageTimeBodyGyroJerkMeanX | tBodyGyroJerk-mean()-X
AverageTimeBodyGyroJerkMeanY | tBodyGyroJerk-mean()-Y
AverageTimeBodyGyroJerkMeanZ | tBodyGyroJerk-mean()-Z
AverageTimeBodyGyroJerkStddevX | tBodyGyroJerk-std()-X
AverageTimeBodyGyroJerkStddevY | tBodyGyroJerk-std()-Y
AverageTimeBodyGyroJerkStddevZ | tBodyGyroJerk-std()-Z
AverageTimeBodyAccelMagMean | tBodyAccMag-mean()
AverageTimeBodyAccelMagStddev | tBodyAccMag-std()
AverageTimeGravityAccelMagMean | tGravityAccMag-mean()
AverageTimeGravityAccelMagStddev | tGravityAccMag-std()
AverageTimeBodyAccelJerkMagMean | tBodyAccJerkMag-mean()
AverageTimeBodyAccelJerkMagStddev | tBodyAccJerkMag-std()
AverageTimeBodyGyroMagMean | tBodyGyroMag-mean()
AverageTimeBodyGyroMagStddev | tBodyGyroMag-std()
AverageTimeBodyGyroJerkMagMean | tBodyGyroJerkMag-mean()
AverageTimeBodyGyroJerkMagStddev | tBodyGyroJerkMag-std()
AverageTimeBodyAccelMeanX | fBodyAcc-mean()-X
AverageFreqBodyAccelMeanY | fBodyAcc-mean()-Y
AverageFreqBodyAccelMeanZ | fBodyAcc-mean()-Z
AverageFreqBodyAccelStddevX | fBodyAcc-std()-X
AverageFreqBodyAccelStddevY | fBodyAcc-std()-Y
AverageFreqBodyAccelStddevZ | fBodyAcc-std()-Z
AverageFreqBodyAccelJerkMeanX | fBodyAccJerk-mean()-X
AverageFreqBodyAccelJerkMeanY | fBodyAccJerk-mean()-Y
AverageFreqBodyAccelJerkMeanZ | fBodyAccJerk-mean()-Z
AverageFreqBodyAccelJerkStddevX | fBodyAccJerk-std()-X
AverageFreqBodyAccelJerkStddevY | fBodyAccJerk-std()-Y
AverageFreqBodyAccelJerkStddevZ | fBodyAccJerk-std()-Z
AverageFreqBodyGyroMeanX | fBodyGyro-mean()-X
AverageFreqBodyGyroMeanY | fBodyGyro-mean()-Y
AverageFreqBodyGyroMeanZ | fBodyGyro-mean()-Z
AverageFreqBodyGyroStddevX | fBodyGyro-std()-X
AverageFreqBodyGyroStddevY | fBodyGyro-std()-Y
AverageFreqBodyGyroStddevZ | fBodyGyro-std()-Z
AverageFreqBodyAccelMagMean | fBodyAccMag-mean()
AverageFreqBodyAccelMagStddev | fBodyAccMag-std()
AverageFreqBodyAccelJerkMagMean[1] | fBodyBodyAccJerkMag-meanFreq()
AverageFreqBodyAccelJerkMagStddev[1] | fBodyBodyAccJerkMag-std()
AverageFreqBodyGyroMagMean[1] | fBodyBodyGyroMag-mean()
AverageFreqBodyGyroMagStddev[1] | fBodyBodyGyroMag-std()
AverageFreqBodyGyroJerkMagMean[1] | fBodyBodyAccJerkMag-mean()
AverageFreqBodyGyroJerkMagStddev[1] | fBodyBodyGyroJerkMag-std()

[1] fBodyBodyAccJerkMagmean and fBodyBodyAccJerkMagstd, fBodyBodyBodyGyroMagmean and fBodyBodyGyroMagstd, fBodyBodyGyroMagmean and fBodyBodyGyroMagstd were spelled "BodyBody" in the source data.  This has been corrected in the tidied output.

   
How the Data was Summarized
---------------------------

After being grouped by test subject (major) and activity (minor) order, observations that had already been summarized to mean() and std-dev() values for each of the 6 activities were extracted (the supplied raw inertial sensor observations were not used) and a mean() was calculated across for 6 activities, for each of the 66 collected data points, for each test subject.


Information about the Experimental Study Design
-----------------------------------------------

Data used here is the result of a previous study, and has already been partially processed.  Some details of the original researchers' study may be gleaned from information included in the data set mentioned above, but part of the study goal was to validate the use of commodity mobile phone hardware as a viable source of experimental data.


Processing from Raw to Tidy Data
--------------------------------

Raw data was distributed divided into training data and test data.  Training and Test data subsets were merged prior to other processing.   The whole was then written to a work object for further consideration.

Test and Training identity markers for the subjects was then merged, taking care to preserve overall ordering.  Test and Training data for activities was then merged, and subject/activity combined to produce an index.

Mean() and Std-dev() observations were excerpted from the whole and written to another work object.  Original obscure column descriptions were augmented using hints included with the raw data to make them more intuitively descriptive.  Activity ordinals were replaced with textual descriptions, also using information included with the source data.

The completed extract was written to disk for distribution, and any remaining memory-resident work objects were released.  The scripted processing can be repeated by bursting the .ZIP archive on disk, allowing it to create nested directories as required.  Then place the R script "run_analysis.R" in the top directory of the .ZIP hierarchy.  Execute the R script to create the extract file, **X_mean_std_avg.txt.**

```{r}
str(X_mean_std_avg)
```

*Original data compiled and kindly donated by Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012*

`$Id: MyStinkingCodebook.Rmd,v 1.4 2015/02/22 04:03:23 richard Exp richard $`
