# getMetadata
Complete metadata from Kruvelab Chemical lists

Note: Only "Canonical SMILES" returned

## Usage
```
source(https://raw.githubusercontent.com/drewszabo/getMetadata/main/getMetadata.R)
chemList <- getMetadata("chem_solutions_lab.csv", export = "updated_list.csv")
```
### Expected Variables
| Name  | Molecular_Formula | Monoiso_Mass | SMILES | StdInChI | StdInChIKey | PubChem_CID |
| ----  | ---- | ---- | ---- | ---- | ---- | ---- |
| Atrazine  | C8H14ClN5 | 215.0938 | CCNC1=NC(=NC(=N1)Cl)NC(C)C | InChI=1S/C8H14ClN5/c1-4-10-7-12-6(9)13-8(14-7)11-5(2)3/h5H,4H2,1-3H3,(H2,10,11,12,13,14) | MXWJVTOOROXGIU-UHFFFAOYSA-N | 2256 |
