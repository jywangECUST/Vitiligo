# For Vitiligo
# Machine learning-based feature selection
# Random Forest
# Writed by jywang, LMMD, ECUST
# 2020.09.08
# 2020.09.14
# 2021.01.08

rm(list = ls())

timestart <- Sys.time()
print(timestart)

# Load data
setwd("/home/jywang/Feature_Selection/Vitiligo/Binary-Class")

load(file = "Vitiligo_exprSet.RData")
Vitiligo_exprSet <- exprSet
remove(exprSet)

library(randomForest)
library(varSelRF)
library(caret)
library(pROC)
library(plyr)

# Setting seed
if (TRUE) {
  set.seed(1234)
}

# Split training_set and testing_set
if (TRUE){
  training <- createDataPartition(y = Vitiligo_exprSet$Sample_Type, p = 0.8, list = FALSE) # p = percent
  training_set <- Vitiligo_exprSet[training, ]
  testing_set <- Vitiligo_exprSet[-training, ]
}
table(Vitiligo_exprSet$Sample_Type)
table(training_set$Sample_Type)
table(testing_set$Sample_Type)

# Build model: Random Forest
# Training
if (TRUE) {
  rf_train <- randomForest(as.factor(training_set$Sample_Type) ~ ., 
                           data = training_set, 
                           ntree = 500,
                           nodesize = 1, 
                           importance = TRUE, 
                           proximity = TRUE)
  print(rf_train)
}

# Prediction
if (TRUE){
  rf_pred <- predict(rf_train, newdata = testing_set, type = 'prob')
  rf_pred <- as.data.frame(rf_pred)
  rf_pred$Sample_Type <- testing_set$Sample_Type
  write.csv(rf_pred, file = "rf_pred.csv", row.names = TRUE, quote = FALSE)
  # Plotting AUROC
  roc <- roc(testing_set$Sample_Type, as.numeric(rf_pred$Vitiligo))
  pdf("AUROC_test.pdf")
  plot(roc, print.auc = TRUE, auc.polygon = TRUE, grid = c(0.1, 0.2), grid.color = c("green", "red"), max.auc.polygon = TRUE, auc.polygon.color = "skyblue", print.thres = TRUE)
  dev.off()
}

# Feature selection
# R package: randomForestExplainer
if (TRUE) {
  importance <- as.data.frame(importance(rf_train), type = 1) # type = 1 Mean Decrease Accuracy method
  write.csv(importance, file = "rf_train_importance.csv", row.names = TRUE, quote = FALSE)
}

# 10 fold Cross validation
# Repeated 100 times for final best RF_model
# Model robustness
if (TRUE){
  predictions1 <- matrix(0, nrow=dim(training_set)[1], ncol = 2)
  rownames(predictions1) <- rownames(training_set)
  for(i in 1:100){
    print(i)
    folds <- createFolds(training_set$Sample_Type, 10)
    for(fold in folds){
      valids <- training_set[fold,]
      trains <- training_set[setdiff(1:dim(training_set)[1],fold),]
      trains$Sample_Type <- as.factor(trains$Sample_Type)
      set.seed(1234)
      tmpRF <- randomForest(Sample_Type ~ . ,
                            data = trains, 
                            importance = TRUE, 
                            ntree = 500, 
                            nodesize = 1)
      predicted <- predict(tmpRF, valids, type = 'prob')
      predictions1[rownames(predicted),] <- predictions1[rownames(predicted),]+predicted
    }
  }
  colnames(predictions1) <- colnames(predicted)
  predicts <- t(apply(predictions1, 1, function(v){v/sum(v)}))
  colnames(predicts) <- colnames(predicted)
  predicts <- as.data.frame(predicts, check.names = FALSE)
  predicts$predicted <- apply(predicts, 1, function(v){names(v)[max(v)==v]})
  predicts$observed <- training_set$Sample_Type
  write.csv(predicts, file = "cv_predicts.csv")
  ROC <- roc(predicts$observed, as.numeric(predicts$Vitiligo))
  pdf("RF_model_ROC.pdf")
  plot.roc(ROC, print.auc=TRUE, col = "blue3", ylim=c(0,1), print.thres="best",	
           main="RF_model_ROC",legacy.axes = TRUE, print.auc.cex = 1.2)
  dev.off()
}

timeend <- Sys.time()
runningtime <- timeend-timestart
print(runningtime)
# Ending