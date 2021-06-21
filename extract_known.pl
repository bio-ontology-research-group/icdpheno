use strict;

my (@tmp, @tmp2, %omim_pheno, $cnt, @arr,@tmp, %tm, $line, %tm_pairs, $key, %map, %wiki,%wiki_pairs, %hpo);
my (%sup, @omim_list, @pheno_list, $omim, $pheno);


open IN, "coding19.tsv" or die "coding19.tsv";
#A009    A00.9 Cholera, unspecified      289     286     Y
while ($line=<IN>)
{chomp $line;
@arr=split("\t", $line);
@tmp=split(" ",$arr[1]);
if ($tmp[0]=~/\./) {@tmp2=split('\.',$tmp[0]); $sup{$tmp[0]}=$tmp2[0]; } #$tmp2[0] contains supper class
}
close IN;
   #wikidata
open IN, "ICD10_sympthoms.txt" or die "wikidata sympthoms";
#A77.4   HP:0002315##HP:0002018
while ($line=<IN>)
{chomp $line;
@arr=split("\t", $line);
if (!exists $wiki{"ICD10:".$arr[0]})  {$wiki{"ICD10:".$arr[0]}=$arr[1];}
else {$wiki{"ICD10:".$arr[0]}=$wiki{"ICD10:".$arr[0]}."##".$arr[1];}

@tmp=split("##", $arr[1]);
foreach $key (@tmp)
{$wiki_pairs{"ICD10:".$arr[0]."##".$key}=1;}
}
close IN;


open IN, "ICD10_secondary.txt" or die "wikidata seconday data";
while ($line=<IN>)
{chomp $line;
@arr=split("\t", $line);
$wiki{"ICD10:".$arr[0]}=$arr[1];
@tmp=split("##", $arr[1]);
foreach $key (@tmp)
{$wiki_pairs{"ICD10:".$arr[0]."##".$key}=1;}

}
close IN;

my $tt;
open IN, "umls_icd_hpo.txt" or die "cannot open direct mappigs";
while ($line=<IN>)
{chomp $line;
@arr=split("\t", $line);
$wiki{"ICD10:".$arr[0]}=$arr[1];
@tmp=split("##", $arr[1]);
foreach $tt (@tmp)
{$wiki_pairs{"ICD10:".$arr[0]."##".$tt}=1;}
}


#print"---------ADDING OMIM-ICD10 MAPPING information from UMLS + WIKIDATA------------\n";
#getting omim-phenotypes from HPO

open IN, "HPO_omim_phenotypes.txt" or die "cannot open HPO_omim_phenotypes.txt\n";
while ($line=<IN>)
{ chomp $line;
@arr=split("\t", $line);
$arr[0]=~s/OMIM://g;
$omim_pheno{$arr[0]}=$arr[1]; # omim->hp_list
}
close IN;


open IN, "ICD10_omim.mapping.final.txt" or die "cannot open wikidata mappings file";
while ($line=<IN>)
{ chomp $line;
@arr=split("\t", $line);
$map{"ICD10:".$arr[0]}=$arr[1]; # icd->omimlist
}
close IN;
#print scalar (keys %map); print " ICD10 are mapped to omim in wikidata\n";

open IN, "icd_omim_inumls.map" or die "cannot open icd_omim_inumls.map\n";
#Essential (primary) hypertension        ICD10:I10       OMIM:145500
while ($line=<IN>)
{ chomp $line;
@arr=split("\t", $line);

$arr[2]=~s/OMIM://g;
if (!exists $map{$arr[1]}) {$map{$arr[1]}=$arr[2];} # icd->omimlist
else {$map{$arr[1]}=$map{$arr[1]}."##".$arr[2];}
}
close IN;


foreach $key (keys %map)
{ 
#if (exists $map{$key})
 #{ #print $key."\n";
   @omim_list=split("##", $map{$key});
   foreach $omim (@omim_list)
   {
     if (exists $omim_pheno{$omim})
     { @pheno_list=split("##",$omim_pheno{$omim});
       foreach $pheno (@pheno_list)
        { #print $key."##".$pheno."\n";
         $wiki_pairs{$key."##".$pheno}=1;
        }
     } 
   }
 #}

}

my %data;

$cnt=0;
foreach $key (keys %wiki_pairs)
{
 @arr=split("##", $key);
if (!exists $data{$arr[0]}) {$data{$arr[0]}=$arr[1];}
else {$data{$arr[0]}=$data{$arr[0]}."##".$arr[1];}
}


#propagate based on it's supercalss
foreach $key (keys %sup)
{ if ((!exists $data{"ICD10:".$key}) and (exists $data{"ICD10:".$sup{$key}}))
   { $data{"ICD10:".$key}=$data{"ICD10:".$sup{$key}};}
}

foreach $key (keys %data)
{print $key."\t".$data{$key}."\n";}


