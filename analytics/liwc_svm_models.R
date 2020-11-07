library(data.table)
library(ggplot2)
library(caret)
library(dplyr)

# Reformating for LIWC use
dt_train = fread("~/Documents/C/Research/data/SemEval2018-Task1-all-data/English/E-c/2018-E-c-En-train.txt")
dt_dev = fread("~/Documents/C/Research/data/SemEval2018-Task1-all-data/English/E-c/2018-E-c-En-dev.txt")
dt_test = fread("~/Documents/C/Research/data/SemEval2018-Task1-all-data/English/E-c/2018-E-c-En-test-gold.txt")

#write.csv(dt_train, '~/Documents/C/Research/data/semEval_train.csv', hea)
#write.csv(dt_dev, '~/Documents/C/Research/data/semEval_dev.csv')
#write.csv(dt_test, '~/Documents/C/Research/data/semEval_test.csv')

# INPUT 
dt_train_liwc = data.table(fread("~/Documents/C/Research/data/LIWC2015_semEval_train.csv"))
dt_dev_liwc = data.table(fread("~/Documents/C/Research/data/LIWC2015_semEval_dev.txt"))
dt_test_liwc = data.table(fread("~/Documents/C/Research/data/LIWC2015_semEval_test.txt"))

names(dt_train_liwc)
names(dt_dev_liwc)
names(dt_test_liwc)

colnames(dt_train_liwc)[1:14] = c('index', names(dt_train)[1:13])
colnames(dt_dev_liwc)[1:14] = c('index', names(dt_train)[1:13])
colnames(dt_test_liwc)[1:14] = c('index', names(dt_train)[1:13])


################################################################
## DEV SVM models 

dt = rbind(dt_train_liwc, dt_dev_liwc, dt_test_liwc)

#sel_names = names(dt)[c(-48, -49)]
#dt = dt[, sel_names, with = F]

# train-test split
set.seed(15213)
train_ix = sample(1:nrow(dt), round(nrow(dt)*0.8))
  
dt_train_svm = dt[train_ix]
dt_test_svm = dt[-train_ix]


liwc_features_name = colnames(dt)[15:length(colnames(dt))]
#liwc_labels_name = colnames(dt)[4:14]
liwc_labels_name = c('anger','joy','sadness','disgust','fear', 'surprise')
# dev model
for(i in 1:length(liwc_labels_name)){
  label_name = liwc_labels_name[i]
  
  print(paste('Developing model for label:', label_name))
  
  tmp_train_data = dt_train_svm[, c(label_name, liwc_features_name), with = F]
  names(tmp_train_data)[1] = 'label'
  
  tmp_test_data = dt_test_svm[, c(label_name, liwc_features_name), with = F]
  names(tmp_test_data)[1] = 'label'
  
  
  # upsample train
  tmp_train_data_pos = tmp_train_data[label==1,]
  tmp_train_data_neg = tmp_train_data[label==0,]
  
  if(nrow(tmp_train_data_pos) <= nrow(tmp_train_data_neg)){
    tmp_train_data_balanced = rbind(tmp_train_data_neg
                                   , tmp_train_data_pos[sample(1:nrow(tmp_train_data_pos), nrow(tmp_train_data_neg), replace = T)]
    )
  }else{
    tmp_train_data_balanced = rbind(tmp_train_data_pos
                                   , tmp_train_data_neg[sample(1:nrow(tmp_train_data_neg), nrow(tmp_train_data_pos), replace = T)]
    )
  }
  # upsample test
  tmp_test_data_pos = tmp_test_data[label==1,]
  tmp_test_data_neg = tmp_test_data[label==0,]
  
  if(nrow(tmp_test_data_pos) <= nrow(tmp_test_data_neg)){
    tmp_test_data_balanced = rbind(tmp_test_data_neg
                                   , tmp_test_data_pos[sample(1:nrow(tmp_test_data_pos), nrow(tmp_test_data_neg), replace = T)]
    )
  }else{
    tmp_test_data_balanced = rbind(tmp_test_data_pos
                                   , tmp_test_data_neg[sample(1:nrow(tmp_test_data_neg), nrow(tmp_test_data_pos), replace = T)]
    )
  }
  
  tmp_train_data_balanced = tmp_train_data_balanced[, setdiff(names(tmp_train_data_balanced), label_name), with = F]
  tmp_test_data_balanced = tmp_test_data_balanced[, setdiff(names(tmp_train_data_balanced), label_name), with = F]
  
  tmp_train_data_balanced[, label := as.factor(label)]
  tmp_test_data_balanced[, label := as.factor(label)]
  
  # Fit the model 
  train_control <- trainControl(method="repeatedcv", number=10, repeats=1)
  svm <- train(label ~., data = tmp_train_data_balanced, method = "svmLinear", trControl = train_control,  preProcess = c("center","scale"))
  #View the model
  svm
  print(svm)
  
  predicts = svm %>% predict(tmp_test_data_balanced)
  truths = tmp_test_data_balanced$label
  
  accuracy = sum(as.double(predicts == truths))/length(predicts)
  print(paste('Accuracy on test set:', accuracy))
  print('\n \n \n \n \n \n')
  saveRDS(svm, paste('liwc_svm__cv10_model_', label_name, sep = ''))
}



