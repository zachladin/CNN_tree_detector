#clear working directory 
rm(list=ls())


library(jpeg)
library(R.utils)

##############################################################################################################
#Call the python script image_downloader.py and run query in bash

#set working directrory to where image_downloader.py is sitting
setwd("/Users/zach/Desktop/Image-Downloader-master")

#run python script from shell using system()
system("/anaconda/bin/python image_downloader.py --engine Google --max-number 550 'Conifer trees'")

############################################################################################################
#create new project folder
dir.create("/Users/zach/Dropbox (ZachTeam)/Projects/Bioverse/Analyses/Tree_deep_learning/Ailanthus_detector")
#create subfolder for copying scraped images
dir.create("/Users/zach/Dropbox (ZachTeam)/Projects/Bioverse/Analyses/Tree_deep_learning/Ailanthus_detector/Images")

#set working directory
setwd('/Users/zach/Dropbox (ZachTeam)/Projects/Bioverse/Analyses/Tree_deep_learning/Ailanthus_detector')

#move files to new folder

# identify the folders
current.folder <- "/Users/zach/Dropbox (ZachTeam)/Projects/Bioverse/Analyses/Tree_deep_learning/Image_scraping/Image-Downloader-master/download_images"

#make new folder (example Conifer)
dir.create("/Users/zach/Dropbox (ZachTeam)/Projects/Bioverse/Analyses/Tree_deep_learning/Google_image_test/Conifer")

#set new folder where files will be copied
new.folder <- "/Users/zach/Dropbox (ZachTeam)/Projects/Bioverse/Analyses/Tree_deep_learning/Google_image_test/Conifer"

# find the files that you want
list.of.files <- list.files(current.folder, pattern=".*.jpeg",full.names=TRUE)

# copy the files to the new folder
file.copy(list.of.files, new.folder)

##################################################################################################
#make new folders to store images
dir.create(paste(getwd(),"CNN",sep="/"))
dir.create(paste(getwd(),"CNN","test_set",sep="/"))
dir.create(paste(getwd(),"CNN","training_set",sep="/"))

#make lists to loop over
groupList<-c("Ailanthus","Other")

#make folders to add labeled images
for(i in 1:length(groupList)){
  dir.create(paste(getwd(),"CNN","test_set", groupList[i], sep="/"))
  dir.create(paste(getwd(),"CNN","training_set",groupList[i], sep="/"))
}

##################################################################################################
#rename files within species folders (for some reason works first time, but after that will delete files!! Be careful!)

treeNameList<-c("Oak","Conifer","Ash")
for(i in 1:length(treeNameList)){
  setwd("/Users/zach/Dropbox (ZachTeam)/Projects/Bioverse/Analyses/Tree_deep_learning/Ailanthus_detector")
  
  folder<-paste(getwd(),"Images", treeNameList[i],sep="/")
  setwd(folder)
  files <- list.files(folder)
  file.rename(from=files, to= paste(treeNameList[i], 1:length(files) ,"jpeg", sep="."))
}


##################################################################################################
#combine Oak, Conifer, and Ash pictures into one other folder (add 120 of each into Other)
setwd("/Users/zach/Dropbox (ZachTeam)/Projects/Bioverse/Analyses/Tree_deep_learning/Ailanthus_detector")

#create new Other folder
dir.create("/Users/zach/Dropbox (ZachTeam)/Projects/Bioverse/Analyses/Tree_deep_learning/Ailanthus_detector/Images/Other")

for(i in 1:length(treeNameList)){
  # identify the folders
  current.folder <- paste(getwd(),"Images",treeNameList[i],sep="/")
  #set new folder where files will be copied
  new.folder <- "/Users/zach/Dropbox (ZachTeam)/Projects/Bioverse/Analyses/Tree_deep_learning/Ailanthus_detector/Images/Other"
  numFiles<-200
  # find the files that you want
  list.of.files <- list.files(current.folder, pattern=".*.jpeg",full.names=TRUE)[1:numFiles]
  # copy the files to the new folder
  file.copy(list.of.files, new.folder)
}

##################################################################################################
#randomly shuffle order of files in Other
setwd("/Users/zach/Dropbox (ZachTeam)/Projects/Bioverse/Analyses/Tree_deep_learning/Ailanthus_detector/Images/Other")
system("sort --help")

##################################################################################################

#Rename Other folder trees (assign random numbers to mix sorted order)

setwd("/Users/zach/Dropbox (ZachTeam)/Projects/Bioverse/Analyses/Tree_deep_learning/Ailanthus_detector")




folder<-paste(getwd(),"Images", "Other",sep="/")
setwd(folder)
files <- list.files(folder)
randSeq<-sample(seq(1, length(files)),replace=FALSE)

file.rename(from=files, to= paste("Other", randSeq ,"jpeg", sep="."))

##################################################################################################
#now copy files into CNN group folders ()

#Training data
# identify the folders
current.folder <- paste(getwd(),"Images","Other",sep="/")
#set new folder where files will be copied
new.folder <- "/Users/zach/Dropbox (ZachTeam)/Projects/Bioverse/Analyses/Tree_deep_learning/Ailanthus_detector/CNN/training_set"
numFiles<-400
# find the files that you want
list.of.files <- list.files(current.folder, pattern=".*.jpeg",full.names=TRUE)[1:numFiles]
# copy the files to the new folder
file.copy(list.of.files, new.folder)


#Test data
# identify the folders
current.folder <- paste(getwd(),"Images","Other",sep="/")
#set new folder where files will be copied
new.folder <- "/Users/zach/Dropbox (ZachTeam)/Projects/Bioverse/Analyses/Tree_deep_learning/Ailanthus_detector/CNN/training_set"
#numFiles<-100
# find the files that you want
list.of.files <- list.files(current.folder, pattern=".*.jpeg",full.names=TRUE)[401:500]
# copy the files to the new folder
file.copy(list.of.files, new.folder)

##################################################################################################
#now run Tensor flow from python script (cnn_tree.py)
setwd
setwd('/Users/zach/Dropbox (ZachTeam)/Projects/Bioverse/Analyses/Tree_deep_learning/Ailanthus_detector/CNN')
dir()

system("/anaconda/bin/python cnn_tree.py")

