source("preprocessing.R")
##install.packages("rpart")
#load the decision tree package
library("rpart")

# Your train and test set are still loaded in
str(train)
str(test)

# Build the decision tree
my_tree_two <- rpart(Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked, data=train, method="class")

# Visualize the decision tree using plot() and text()
plot(my_tree_two)
text(my_tree_two)

# save to png
png(file = "decisionTreeBasic.png",width = 480, height = 480)
  plot(my_tree_two)
  text(my_tree_two)
dev.off()

# Load in the packages to create a fancified version of your tree
#install.packages("rattle")
#install.packages("rpart.plot")
#install.packages("RColorBrewer")

library(rattle)
library(rpart.plot)
library(RColorBrewer)

# Time to plot your fancified tree
fancyRpartPlot(my_tree_two, main ="Titanic Survival Decision Tree")
# save to png
png(file = "decisionTreeFancy.png",width = 480, height = 480)
  fancyRpartPlot(my_tree_two, main ="Titanic Survival Decision Tree")
dev.off()

# Make your prediction using the test set
my_prediction <- predict(object = my_tree_two, newdata = test, type = "class")

# Create a data frame with two columns: PassengerId & Survived. Survived contains your predictions
my_solution <- data.frame(PassengerId = test$PassengerId, Survived = my_prediction)

# Check that your data frame has 418 entries
nrow(my_solution)

# Write your solution to a csv file with the name my_solution.csv
write.csv(x = my_solution, file =  "my_solution.csv", row.names = FALSE)

train_two <- train
train_two$family_size <- train_two$SibSp + train_two$Parch