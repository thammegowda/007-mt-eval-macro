#!/usr/bin/env bash
# SNMT vs UNMT differences
# Authors:
#   Thamme Gowda


my_exit(){
    printf "$2\n" ; exit $1
}

SACREBLEU=../libs/sacrebleu
[[ -d $SACREBLEU ]] || my_exit 2 "$SACREBLEU dir not found, please clone https://github.com/isi-nlp/sacrebleu"


class_report()  {
    hyp=$1
    ref=$2
    report=$3
    PYTHONPATH=$SACREBLEU python -m sacrebleu $ref -m macrof -lc --rebleu-beta=1 -b --report $report.lc < $hyp 
    PYTHONPATH=$SACREBLEU python -m sacrebleu $ref -m macrof --rebleu-beta=1 -b --report $report.mc < $hyp
}


main() {
    for pair in *-en en-*; do
        ref=$(echo $pair/ref/*.*)
        snmt=$(echo $pair/snmt/*.*)
        unmt=$(echo $pair/unmt/*.*)
        snmt_rep=$pair/typeperf.snmt.tsv
        unmt_rep=$pair/typeperf.unmt.tsv
        echo "$pair"
        class_report $snmt $ref $snmt_rep
        class_report $unmt $ref $unmt_rep
    done
}

main
