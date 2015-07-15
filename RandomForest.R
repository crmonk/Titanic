#RandomForest Data Cleaning


#create all_data
survTest <- data.frame(matrix(data = NA, nrow = 418, ncol = 1, dimnames = list(NULL,c("Survived"))))
ttest  <- data.frame(c(test,survTest))
survTest <- 0

# All data, both training and test set
all_data <- rbind(train, ttest)
ttest <- 0
str(all_data)

#identify columns with na
temp <- data.frame(!is.na(all_data))
naByCol <- apply(data.frame(temp),2, function(x) prod(x))
naByCol

#identify rows with ""
blank <- apply(all_data, 1, function(x) "")
isBlank <- all_data == blank
blankResult <- apply(isBlank, 2, function(x) sum(x[!is.na(x)]))
blankResult

#Show which passengers have NA Age
all_data$PassengerId[is.na(all_data$Age )]

#Show which passengers have NA Fare
all_data$PassengerId[is.na(all_data$Fare )]

#Show which passengers have blank place of embarkment
all_data$PassengerId[all_data$Embarked == ""]

# Passenger on row 62 and 830 do not have a value for embarkment. 
# Since many passengers embarked at Southampton, we give them the value S.
# We code all embarkment codes as factors.
all_data$Embarked[c(62,830,953)] = "S"
all_data$Embarked <- factor(all_data$Embarked)

train$Embarked = all_data$Embarked[c(62,830,953)] = "S"


# Passenger on row 1044 has an NA Fare value. Let's replace it with the median fare value.
all_data$Fare[1044] <- median(all_data$Fare, na.rm=TRUE)

#Missing Title and family_size variables
#all_data$Last_name <- apply (data.frame(all_data$Name), 1, function(x) strsplit(x, "[,]")[[1]][1])
all_data$Title <- apply (data.frame(all_data$Name), 1, function(x) {strsplit(x, "[.,]")[[1]][2]} )
all_data$Title <- sub(' ', '', all_data$Title)

all_data$TitleGrp <- all_data$Title
all_data$TitleGrp[all_data$TitleGrp %in% c('Master', 'Miss', 'Mlle','Mme', 'Mr', 'Mrs','Ms')] <- 'Basic'
all_data$TitleGrp[all_data$TitleGrp %in% c('Capt', 'Col', 'Dr','Don','Dona', 'Jonkheer','Lady','Major', 'Rev', 'Sir','the Countess')] <- 'Noble'

all_data$Title <- factor(all_data$Title)
all_data$TitleGrp <- factor(all_data$TitleGrp)

all_data$family_size <- all_data$SibSp + all_data$Parch
all_data$Surname <- sapply(all_data$Name, FUN=function(x) {strsplit(x, split='[,.]')[[1]][1]})
all_data$FamilyID <- sapply(all_data$Name, FUN=function(x) {strsplit(x, split='[,.]')[[1]][1]})


combi$FamilySize <- combi$SibSp + combi$Parch + 1

# How to fill in missing Age values?
# We make a prediction of a passengers Age using the other variables and a decision tree model. 
# This time you give method="anova" since you are predicting a continuous variable.
predicted_age <- rpart(Age ~ Pclass + Sex + SibSp + Parch + Fare + Embarked + Title + TitleGrp + family_size, data=all_data[!is.na(all_data$Age),], method="anova")
all_data$Age[is.na(all_data$Age)] <- predict(predicted_age, all_data[is.na(all_data$Age),])

# Split the data back into a train set and a test set
train <- all_data[1:891,]
test <- all_data[892:1309,]

## The RandomForest Model

# Load in the package
#install.packages("randomForest")
library(randomForest)

# train and test are available in the workspace
#str(train)
#str(test)

# Set seed for reproducibility
set.seed(111)

# Apply the Random Forest Algorithm 
my_forest <- randomForest(formula = as.factor(Survived) ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked + Title, data = train, type = classification, importance = TRUE)

# Make your prediction using the test set
my_prediction <- predict(my_forest, test)

# Create a data frame with two columns: PassengerId & Survived. Survived contains your predictions
my_solution <- data.frame(PassengerId = test$PassengerId, Survived = my_prediction)

# Write your solution away to a csv file with the name my_solution.csv
write.csv(my_solution,file ="my_solution.csv", row.names = FALSE)

#Remember you set importance=TRUE? Now you can see what variables are important using:
varImpPlot(my_forest)
#When running the function, two graphs appear: 

#the accuracy plot shows how much worst the model would perform without the included variables. 
#So a high decrease (= high value x-axis) links to a high predictive variable. 

#The second plot is the Gini coefficient. The higher the variable scores here, 
#the more important it is for the model.


