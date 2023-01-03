###This is a script to automatically subtract blank feature across all sample files (part 2)##
#Jian (Felix) Guo
#2022-12-31
###################################################################

library(dplyr)
#Set directory
directory <- "F:/Jian_Guo/PNNLpythondataproceesing_projects_20221111/csv"
#input csv files names and parameters
setwd(directory)
file1 <- read.csv("AlignedFeatureTableInfect.csv", stringsAsFactors = F)
file2 <- read.csv("AlignedFeatureTableMedia.csv", stringsAsFactors = F)
filename1 <- "blanksubfeaturetableInfectoption1.csv"
filename2 <- "blanksubfeaturetableInfectoption2.csv"
subrate <- 3

#Create background (media) subtracted files
#Option 1: Remove samples features that are also present in the blank
subfileoption1 <- file1[!file1$Molecular.Formula%in%file2$Molecular.Formula,]
write.csv(subfileoption1, file=filename1, row.names = FALSE)

#Option 2: Remove samples features if their peak heights are less than 3x greater than that of the blank
output <- data.frame(matrix(nrow = 0, ncol = ncol(file1) + 1))
colnames(output) <- c(colnames(file1), "Blankpeakheight")
for(i in 1:nrow(file1)){
  temp <- file2[file2$Molecular.Formula == file1$Molecular.Formula[i], ]
  if(nrow(temp) > 0) {
    tmprow <- cbind(file1[i,], temp[1, 14])
    colnames(tmprow) <- colnames(output)
    output <- rbind(output, tmprow)
  }
}
subfileoption2 <- data.frame(matrix(nrow = 0, ncol = ncol(file1)))
colnames(subfileoption2) <- colnames(file1)
subfileoption2 <- output[output[,14] > subrate*output[,22], c(1:21)]
subfileoption2 <- rbind(subfileoption2, subfileoption1)
write.csv(subfileoption2, file=filename2, row.names = FALSE)
