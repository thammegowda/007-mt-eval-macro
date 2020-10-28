# 005-nmt-as-cls
NMT as autoregressive classifier 





# WMT correlations


## Compute Scores on WMT datasets 

NOTE: You may skip this step and reuse the already computed scores in `tables/wmt-*.tsv`

Step 1: Refer to `notes/setup.md` to download WMT files
Step 2: Download customized [sacrebleu](https://github.com/isi-nlp/sacrebleu/archive/44f17a8374af6512b4a9b23295008f0a8526a6bf.zip)

    git clone https://github.com/isi-nlp/sacrebleu
    git checkout 44f17a8
 
Step 3:  Run `scripts/wmt-scores.sh` ; edit the paths before you run
 

## Correlations with Human Judgements



