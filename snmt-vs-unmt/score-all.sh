#!/usr/bin/env bash
# SNMT vs UNMT differences
# Authors:
#   Thamme Gowda


my_exit(){
    printf "$2\n" ; exit $1
}

SACREBLEU=../libs/sacrebleu
BLEURT=../libs/bleurt

[[ -d $SACREBLEU ]] || my_exit 2 "$SACREBLEU dir not found, please clone https://github.com/isi-nlp/sacrebleu"
[[ -d $BLEURT ]] || my_exit 2 "$BLEURT dir not found, please clone https://github.com/thammegowda/bleurt"


bleu() {
    hyp=$1
    ref=$2
    PYTHONPATH=$SACREBLEU python -m sacrebleu $ref -m bleu -b < $hyp
}

macrof1()  {
    hyp=$1
    ref=$2
    PYTHONPATH=$SACREBLEU python -m sacrebleu $ref -m macrof --rebleu-beta=1 -b < $hyp
}

microf1()  {
    hyp=$1
    ref=$2
    PYTHONPATH=$SACREBLEU python -m sacrebleu $ref -m microf --rebleu-beta=1 -b < $hyp
}

chrf1() {
   hyp=$1
   ref=$2
   PYTHONPATH=$SACREBLEU python -m sacrebleu $ref -m chrf --chrf-beta=1 -b < $hyp
}

bleurt() {
    hyp=$1
    ref=$2
    
    bleurt_base="python -m bleurt.score -bleurt_checkpoint $BLEURT/bleurt-base-128 -average "
    PYTHONPATH=$BLEURT $bleurt_base -candidate_file $hyp -reference_file $ref 2> /dev/null || my_exit 5 "BLUERT is not working"
    #PYTHONPATH=$BLEURT $bleurt_base -candidate_file $hyp -reference_file $ref  || my_exit 5 "BLUERT is not working"
}


main() {
    echo -n "Pair BLEU_s BLEU_u MacroF1_s MacroF1_u MicroF1_s MicroF1_u CHRF1_s CHRF1_u"
    echo " BLEURTmean_s BLEURTmean_u BLEURTmedian_s BLEURTmedian_u"

    for pair in *-en en-*; do
    #for pair in en-ro; do
        src=$(echo $pair/src/*.*)
        ref=$(echo $pair/ref/*.*)
        snmt=$(echo $pair/snmt/*.*)
        unmt=$(echo $pair/unmt/*.*)
        for path in $src $ref $snmt $unmt; do
            [[ -f $path ]] || my-exit 2 "ERROR: $path not found"
        done
        echo -n "$pair "
        echo -n "$(bleu $snmt $ref) "
        echo -n "$(bleu $unmt $ref) "
        echo -n "$(macrof1 $snmt $ref) "
        echo -n "$(macrof1 $unmt $ref) "
        echo -n "$(microf1 $snmt $ref) "
        echo -n "$(microf1 $unmt $ref) "	
        echo -n "$(chrf1 $snmt $ref) "
        echo -n "$(chrf1 $unmt $ref) "

        read mean_s median_s <<< "$(bleurt $snmt $ref | cut -d' ' -f2,4)"
        read mean_u median_u <<< "$(bleurt $unmt $ref | cut -d' ' -f2,4)"
        echo -n "$mean_s $mean_u $median_s $median_u "

        echo ""
    done
}

main
