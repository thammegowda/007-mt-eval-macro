#!/usr/bin/env bash

# this is chrf which works on non tokenized data
# requirements
# pip install sacrebleu sacremoses awkg

#oh wait, sacrebleu should come from https://github.com/isi-nlp/sacrebleu
# make sure the already installed sacrebleu is as new as sacrebleu-1.4.14 
export PYTHONPATH=../sacrebleu
export PYTHONPATH=../../../rebleu/

export N_CPUS=20

FILE=newstest19-deen.en
# download
[[ -f $FILE ]] || sacrebleu -t wmt19 -l de-en --echo ref > $FILE
[[ -f $FILE.lc ]] || tr '[:upper:]' '[:lower:]' < $FILE > $FILE.lc

# tokenize
[[ -f $FILE.tok ]] || sacremoses tokenize -xa < $FILE > $FILE.tok
# lc
[[ -f $FILE.tok.lc ]] || tr '[:upper:]' '[:lower:]' < $FILE.tok > $FILE.tok.lc

# types and frequencies
export FILE=$FILE
export VOCAB=$FILE.tok.lc.vocab
[[ -f $VOCAB ]] || tr ' ' '\n' < $FILE | sort | uniq -c | sort -nr | awk '{print $2,$1}' > $VOCAB

export PYTHONIOENCODING="UTF-8"

echo "Type Frequency CHRF1 CHRF3" | tr ' ' '\t'

function damage {
    type="${1}"
    freq="$2"
        # remove word, for poor recall
        # tokenize -> damage detokenize
	# evaluate against untokenized refs
	
    sys_out=$(cat $FILE.tok.lc | python -c "
typ = '${type}'
import sys
for line in sys.stdin:
    toks = line.split()
    toks = [tok for tok in toks if tok != typ]
    print(' '.join(toks))
" | sacremoses detokenize )	

    (
	echo "${type}"
	echo "${freq}"
	echo "${sys_out}" | sacrebleu $FILE.lc -m chrf --chrf-beta=1 -lc -w 5 -b
	echo "${sys_out}" | sacrebleu $FILE.lc -m chrf --chrf-beta=3 -lc -w 5 -b
    ) | tr '\n' '\t'
    echo ""
}


# for the GPU parallel
export SHELL=$(type -p bash)
export -f damage

cat $VOCAB |  while read type freq; do
    echo "damage '${type}' ${freq}"
done | parallel -J $N_CPUS 
