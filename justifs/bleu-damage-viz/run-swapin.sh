#!/usr/bin/env bash

#SBATCH --account=saral
#SBATCH --partition=saral
#SBATCH --mem=40g
#SBATCH --time=0-24:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=35
#SBATCH --gpus-per-task=0
#SBATCH --output=R-%x.out.%j
#SBATCH --error=R-%x.err.%j
#SBATCH --export=NONE


# requirements
# pip install sacrebleu sacremoses awkg

#oh wait, sacrebleu should come from https://github.com/isi-nlp/sacrebleu
# make sure the already installed sacrebleu is as new as sacrebleu-1.4.14 
export PYTHONPATH=../sacrebleu
export PYTHONPATH=../../libs/sacrebleu/

export N_CPUS=35

FILE=newstest19-deen.en
# download
[[ -f $FILE ]] || sacrebleu -t wmt19 -l de-en --echo ref > $FILE
# tokenize
[[ -f $FILE.tok ]] || sacremoses tokenize -xa < $FILE > $FILE.tok
# lc
[[ -f $FILE.tok.lc ]] || tr '[:upper:]' '[:lower:]' < $FILE.tok > $FILE.tok.lc
[[ -f $FILE.lc ]] || tr '[:upper:]' '[:lower:]' < $FILE > $FILE.lc


# types and frequencies
#export FILE=$FILE.tok.lc
export FILE=$FILE
export VOCAB=$FILE.tok.lc.vocab
#export NEWWORD='xxyyzz'  # word not in vocabulary
[[ -f $VOCAB ]] || tr ' ' '\n' < $FILE | sort | uniq -c | sort -nr | awk '{print $2,$1}' > $VOCAB

export PYTHONIOENCODING="UTF-8"
export metrics="bleu macrof microf"

echo "Type Frequency $metrics CHRF1 CHRF3" | tr ' ' '\t'

function damage {
    type="$1"
    freq="$2"
    (
        echo $type
        echo $freq
        # remove word, for poor recall
        sys_out=$(cat $FILE.tok.lc | python -c "
typ = '$type'
repl = 'ಅ' * len(typ)   # some OOV type of same number of chars

import sys
for line in sys.stdin:
    toks = line.split()
    toks = [tok if tok != typ else repl for tok in toks]
    print(' '.join(toks))
") 

	echo "${sys_out}" | sacrebleu $FILE.tok.lc -m $metrics -lc -w 5 -b -tok none

	# CHRF works on non tokenized data
	sys_out_detok=$( echo "${sys_out}" |  sacremoses detokenize )
	echo "${sys_out_detok}" | sacrebleu $FILE.lc -m chrf --chrf-beta=1 -lc -w 5 -b -tok none
	echo "${sys_out_detok}" | sacrebleu $FILE.lc -m chrf --chrf-beta=3 -lc -w 5 -b -tok none

    ) | tr '\n' '\t'
    echo ""
}


# for the GPU parallel
export SHELL=$(type -p bash)
export -f damage

cat $VOCAB |  while read type freq; do
    echo "damage '${type}' ${freq}"
done | parallel -J $N_CPUS 
