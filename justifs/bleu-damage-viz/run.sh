#!/usr/bin/env bash

# requirements
# pip install sacrebleu sacremoses awkg

#oh wait, sacrebleu should come from https://github.com/isi-nlp/sacrebleu
# make sure the already installed sacrebleu is as new as sacrebleu-1.4.14 
export PYTHONPATH=../sacrebleu
export PYTHONPATH=../../libs/sacrebleu/

export N_CPUS=20

FILE=newstest19-deen.en
# download
[[ -f $FILE ]] || sacrebleu -t wmt19 -l de-en --echo ref > $FILE
# tokenize
[[ -f $FILE.tok ]] || sacremoses tokenize -xa < $FILE > $FILE.tok
# lc
[[ -f $FILE.tok.lc ]] || tr '[:upper:]' '[:lower:]' < $FILE.tok > $FILE.tok.lc

# types and frequencies
export FILE=$FILE.tok.lc
export VOCAB=$FILE.vocab
[[ -f $VOCAB ]] || tr ' ' '\n' < $FILE | sort | uniq -c | sort -nr | awk '{print $2,$1}' > $VOCAB

export PYTHONIOENCODING="UTF-8"
export metrics="bleu chrf macrof microf macrobleu microbleu"

echo "Type Frequency $metrics" | tr ' ' '\t'

function damage {
    type="$1"
    freq="$2"
    (
        echo $type
        echo $freq
        # remove word, for poor recall
        # gsed "s/\b$type\b//"  # I tried to use sed but i need word boundaries (\b) but literal match on chars like . and ? -- those contradict each other
        cat $FILE | python -c "
typ = '$type'
import sys
for line in sys.stdin:
    toks = line.split()
    toks = [tok for tok in toks if tok != typ]
    print(' '.join(toks))
" | sacrebleu $FILE -m $metrics --chrf-beta=1 -lc -tok none -w 5 -b
    ) | tr '\n' '\t'
    echo ""
}


# for the GPU parallel
export SHELL=$(type -p bash)
export -f damage

cat $VOCAB |  while read type freq; do
    echo "damage '$type' $freq"
done | parallel -J $N_CPUS 
