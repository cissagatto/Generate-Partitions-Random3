##############################################################################
# Generate Random Partitions version 3                                       #
# Copyright (C) 2021                                                         #
#                                                                            #
# This code is free software: you can redistribute it and/or modify it under #
# the terms of the GNU General Public License as published by the Free       #
# Software Foundation, either version 3 of the License, or (at your option)  #
# any later version. This code is distributed in the hope that it will be    #
# useful, but WITHOUT ANY WARRANTY; without even the implied warranty of     #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General   #
# Public License for more details.                                           #
#                                                                            #
# Elaine Cecilia Gatto | Prof. Dr. Ricardo Cerri | Prof. Dr. Mauri           #
# Ferrandin | Federal University of Sao Carlos                               #
# (UFSCar: https://www2.ufscar.br/) Campus Sao Carlos | Computer Department  #
# (DC: https://site.dc.ufscar.br/) | Program of Post Graduation in Computer  #
# Science (PPG-CC: http://ppgcc.dc.ufscar.br/) | Bioinformatics and Machine  #
# Learning Group (BIOMAL: http://www.biomal.ufscar.br/)                      #
#                                                                            #
##############################################################################


###########################################################################
#
###########################################################################
FolderRoot = "~/Generate-Partitions-Random3"
FolderScripts = "~/Generate-Partitions-Random3/R"





##################################################################################################
# FUNCTION GENERATED RANDOM PARTITIONS                                                           #
#   Objective                                                                                    #
#       generated random partitions                                                              #
#   Parameters                                                                                   #
#       ds: specific dataset information                                                         #
#       names_labels: names of the labels                                                        #
#       number_folds: number of folds created                                                    #
#       FolderRandom: path folder                                                                #
#   Return                                                                                       #
#       configuration partitions                                                                 #
##################################################################################################
generateR3 <- function(ds,
                       dataset_name,
                       number_dataset, 
                       number_cores, 
                       number_folds, 
                       folderResults,
                       namesLabels,
                       resLS){
  
  diretorios <- directories(dataset_name, folderResults)
  
  f = 1
  while(f<=number_folds){
    
    cat("\nFold = ", f)
    
    FolderSplit = paste(diretorios$folderOutputDataset, "/Split-", f, sep="")
    if(dir.exists(FolderSplit)==TRUE){
    } else {
      dir.create(FolderSplit)
    }
    
    
    ############################################################################################################    
    #cat("\nCreate data frame to save results")
    num.fold = c(0)
    num.part = c(0)
    num.group = c(0)
    names.labels = c(0)
    num.index = c(0)
    AllPartitions = data.frame(num.fold, num.part, num.group, names.labels, num.index)
    
    ############################################################################################################
    group = c(0)
    label = c(0)
    allPartitions2 = data.frame(label, group)
    
    ############################################################################################################
    # cat("\nData frame")
    fold = c(0)
    partition = c(0)
    num.groups = c(0)
    resumePartitions = data.frame(fold, partition, num.groups)
    
    ############################################################################################################
    #cat("\nSorteia um número de grupos aleatoriamente")
    num.grupos <- sample(2:(ds$Labels-1),1)
    
    #cat("\nCria uma particao aleatória")
    particao = sample(1:num.grupos, ds$Labels, replace = TRUE)
    
    #cat("\nGarante que todos os números sao sorteados (dummies)")
    while(sum(1:num.grupos %in% particao) != num.grupos){
      particao <- sample(1:num.grupos, ds$Labels, replace = TRUE)
    }
    
    #cat("\nOrdena as partições e retorna os índices")
    particao.sorted <- sort(particao,index.return=TRUE)
    
    #cat("\nTRANSFORMA EM UM DATA FRAME")
    particao2 = data.frame(particao.sorted)
    
    #cat("\nALTERA OS NOMES DAS COLUNAS DO DATA FRAME")
    names(particao2) = c("num.grupo","num.rotulo")
    
    #cat("\nCOLOCA A PARTIÇÃO EM EM ORDEM ALFABÉTICA")
    particao3 = particao2[order(particao2$num.grupo, decreasing = FALSE), ] 
    
    ordem.labels = sort(namesLabels, index.return = TRUE)
    
    rotulos = data.frame(ordem.labels)
    
    names(rotulos) = c("names.labels","index")
    
    #cat("\nCOLOCA OS RÓTULOS EM ORDEM ALFABÉTICA")
    rotulos2 = rotulos[order(rotulos$index, decreasing = FALSE), ] 
    
    #cat("\nASSOCIA OS RÓTULOS COM OS ÍNDICES E OS GRUPOS")
    fold = f
    num.part = 1
    pFinal = data.frame(cbind(fold, num.grupos, num.part, particao3, rotulos2))
    
    #cat("\nSave specific partition")
    group = pFinal$num.grupo
    label = pFinal$names.labels
    pFinal2 = data.frame(group, label)
    setwd(FolderSplit)
    write.csv(pFinal2, "partition.csv", row.names = FALSE)
    
    #cat("\nFrequencia")
    library("dplyr")
    frequencia1 = count(pFinal2, pFinal2$group)
    names(frequencia1) = c("group", "totalLabels")
    setwd(FolderSplit)
    write.csv(frequencia1, paste("fold-", f, 
                                 "-labels-per-group-partition.csv", sep=""), 
              row.names = FALSE)
    
    #cat("\nUpdate data frame")
    num.fold = f
    num.part = 1
    num.group = pFinal$num.grupo
    names.labels = pFinal$names.labels
    num.index = pFinal$index
    AllPartitions = rbind(AllPartitions, 
                          data.frame(num.fold, num.part, 
                                     num.group, names.labels, 
                                     num.index))
    
    #cat("\nSave all partition in results dataset")
    setwd(FolderSplit)
    write.csv(AllPartitions[-1,], paste("fold-", f,
                                        "-all-partitions-v2.csv", sep=""),
              row.names = FALSE)
    
    #cat("\nTodas partições")
    pFinal = pFinal[order(pFinal$names.labels, decreasing = FALSE),]
    nomesDosRotulos = pFinal$names.labels
    group = pFinal$num.grupo
    allPartitions2 = cbind(allPartitions2, group)
    
    #cat("\ngruops por particao")
    fold = f
    partition = 1
    num.groups =  num.grupos
    resumePartitions = rbind(resumePartitions, data.frame(fold, 
                                                          partition, 
                                                          num.groups))
    
    allPartitions2 = allPartitions2[,-2]
    allPartitions2$label = nomesDosRotulos
    setwd(FolderSplit)
    write.csv(allPartitions2, paste("fold-", f, 
                                    "-all-partitions.csv", sep=""), 
              row.names = FALSE)
    
    resumePartitions = resumePartitions[-1,]
    setwd(FolderSplit)
    write.csv(resumePartitions, paste("fold-", f, 
                                      "-groups-per-partition.csv", sep=""),
              row.names = FALSE)
    
    f = f + 1
    gc()
  }
  
  cat("\nIncrement split: ", f)
  
  if(interactive()==TRUE){ flush.console() }
  gc()
  
  cat("\n\n################################################################################################")
  cat("\n# CLUS RANDOM 3: END FUNCTION generated Random Partitions                                        #")
  cat("\n##################################################################################################")
  cat("\n\n\n\n")
  gc()
}


