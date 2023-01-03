###This is a script to automatically align the final feature tables together (part 3)##
#Jian (Felix) Guo
#2022-12-31
###################################################################
library(dplyr)
#Set directory
directory <- "F:/Jian_Guo/PNNLpythondataproceesing_projects_20221111/csv"
#input csv files names and parameters
setwd(directory)
file1 <- read.csv("blanksubfeaturetableControloption2.csv", stringsAsFactors = F)
file2 <- read.csv("blanksubfeaturetableInfectoption2.csv", stringsAsFactors = F)
FinalFeatureTableName <- "FinalCommonFeatureTable2.csv"
UnqiueControlName <- "FinalUnqiueControl2.csv"
UnqiueInfectName <- "FinalUnqiueInfect2.csv"

#Align control and infectious feature tables
output <- data.frame(matrix(nrow = 0, ncol = 29))
colnames(output) <- c(colnames(file1)[c(1:13)], "PeakHeightMeanControl", "PeakHeightMeanInfect","ResolvingPowerMeanControl",
                      "ResolvingPowerMeanInfect","mzErrorppmMeanControl", "mzErrorppmMeanInfect",
                      "ConfidenceScoreMeanControl","ConfidenceScoreMeanInfect","PeakHeightSDControl", "PeakHeightSDInfect",
                      "ResolvingPowerControlSD", "ResolvingPowerSDInfect","mzErrorppmSDControl", 
                      "mzErrorppmSDInfect", "ConfidenceScoreSDControl","ConfidenceScoreSDInfect")
for(i in 1:nrow(file1)){
  temp <- file2[file2$Molecular.Formula == file1$Molecular.Formula[i], ]
  if(nrow(temp) > 0) {
    tmprow <- cbind(file1[i, c(1:14)], temp[1, 14], file1[i, 15], temp[1, 15], file1[i, 16], temp[1, 16],
                    file1[i, 17], temp[1, 17], file1[i, 18], temp[1, 18], file1[i, 19], temp[1, 19], 
                    file1[i, 20], temp[1, 20], file1[i, 21], temp[1, 21])
    colnames(tmprow) <- colnames(output)
    output <- rbind(output, tmprow)
  }
}
write.csv(output, file=FinalFeatureTableName, row.names = FALSE)

#Find the unique features of the two sample files
unique1_1 <- anti_join(file1, as.data.frame(output[13]))
unique1_2 <- anti_join(file2, as.data.frame(output[13]))
write.csv(unique1_1, file=UnqiueControlName, row.names = FALSE)
write.csv(unique1_2, file=UnqiueInfectName, row.names = FALSE)
