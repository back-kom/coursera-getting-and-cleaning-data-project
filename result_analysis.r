library(plyr)
library(reshape2)
filename <- "getdata_dataset.zip"
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(fileURL, filename, mode="wb",method="libcurl")
}  
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
subject_data <- rbind(subject_train, subject_test)
features <- read.table("features.txt")
mean_and_std_features <- grep("-(mean|std)\\(\\)", features[, 2])
x_data <- x_data[, mean_and_std_features]
names(x_data) <- features[mean_and_std_features, 2]
activities <- read.table("activity_labels.txt")
y_data[, 1] <- activities[y_data[, 1], 2]
names(y_data) <- "activity"
names(subject_data) <- "subject"
all_data <- cbind(x_data, y_data, subject_data)
averages_data <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))
write.table(averages_data, "averages_data.txt", row.name=FALSE)