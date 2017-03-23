#Install and add to the library(reshape2)
library(reshape2)

#Load file into R
zip_location <- ("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip")

data.file <- "getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(zip_location, destfile = data.file, method = "curl")

#Unzip the file
unzip(data.file)

#Assign unzip directory to variable
Data_dir <- "UCI HAR Dataset"


#1. Merge the test data sets to create one data set
#First, read the activity_label and y_test.txt files. 
#Create vectors column names. 
activities_set <- read.table(file = paste(Data_dir, "activity_labels.txt", sep = "/"), col.names = c("Activity.ID", "Activity.Name") )
y_testset <- read.table(file = paste(Data_dir, "test", "y_test.txt", sep = "/"), col.names = c("Activity.ID"))
activities_testset <- merge(activities_set, y_testset, by.x="Activity.ID", by.y="Activity.ID", all = TRUE)
Activity <- activities_testset[,2]

#Create vectors of feature names.
# Columns names will be applied to the data.
features_set1 <- read.table(file = paste(Data_dir, "features.txt", sep = "/"),col.names = c("Feature.Number", "Feature.Name") )
features <- features_set1[,2]

#Read the subject file. 
#Create a vector for column name.
subject_test <- read.table(file = paste(Data_dir, "test", "subject_test.txt", sep = "/"), col.names = c("Subject.Name"))

#Read the test file
#Create a vector for the column name.
x_testset <- read.table(file = paste(Data_dir, "test", "X_test.txt", sep = "/"), col.names = features)

#Merge the dataframes into one.
test_df  <- cbind(subject_test, Activity,  x_testset)

#2. Merge the train data sets to create one data set
#First, read the  y_train.txt files. 
#Create vectors column names. 
y_trainset <- read.table(file = paste(Data_dir, "train", "y_train.txt", sep = "/"), col.names = c("Activity.ID"))

activities_testset2  <- merge(activities_set, y_trainset,  by.x="Activity.ID", by.y="Activity.ID")

Activity      <- activities_testset2 [,2]

#Read the subject file. 
#Create a vector for column name.
subject_train <- read.table(file = paste(Data_dir, "train", "subject_train.txt", sep = "/"), col.names = c("Subject.Name"))

#Read the test file
#Create a vector for the column name.
x_train <- read.table(file = paste(Data_dir, "train", "X_train.txt", sep = "/"), col.names = features)

#Merge the dataframes into one.
train_df  <- cbind(subject_train, Activity, x_train)

# Combine Test & Train data 

data <- rbind(test_df, train_df)

# Keep only the columns that are mean and standard deviation

# Use grep to find the column names that are mean and std

data_mean_std <- data[,c("Subject.Name",
                         
                         "Activity",
                         
                         grep("mean|std", colnames(data), value=TRUE))
                      
                      ]

# melt the data by subject/activity

sub__data  <- melt(data_mean_std, id.vars=c("Subject.Name","Activity"))



# cast the data by subject/activity and calculate the average of the variables

tidy_data <- dcast(sub_data, Subject.Name +  Activity ~ variables , mean)



# write the tidy_data to a file

write.table(tidy_data, row.name=FALSE, file = "tidy_data.txt")



# Output just the column names of tidy_data for CodeBook.md

# cat(names(tidy_data), sep="\n")


