###This is a script to automatically align all features across sample files (part 1)##
#Jian (Felix) Guo
#2022-12-31
###################################################################
library(dplyr)
#Set directory
directory <- "F:/Jian_Guo/PNNLpythondataproceesing_projects_20221111/Media_csv_Final"
#sample file number
n <- 24

###################################################################
#Read the first two files
setwd(directory)
filename <- list.files(pattern = ".csv")
file1 <- read.csv(filename[1], stringsAsFactors = F)
file2 <- read.csv(filename[2], stringsAsFactors = F)

#Generate csv summarizing all the relavant information for each sample type
summary <- data.frame(matrix(nrow = n, ncol = 7))
colnames(summary) <- c("peaknumber", "percentpeakassigned", "lowestpercent", "highestpercent", 
                       "meanpercent", "stdofpercent", "assignedpeaknumber50%")
summary[1,1] <- nrow(file1)
summary[2,1] <- nrow(file2)

#Align the first two files
file1T <- data.frame(matrix(nrow = 0, ncol = 17))
file1T <- file1[file1$Heteroatom.Class != "unassigned", c(2,3,5,8,9,c(14:21),6,7,10,13)]
file2T <- data.frame(matrix(nrow = 0, ncol = 17))
file2T <- file2[file2$Heteroatom.Class != "unassigned", c(2,3,5,8,9,c(14:21),6,7,10,13)]
colnames(file2T)[14:17] <- c(paste("PeakHeight", 2), paste("ResolvingPower", 2), 
                             paste("mzErrorppm", 2), paste("ConfidenceScore", 2))
summary[1,2] <- nrow(file1T)/nrow(file1)
summary[2,2] <- nrow(file2T)/nrow(file2)
output1 <- data.frame(matrix(nrow = 0, ncol = ncol(file1T) + 4))
colnames(output1) <- c(colnames(file1T), colnames(file2T[c(14:17)]))
for(i in 1:nrow(file1T)){
  temp <- file2T[file2T$Molecular.Formula == file1T$Molecular.Formula[i], ]
  # temp <- temp[complete.cases(temp),]
  if(nrow(temp) > 0) {
    tmprow <- cbind(file1T[i, ], temp[1, c(14:17)])
    colnames(tmprow) <- colnames(output1)
    output1 <- rbind(output1, tmprow)
  }
}

#Find and attach the unique features of the two sample files
unique1_1 <- anti_join(file1T, as.data.frame(output1[1:ncol(file1T)]))
unique1_2 <- anti_join(file2T, as.data.frame(output1[(ncol(file1T)+1):ncol(output1)]))
if (nrow(unique1_1) > 0 & nrow(unique1_2) > 0){
  unique1_1T <- data.frame(matrix(nrow = 0, ncol = ncol(unique1_1)+4))
  unique1_1T <- cbind(unique1_1,0,0,0,0)
  colnames(unique1_1T) <- colnames(output1)
  unique1_2T <- data.frame(matrix(nrow = 0, ncol = ncol(unique1_2)+4))
  unique1_2T <- cbind(unique1_2[, c(1:13)],0,0,0,0,unique1_2[, c(14:17)])
  colnames(unique1_2T) <- colnames(output1)
  AlignTable1 <- data.frame(matrix(nrow = 0, ncol = ncol(output1)))
  AlignTable1 <- rbind(output1, unique1_1T, unique1_2T)
}
if (nrow(unique1_1) > 0 & nrow(unique1_2) == 0) {
  unique1_1T <- data.frame(matrix(nrow = 0, ncol = ncol(unique1_1)+4))
  unique1_1T <- cbind(unique1_1,0,0,0,0)
  colnames(unique1_1T) <- colnames(output1)
  AlignTable1 <- data.frame(matrix(nrow = 0, ncol = ncol(output1)))
  AlignTable1 <- rbind(output1, unique1_1T)
}
if (nrow(unique1_1) == 0 & nrow(unique1_2) > 0) {
  unique1_2T <- data.frame(matrix(nrow = 0, ncol = ncol(unique1_2)+4))
  unique1_2T <- cbind(unique1_2[, c(1:13)],0,0,0,0,unique1_2[, c(14:17)])
  colnames(unique1_2T) <- colnames(output1)
  AlignTable1 <- data.frame(matrix(nrow = 0, ncol = ncol(output)))
  AlignTable1 <- rbind(output, unique_2T)
}

###################################################################
# Feature alignment loop

for(k in 3:n){
  file <- read.csv(filename[k], stringsAsFactors = F)
  if(nrow(file) == 0) next()
  summary[k,1] <- nrow(file)
  fileT <- data.frame(matrix(nrow = 0, ncol = 17))
  fileT <- file[file$Heteroatom.Class != "unassigned", c(2,3,5,8,9,c(14:21),6,7,10,13)]
  colnames(fileT)[c(14:17)] <- c(paste("PeakHeight", k), paste("ResolvingPower", k), 
                                 paste("mzErrorppm", k), paste("ConfidenceScore", k))
  summary[k,2] <- nrow(fileT)/nrow(file)
  output <- data.frame(matrix(nrow = 0, ncol = (ncol(AlignTable1) + 4)))
  colnames(output) <- c(colnames(AlignTable1), colnames(fileT[c(14:17)]))
  for(j in 1:nrow(AlignTable1)){
    temp <- fileT[fileT$Molecular.Formula == AlignTable1$Molecular.Formula[j], ]
    if(nrow(temp) > 0) {
      tmprow <- cbind(AlignTable1[j,], temp[1, c(14:17)])
      colnames(tmprow) <- colnames(output)
      output <- rbind(output, tmprow)
    }
  }
  
  unique_1 <- anti_join(AlignTable1, as.data.frame(output[1:ncol(AlignTable1)]))
  unique_2 <- anti_join(fileT, as.data.frame(output[(ncol(AlignTable1)+1):ncol(output)]))
  if (nrow(unique_1) > 0 & nrow(unique_2) > 0) {
    unique_1T <- data.frame(matrix(nrow = 0, ncol = (ncol(unique_1) + 4)))
    unique_1T <- cbind(unique_1,0,0,0,0)
    colnames(unique_1T) <- colnames(output)
    unique_2T <- data.frame(matrix(nrow = 0, ncol = (ncol(unique_2) + 4)))
    unique_2T <- cbind(unique_2[,c(1:13)], do.call(cbind, replicate((k-1)*4, 0, simplify=FALSE)), 
                       unique_2[,c(14:17)])
    colnames(unique_2T) <- colnames(output)
    AlignTable1 <- data.frame(matrix(nrow = 0, ncol = ncol(output)))
    AlignTable1 <- rbind(output, unique_1T, unique_2T)
  }
  if (nrow(unique_1) > 0 & nrow(unique_2) == 0) {
    unique_1T <- data.frame(matrix(nrow = 0, ncol = (ncol(unique_1) + 4)))
    unique_1T <- cbind(unique_1,0,0,0,0)
    colnames(unique_1T) <- colnames(output)
    AlignTable1 <- data.frame(matrix(nrow = 0, ncol = ncol(output)))
    AlignTable1 <- rbind(output, unique_1T)
  }
  if (nrow(unique_1) == 0 & nrow(unique_2) > 0) {
    unique_2T <- data.frame(matrix(nrow = 0, ncol = (ncol(unique_2) + 4)))
    unique_2T <- cbind(unique_2[,c(1:13)], do.call(cbind, replicate((k-1)*4, 0, simplify=FALSE)), 
                       unique_2[,c(14:17)])
    colnames(unique_2T) <- colnames(output)
    AlignTable1 <- data.frame(matrix(nrow = 0, ncol = ncol(output)))
    AlignTable1 <- rbind(output, unique_2T)
  }
}

summary[1,3] <- min(summary[,2])
summary[1,4] <- max(summary[,2])
summary[1,5] <- mean(summary[,2])
summary[1,6] <- sd(summary[,2])

#Check the features with >50% apperance across all the files in one sample group
Featuretable <- data.frame(matrix(nrow = 0, ncol = ncol(AlignTable1)))
colnames(Featuretable) <- colnames(AlignTable1)
for (q in 1:nrow(AlignTable1)) {
  vector <- AlignTable1[q, c(14:ncol(AlignTable1))]
  nonzero <- sum(vector != 0)
  if (nonzero > 2*n){
    Featuretable <- rbind(Featuretable, AlignTable1[q,])
  }
}
summary[1,7] <- nrow(Featuretable)

#Average all the quantitative values for the final feature table
Featuretablefinal <- data.frame(matrix(nrow = 0, ncol = 21))
colnames(Featuretablefinal) <- colnames(file1T)
colnames(Featuretablefinal)[c(14:17)] <- c("PeakHeightAverage", "ResolvingPowerAverage", 
                                      "mzErrorppmAverage", "ConfidenceScoreAverage")
colnames(Featuretablefinal)[c(18:21)] <- c("PeakHeightSTD", "ResolvingPowerSTD", 
                                      "mzErrorppmSTD", "ConfidenceScoreSTD")

for (w in 1:nrow(Featuretable)) {
  Featuretablefinal[w, c(1:13)] <- Featuretable[w, c(1:13)]
  Featuretablefinal[w, 14] <- mean(as.numeric(Featuretable[w, seq(from = 14, to = ncol(Featuretable)-3, by = 4)]))
  Featuretablefinal[w, 15] <- mean(as.numeric(Featuretable[w, seq(from = 15, to = ncol(Featuretable)-2, by = 4)]))
  Featuretablefinal[w, 16] <- mean(as.numeric(Featuretable[w, seq(from = 16, to = ncol(Featuretable)-1, by = 4)]))
  Featuretablefinal[w, 17] <- mean(as.numeric(Featuretable[w, seq(from = 17, to = ncol(Featuretable), by = 4)]))
  Featuretablefinal[w, 18] <- sd(as.numeric(Featuretable[w, seq(from = 14, to = ncol(Featuretable)-3, by = 4)]))
  Featuretablefinal[w, 19] <- sd(as.numeric(Featuretable[w, seq(from = 15, to = ncol(Featuretable)-2, by = 4)]))
  Featuretablefinal[w, 20] <- sd(as.numeric(Featuretable[w, seq(from = 16, to = ncol(Featuretable)-1, by = 4)]))
  Featuretablefinal[w, 21] <- sd(as.numeric(Featuretable[w, seq(from = 17, to = ncol(Featuretable), by = 4)]))
}
setwd(directory)
write.csv(Featuretable, file="RawFeaturetable.csv", row.names = FALSE)
write.csv(Featuretablefinal, file="AlignedFeatureTable.csv", row.names = FALSE)
write.csv(summary, file="SampleSummary.csv", row.names = FALSE)

