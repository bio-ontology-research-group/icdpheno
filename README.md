# icdpheno
This repository provides information and source code on text mining ICD-10 Phenotypes from the literature and gathering them from known resources:

 Text mining ICD-10-phenotype associations:
Source code of the text mining workflow used to extract ICD-10-phenotype associations from PubMed can be found from another github repository. 
https://github.com/bio-ontology-research-group/pmcanalysis
You can use snomed_hpo_icd_omim.owl.gz as disease resource (covers all ICD10 classes from UMLS), Human Phenotype Ontology, hpo.owl (https://hpo.jax.org/app/download/ontology) and Mammalian Phenotypes Ontology, mp.owl (http://www.obofoundry.org/ontology/mp.html) as phenotype resources and follow the steps to extract ICD10-phenotype associations from PubMed.

 Gathering known ICD-10-phenotype associations (Wikidata, UMLS, HPO, Propagation):

perl extract_known.pl >outfile.txt
