# Assign the training set
train <- read.csv(url("http://s3.amazonaws.com/assets.datacamp.com/course/Kaggle/train.csv"))

# Assign the testing set
test <- read.csv(url("http://s3.amazonaws.com/assets.datacamp.com/course/Kaggle/test.csv"))

# Make sure to have a look at your training and testing set
#print(train)
#print(test)

# Your train and test set are still loaded in
#str(train)
#str(test)

# Passengers that survived vs passengers that passed away

# absolute numbers
#table(train$Survived)
# percentages
#prop.table(table(train$Survived))


# Males & females that survived vs males & females that passed away

# absolute numbers
#table(train$Sex,train$Survived)
#percentages
#prop.table(table(train$Sex,train$Survived),1)

# Create the column child, and indicate whether child or no child
train$Child[train$Age >= 18] <- 0
train$Child[train$Age < 18] <- 1 

test$Child[test$Age >= 18] <- 0
test$Child[test$Age < 18] <- 1 
# Two-way comparison

# absolute numbers
#table(train$Child,train$Survived)
#percentages
#prop.table(table(train$Child,train$Survived),1)

# prediction based on gender 
test_one <- test
test_one$Survived[test_one$Sex == 'female'] <- 1
test_one$Survived[test_one$Sex == 'male'] <- 0