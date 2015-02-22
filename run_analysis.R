# $Id: run_analysis.R,v 1.12 2015/02/22 00:10:23 richard Exp richard $

require(sqldf)

#  1) Merges the training and the test sets to create one data set.
#  2) Extracts only the measurements on the mean and standard deviation
#     for each measurement.
#  3) Uses descriptive activity names to name the activities in the data set
#  4) Appropriately labels the data set with descriptive variable names.
#  5) From the data set in step 4, creates a second, independent tidy data set
#     with the average of each variable for each activity and each subject.

# run_analysis.R

	blab <- function(errlevel, msg) {
		if(bitops::bitAnd(errlevel, verbose))
			print(sprintf("blab(0x%x) %s", errlevel, msg))
	}

	testing <- FALSE

	verbose <- 0
	verbose <- bitops::bitOr(verbose, 0x01)      #  informational (loading)
	verbose <- bitops::bitOr(verbose, 0x02)      #  informational (manipulating)
	verbose <- bitops::bitOr(verbose, 0x04)      #  informational (writing)
	verbose <- bitops::bitOr(verbose, 0x08)      #  informational (deleting)
#	verbose <- bitops::bitOr(verbose, 0x10)      #  unused
#	verbose <- bitops::bitOr(verbose, 0x20)      #  subject test
#	verbose <- bitops::bitOr(verbose, 0x40)      #  X test
#	verbose <- bitops::bitOr(verbose, 0x80)      #  y test
#	verbose <- bitops::bitOr(verbose, 0x0100)    #  subject train
#	verbose <- bitops::bitOr(verbose, 0x0200)    #  X train
#	verbose <- bitops::bitOr(verbose, 0x0400)    #  y train
#	verbose <- bitops::bitOr(verbose, 0x0800)    #  features labels
#	verbose <- bitops::bitOr(verbose, 0x1000)    #  activities labels
#	verbose <- bitops::bitOr(verbose, 0x2000)    #  subject frames
#	verbose <- bitops::bitOr(verbose, 0x4000)    #  X frames
#	verbose <- bitops::bitOr(verbose, 0x8000)    #  y frames
#	verbose <- bitops::bitOr(verbose, 0x010000)  #  features dictionary, selected
#	verbose <- bitops::bitOr(verbose, 0x020000)  #  unused
#	verbose <- bitops::bitOr(verbose, 0x040000)  #  labelled and reduced data set

	blab(0x01, "loading subject_test")
	subject_test <- read.table("UCI\ HAR\ Dataset/test/subject_test.txt", header=FALSE)
	blab(0x20, subject_test)

	blab(0x01, "loading X_test")
	X_test <- read.table("UCI\ HAR\ Dataset/test/X_test.txt", header=FALSE)
	blab(0x40, X_test)

	blab(0x01, "loading y_test")
	y_test <- read.table("UCI\ HAR\ Dataset/test/y_test.txt", header=FALSE)
	blab(0x80, y_test)

	blab(0x01, "loading subject_train")
	subject_train <- read.table("UCI\ HAR\ Dataset/train/subject_train.txt", header=FALSE)
	blab(0x0100, subject_train)

	blab(0x01, "loading X_train")
	X_train <- read.table("UCI\ HAR\ Dataset/train/X_train.txt", header=FALSE)
	blab(0x0200, X_train)

	blab(0x01, "loading y_train")
	y_train <- read.table("UCI\ HAR\ Dataset/train/y_train.txt", header=FALSE)
	blab(0x0400, y_train)

	blab(0x01, "loading feature dictionary")
	features <- read.table("UCI\ HAR\ Dataset/features.txt", header=FALSE)

	blab(0x02, "select mean() and stddev() data of interest")
	interestvec <- vector()
	interestvec <- grep("-mean\\(|-std\\(", features[,2], ignore.case=FALSE)
	ofinterest  <- features[interestvec, ]
	blab(0x010000, ofinterest)

	blab(0x02, "making column labels more conventionally acceptable")
	ofinterest[ ,2] <- gsub("\\(\\)", "",    ofinterest[ ,2])
	ofinterest[ ,2] <- gsub("\\(",    "of",  ofinterest[ ,2])
	ofinterest[ ,2] <- gsub("\\)",    "",    ofinterest[ ,2])
	ofinterest[ ,2] <- gsub(",",      "and", ofinterest[ ,2])
	ofinterest[ ,2] <- gsub("-|_",    "",    ofinterest[ ,2])
	blab(0x0800, ofinterest)

	blab(0x01, "loading activity labels")
	activity <- read.table("UCI\ HAR\ Dataset/activity_labels.txt", header=FALSE)
	activity[ ,2] <- tolower(activity[ ,2])
	blab(0x1000, activity)

	blab(0x01, "combining subject frames")
	subject_combined <- rbind(subject_test, subject_train)
	blab(0x2000, subject_combined)

	blab(0x01, "combining X frames")
	X_combined <- rbind(X_test, X_train)
	blab(0x4000, X_combined)

	blab(0x01, "combining y frames")
	y_combined <- rbind(y_test, y_train)
	blab(0x8000, y_combined)

	if(!testing) {
		blab(0x08, "releasing *_test and *_train objects")
		rm(subject_test,  X_test,  y_test)
		rm(subject_train, X_train, y_train)
	}

	blab(0x02, "combining activity and subject indices with reduced data set")
	subj.actv  <- cbind(subject_combined, y_combined)
	X_mean_std <- data.frame()
	X_mean_std <- subset(X_combined[ ,ofinterest[ ,1]])
	X_mean_std <- cbind(subj.actv, X_mean_std)

	blab(0x02, "give the reduced dataset meaningful, unique column names")
	colnames(X_mean_std) <- c("subject", "activity", as.character(ofinterest[ ,2]))

	blab(0x02, "replace activity indices with human readable descriptions")
	X_mean_std$activity <- activity[X_mean_std$activity, 2]
	blab(0x40000, X_mean_std)

	blab(0x02, "populate subject+activity means extract")
	X_mean_std_avg <- sqldf(
		"SELECT
			subject,
			activity,
			AVG(tBodyAccmeanX)            AS AverageTimeBodyAccelMeanX,
			AVG(tBodyAccmeanY)            AS AverageTimeBodyAccelMeanY,
			AVG(tBodyAccmeanZ)            AS AverageTimeBodyAccelMeanZ,
			AVG(tBodyAccstdX)             AS AverageTimeBodyAccelStddevX,
			AVG(tBodyAccstdY)             AS AverageTimeBodyAccelStddevY,
			AVG(tBodyAccstdZ)             AS AverageTimeBodyAccelStddevZ,
			AVG(tGravityAccmeanX)         AS AverageTimeGravityAccelMeanX,
			AVG(tGravityAccmeanY)         AS AverageTimeGravityAccelMeanY,
			AVG(tGravityAccmeanZ)         AS AverageTimeGravityAccelMeanZ,
			AVG(tGravityAccstdX)          AS AverageTimeGravityAccelStddevX,
			AVG(tGravityAccstdY)          AS AverageTimeGravityAccelStddevY,
			AVG(tGravityAccstdZ)          AS AverageTimeGravityAccelStddevZ,
			AVG(tBodyAccJerkmeanX)        AS AverageTimeBodyAccelJerkMeanX,
			AVG(tBodyAccJerkmeanY)        AS AverageTimeBodyAccelJerkMeanY,
			AVG(tBodyAccJerkmeanZ)        AS AverageTimeBodyAccelJerkMeanZ,
			AVG(tBodyAccJerkstdX)         AS AverageTimeBodyAccelJerkStddevX,
			AVG(tBodyAccJerkstdY)         AS AverageTimeBodyAccelJerkStddevY,
			AVG(tBodyAccJerkstdZ)         AS AverageTimeBodyAccelJerkStddevZ,
			AVG(tBodyGyromeanX)           AS AverageTimeBodyGyroMeanX,
			AVG(tBodyGyromeanY)           AS AverageTimeBodyGyroMeanY,
			AVG(tBodyGyromeanZ)           AS AverageTimeBodyGyroMeanZ,
			AVG(tBodyGyrostdX)            AS AverageTimeBodyGyroStddevX,
			AVG(tBodyGyrostdY)            AS AverageTimeBodyGyroStddevY,
			AVG(tBodyGyrostdZ)            AS AverageTimeBodyGyroStddevZ,
			AVG(tBodyGyroJerkmeanX)       AS AverageTimeBodyGyroJerkMeanX,
			AVG(tBodyGyroJerkmeanY)       AS AverageTimeBodyGyroJerkMeanY,
			AVG(tBodyGyroJerkmeanZ)       AS AverageTimeBodyGyroJerkMeanZ,
			AVG(tBodyGyroJerkstdX)        AS AverageTimeBodyGyroJerkStddevX,
			AVG(tBodyGyroJerkstdY)        AS AverageTimeBodyGyroJerkStddevY,
			AVG(tBodyGyroJerkstdZ)        AS AverageTimeBodyGyroJerkStddevZ,
			AVG(tBodyAccMagmean)          AS AverageTimeBodyAccelMagMean,
			AVG(tBodyAccMagstd)           AS AverageTimeBodyAccelMagStddev,
			AVG(tGravityAccMagmean)       AS AverageTimeGravityAccelMagMean,
			AVG(tGravityAccMagstd)        AS AverageTimeGravityAccelMagStddev,
			AVG(tBodyAccJerkMagmean)      AS AverageTimeBodyAccelJerkMagMean,
			AVG(tBodyAccJerkMagstd)       AS AverageTimeBodyAccelJerkMagStddev,
			AVG(tBodyGyroMagmean)         AS AverageTimeBodyGyroMagMean,
			AVG(tBodyGyroMagstd)          AS AverageTimeBodyGyroMagStddev,
			AVG(tBodyGyroJerkMagmean)     AS AverageTimeBodyGyroJerkMagMean,
			AVG(tBodyGyroJerkMagstd)      AS AverageTimeBodyGyroJerkMagStddev,
			AVG(fBodyAccmeanX)            AS AverageTimeBodyAccelMeanX,
			AVG(fBodyAccmeanY)            AS AverageFreqBodyAccelMeanY,
			AVG(fBodyAccmeanZ)            AS AverageFreqBodyAccelMeanZ,
			AVG(fBodyAccstdX)             AS AverageFreqBodyAccelStddevX,
			AVG(fBodyAccstdY)             AS AverageFreqBodyAccelStddevY,
			AVG(fBodyAccstdZ)             AS AverageFreqBodyAccelStddevZ,
			AVG(fBodyAccJerkmeanX)        AS AverageFreqBodyAccelJerkMeanX,
			AVG(fBodyAccJerkmeanY)        AS AverageFreqBodyAccelJerkMeanY,
			AVG(fBodyAccJerkmeanZ)        AS AverageFreqBodyAccelJerkMeanZ,
			AVG(fBodyAccJerkstdX)         AS AverageFreqBodyAccelJerkStddevX,
			AVG(fBodyAccJerkstdY)         AS AverageFreqBodyAccelJerkStddevY,
			AVG(fBodyAccJerkstdZ)         AS AverageFreqBodyAccelJerkStddevZ,
			AVG(fBodyGyromeanX)           AS AverageFreqBodyGyroMeanX,
			AVG(fBodyGyromeanY)           AS AverageFreqBodyGyroMeanY,
			AVG(fBodyGyromeanZ)           AS AverageFreqBodyGyroMeanZ,
			AVG(fBodyGyrostdX)            AS AverageFreqBodyGyroStddevX,
			AVG(fBodyGyrostdY)            AS AverageFreqBodyGyroStddevY,
			AVG(fBodyGyrostdZ)            AS AverageFreqBodyGyroStddevZ,
			AVG(fBodyAccMagmean)          AS AverageFreqBodyAccelMagMean,
			AVG(fBodyAccMagstd)           AS AverageFreqBodyAccelMagStddev,
			AVG(fBodyBodyAccJerkMagmean)  AS AverageFreqBodyAccelJerkMagMean,
			AVG(fBodyBodyAccJerkMagstd)   AS AverageFreqBodyAccelJerkMagStddev,
			AVG(fBodyBodyGyroMagmean)     AS AverageFreqBodyGyroMagMean,
			AVG(fBodyBodyGyroMagstd)      AS AverageFreqBodyGyroMagStddev,
			AVG(fBodyBodyGyroJerkMagmean) AS AverageFreqBodyGyroJerkMagMean,
			AVG(fBodyBodyGyroJerkMagstd)  AS AverageFreqBodyGyroJerkMagStddev
		FROM
			X_mean_std
		GROUP BY
			subject,
			activity"
	)

	blab(0x04, "Writing the final summarized data set.")
	write.table(X_mean_std_avg, "X_mean_std_avg.txt", row.names=FALSE)

	blab(0x08, "releasing remaining intermediate data sets")
	if(!testing) {
		rm(X_combined, X_mean_std, subject_combined, y_combined)
		rm(activity, features, subj.actv, ofinterest)
	}

# end of run_analysis.R

