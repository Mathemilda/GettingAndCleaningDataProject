#setwd("/U1/accounts/mayab/R_CODE/UCI_HAR_Dataset")
#setwd("C:/Users/Owner/RCode/UCI HAR Dataset/")

unzip("getdata-projectfiles-UCI HAR Dataset.zip")
setwd("UCI HAR Dataset")
#
#Read data with subject numbers, 
train_subject <-read.table("./train/subject_train.txt")
test_subject <-read.table("./test/subject_test.txt")
#bind them together 
train_subject <-read.table("./train/subject_train.txt")
#and make a vector of subject numbers
subject=rbind(train_subject,test_subject)[,1]
#
# Read activity labels, it is 2x6 table
activity_labels=read.table("activity_labels.txt")
# now read  files where activities are coded by numbers.
activity_train<-read.table("./train/y_train.txt")
activity_test<-read.table("./test/y_test.txt")
# binding them together
activity_num=rbind(activity_train, activity_test)
# Now we need to replace numbers in the activity number list by 
# activity labels.
nu=dim(activity_num)[1]
activity=rep("act", nu)

for ( i in 1:nu ) {
    activity[i]=as.character(activity_labels[activity_num[i,1],2])
}
# Next step is to read numeric values and measurement names
test<-read.table("./test/X_test.txt")
train<-read.table("./train/X_train.txt")
features=read.table("features.txt")
#and glue them together in right order,
rawdata=rbind(train, test)
# giving the right names to columns
names(rawdata)=features[ ,2]
# Everything is ready to form original data set:
original=cbind(subject, activity, rawdata)
oldnames=names(original)
#
#Step 2
#
library(reshape)
# At first I will split data with 
oldnames=names(original)
meannames=grep("mean", oldnames, value=TRUE)
stdnames= grep("std", oldnames, value=TRUE)
meandata=original[ , c("subject", "activity", meannames)]
stddata=original[ ,c("subject", "activity", stdnames)]
#Then we melt them into narrow data sets.
meanmelt = melt(meandata, id=c("subject", "activity"), measure.var=meannames)

sum( oldnames=="tBodyAcc-mean()-X")