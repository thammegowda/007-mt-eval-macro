# Macro Average: Rare Types are Important Too

* Summary : https://isi.edu/~tg/posts/2021/03/macroavg-rare-types-important/ 
* Paper: https://aclanthology.org/2021.naacl-main.90/ 

This repository contains all the tools, analysis and outcomes of our "Macro-Average: Rare Types Are Important Too" paper. 

This repository has git submodules, so the correct way to clone this is:

    git clone --recursive git@github.com:thammegowda/007-mt-eval-macro.git

You may also refer to [.gitmodules](.gitmodules) file to see the URLs of submodules. 


The organization of this directory is as follows:

```
  + justifs/ 
     + webnlg-human-evaluation/:  WebNLG task
     + wmt-metrics/ :  WMT metrics task
     + material/     :  CLIR task CLSSTS datasets
     + mtir-lignos-etal-2019/ : CLIR task Europarl dataset
     + bleurt-bias/   : showing model-based metrics e.g. BLEUT are biased
  +  snmt-vs-unmt/  : comparison between SNMT v/s UNMT
```
Please refer to paper for the role of each task. Each directory have scripts required to obtain the results. 

