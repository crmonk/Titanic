source("RandomForest.R")

#Knowledge based on family ID and cabin
multiCab <- all_data[duplicated(all_data$Cabin),]
multiCab <- multiCab[!is.na(multiCab$Cabin),]

train <- all_data[1:891,]
cabTrain <- merge(train, multiCab)

test <- all_data[892:1309,]
totalCabTest <- merge(test, multiCab)
cabTest <- cabTest[cabTest$Cabin %in% cabTrain$Cabin,]

cabTrain$Survived <- factor(cabTrain$Survived)
cabinLM <- glm(Survived ~ Cabin, data = cabTrain, family = "binomial")
cabPredict <- predict(cabinLM,cabTest)
cabPredict <- predict(cabinLM,cabTest, type="response")


all_data$FamilyID <- paste(as.character(all_data$FamilySize), all_data$Surname, sep="")

famTrain <- all_data[duplicated(all_data$FamilyID)],]

str(cabinLM)
