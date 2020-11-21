#!/usr/bin/env bash

#SBATCH --account=saral
#SBATCH --partition=saral
#SBATCH --mem=6g
#SBATCH --time=0-4:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=3
#SBATCH --gpus-per-task=1
#SBATCH --output=R-%x.out.%j
#SBATCH --error=R-%x.err.%j
#SBATCH --export=NONE

sys=$1
ref=$2

source ~/.bashrc
conda activate tflow


BLEURT=/nas/home/tg/work2/papers/007-mt-eval-macro/libs/bleurt/
[[ -d $BLEURT ]] || { echo "$BLEURT not found "; exit 1; }
[[ -d $BLEURT/bleurt-base-128 ]] || { echo "$BLEURT model not found "; exit 2; }

export PYTHONPATH=$BLEURT
export bleurt_base="python -m bleurt.score -bleurt_checkpoint $BLEURT/bleurt-base-128 -average "

echo -n "$sys "
$bleurt_base -candidate_file $sys -reference_file $ref  2> /dev/null
