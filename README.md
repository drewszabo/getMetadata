# getMetadata

## Description
A solution to complete missing information from a list of chemicals.<p>
The naming convention for each column follows the SusDat(S0) List as closely as possible. Each column will be completed from the SusDat List where possible. However, unmatched chemicals will then be queried to the PubChem database and this can take some time. If the PubChem query returns multiple results, it will return a `NA` value to avoid false positive results. At this time, some chemicals will not find results so manual entry of the `PubChem_CID` may be neccesary to ensure complete table is returned. <p> 

Note: Only "Canonical SMILES" returned

### Expected Variables
| Name  | Molecular_Formula | Monoiso_Mass | SMILES | StdInChI | StdInChIKey | PubChem_CID |
| ----  | ---- | ---- | ---- | ---- | ---- | ---- |
| Atrazine  | C8H14ClN5 | 215.0938 | CCNC1=NC(=NC(=N1)Cl)NC(C)C | InChI=1S/C8H14ClN5/c1-4-10-7-12-6(9)13-8(14-7)11-5(2)3/h5H,4H2,1-3H3,(H2,10,11,12,13,14) | MXWJVTOOROXGIU-UHFFFAOYSA-N | 2256 |

## Dependancies
```
library(tidyverse)
library(webchem)
```

## Usage
```
source(https://raw.githubusercontent.com/drewszabo/getMetadata/main/getMetadata.R)
chemList <- getMetadata("chem_solutions_lab.csv", export = "updated_list.csv")
```

## Arguments
#### filename
Path and filename of `.csv` file for repair
#### export
Path and filename of `.csv` to be generated

## Value
A data.frame object.

## Author
Drew Szabo <br>
Helen Sepman <p>

## Copyright
©️ KruveLab 2022. Stockholm University, Sweden 114 18.
