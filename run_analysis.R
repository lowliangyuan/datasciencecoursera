# Need to load dply library.

# Read feature list and activity names.
features_list <- read.table("UCI HAR Dataset/features.txt", col.names = c("sn","features"))
activity <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("label", "activities"))

# Read test data.
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt",col.names = features_list$features)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "label")
y_test_label<-join(y_test,activity)

test_data<-cbind(subject_test,y_test_label,x_test)
test_data<-select(test_data,-label)

# Read train data.
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features_list$features)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "label")
y_train_label <- join(y_train, activity)

train_data <- cbind(subject_train, y_train_label, x_train)
train_data <- select(train_data, -label)

# Combine test and train data set.
full_data <- rbind(test_data, train_data)

# Subsetting mean and standard deviation
full_data_mean_std <- select(full_data,c(subject,activities), contains("mean"), contains("std"))

# Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
full_data_mean_std$subject<-as.factor(full_data_mean_std$subject)

ave_data <- full_data_mean_std %>%
    group_by(subject, activities)%>%
    summarize_all(funs(mean))