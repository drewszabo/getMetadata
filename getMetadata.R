getMetadata <- function(filename, export = FALSE){
  
  #-----------------
  # Initialliztion
  #-----------------
  
  if (!require("tidyverse", quietly = TRUE))
    install.packages("tidyverse")
  
  if (!require("webchem", quietly = TRUE))
    install.packages("webchem")
  
  library(tidyverse)
  library(webchem)
  
  # Check if PubChem is up
  if (ping_service("pc") == FALSE) {
    # Stop the script if the status code is not
    stop("Error: PubChem is not available. Try again later.")
  }
  
  #-----------------
  # Clean up
  #-----------------
  
  # File import
  file <- read_delim(filename,
                     delim = ",",
                     trim_ws = TRUE)
  #file[file == "" | file == "-"] <- NA
  
  # Remove invalid SMILES and InChI (TBA)
  
  #-----------------
  # Get PubChem_CID from SMILES, InChI, InChIKey, or Name
  #-----------------

  # InChI
  file <- file %>%
    rowwise() %>%
    mutate(PubChem_CID = ifelse(is.na(PubChem_CID) & !is.na(StdInChI),
                                unlist(get_cid(StdInChI, from = "inchi", domain = "compound", match = "na", verbose = TRUE)[[2]]),
                                as.character(PubChem_CID))) %>%
    ungroup()
  
  # InChIKey
  file <- file %>%
    rowwise() %>%
    mutate(PubChem_CID = ifelse(is.na(PubChem_CID) & !is.na(StdInChIKey),
                                unlist(get_cid(StdInChIKey, from = "inchikey", domain = "compound", match = "na", verbose = TRUE)[[2]]),
                                as.character(PubChem_CID))) %>%
    ungroup()
  
  # SMILES
  file <- file %>%
    rowwise() %>%
    mutate(PubChem_CID = ifelse(is.na(PubChem_CID) & !is.na(SMILES),
                                unlist(get_cid(SMILES, from = "smiles", domain = "compound", match = "na", verbose = TRUE)[[2]]),
                                as.character(PubChem_CID))) %>%
    ungroup()
  
  # Name
  file <- file %>%
    rowwise() %>%
    mutate(PubChem_CID = ifelse(is.na(PubChem_CID), 
                                unlist(get_cid(Name, from = "name", match = "na", domain = "compound", verbose = TRUE)[[2]]),
                                as.character(PubChem_CID))) %>%
    ungroup()
  
  #-----------------
  # Get PubChem data for all
  #-----------------
  
  pcProp <- pc_prop(file$PubChem_CID,
                    properties = c("InChI", "InChIKey", "MonoisotopicMass", "MolecularFormula", "CanonicalSMILES"),
                    verbose = TRUE)
  
  #-----------------
  # Merge missing info with existing data
  #-----------------
  
  #Molecular Formula
  file$molecular_formula[is.na(file$molecular_formula)] <- 
    pcProp$MolecularFormula[match(file$PubChem_CID, pcProp$CID)[which(is.na(file$molecular_formula))]]
  
  #Monoiso Mass
  file$monoiso_mass[is.na(file$monoiso_mass)] <- 
    pcProp$MonoisotopicMass[match(file$PubChem_CID, pcProp$CID)[which(is.na(file$monoiso_mass))]]
  
  #InChi
  file$StdInChI[is.na(file$StdInChI)] <- 
    pcProp$InChI[match(file$PubChem_CID, pcProp$CID)[which(is.na(file$StdInChI))]]
  
  #InChIKey
  file$StdInChIKey[is.na(file$StdInChIKey)] <- 
    pcProp$InChIKey[match(file$PubChem_CID, pcProp$CID)[which(is.na(file$StdInChIKey))]]
  
  #SMILES
  file$SMILES[is.na(file$SMILES)] <- 
    pcProp$CanonicalSMILES[match(file$PubChem_CID, pcProp$CID)[which(is.na(file$SMILES))]]
  
  #-----------------
  # If a chemical does not have PubChem_CID but has been used before and has manually inserted metadata
  #-----------------
  
  # if PubChem_CID is still empty
  # file <- file %>%
  #   rowwise() %>%
  #   mutate(PubChem_CID = ifelse(is.na(PubChem_CID),

  # chemicals_notInPubChem <- file %>% 
  #   filter(is.na(PubChem_CID)) %>% 
  #   drop_na(name)
  # ... needs to be fixed
  
  #-----------------
  # Export and Return
  #-----------------
  
  if(export != FALSE){
    write_delim(file, export, delim = ",")
  }
  
  return(file)
  
}
