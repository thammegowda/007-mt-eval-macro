#!/usr/bin/env bash
#SBATCH --account=saral
#SBATCH --partition=saral
#SBATCH --mem=60g
#SBATCH --time=0-12:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=40
#SBATCH --gpus-per-task=0
#SBATCH --output=R-%x.out.%j
#SBATCH --error=R-%x.err.%j
#SBATCH --export=NONE


N_JOBS=40
root=/nas/home/tg/work2/projects/beter-bleu/wmt

# these dirs are setup as per instructions in setup.md

export subs_dir=$root/wmt-submissions
export scores_dir=$root/wmt-sys-scores
export sys_dir=$subs_dir/system-outputs
export ref_dir=$subs_dir/references

function exit_log {
    printf "${2}\n"
    exit $1
}

function echoerr { 
    echo "$@" 1>&2
}


# cloned from https://github.com/isi-nlp/sacrebleu
export SACREBLEU="/nas/material02/users/tg/projects/beter-bleu/rebleu"
[[ -d $SACREBLEU ]] || exit_log 2 "$SACREBLEU not found"


function get_sys_score {
  score_file=$1
  sys_name=$2
  met_name=$3
  [[ -f $score_file ]] || exit_log 4 "ERROR: system score file $score_file not found"
  < $score_file awkg -b "sn='$sys_name'; mn='$met_name'" '
if NR == 1:
    m_idx = R.index(mn)
    s_idx = R.index("SYSTEM")
elif R[s_idx] == sn:
    print(R[m_idx])
' 
}

function compute_scores {
    [[ $# -eq 4 ]] || exit_log 3 "ERROR: Invalid args "
    tag="$1"
    sys_file=$2
    ref_file=$3
    lang_pair=$4
    [[ -f $sys_file ]] || exit_log 4 "ERROR: system out file $sys_file not found"
    [[ -f $ref_file ]] || exit_log 4 "ERROR: reference file $ref_file not found"
    
    #alias sacrebleu="PYTHONPATH=$SACREBLEU python -m sacrebleu"
    export PYTHONPATH=$SACREBLEU
    # BLEU
    (
        printf "${tag}\n";
        python -m sacrebleu -m bleu macrof microf macrobleuf microbleuf chrf \
            --chrf-beta 1 --rebleu-beta 1 --force -b -l $lang_pair $ref_file < $sys_file;
        python -m sacrebleu -m chrf --chrf-beta 3 --force -b  -l $lang_pair $ref_file < $sys_file;
    ) | tr '\n' '\t'
    
    echo ""
}


function wmtyear {
    year=$1

    sys_dir_year=$sys_dir/newstest$year
    langs=$(ls $sys_dir_year)
    for pair in $langs; do
        lang_dir=$sys_dir_year/$pair

        ref_file=$ref_dir/newstest$year-${pair/-/}-ref.${pair#*-}
        if [[ -f $ref_file.cln ]]; then
            ref_file=$ref_file.cln
            echoerr "INFO: Using $ref_file as ref file (Cleaned)"            
        fi
        scores_file=$scores_dir/DA-newstest$year-${pair/-/}-sys-nohy-scores.csv
        #echo $ref_file
        [[ -f $ref_file ]] || exit_log 2 "$ref_file not found"
        [[ -f $scores_file ]] || { echoerr "$scores_file not found"; continue; }

        for sys_file in $(ls $lang_dir/*.$pair); do
            sys_name=$(basename $sys_file)
            sys_id=${sys_name#*\.}; sys_id=${sys_id%\.*}  # newstest2019.NICT.6814.zh-en --> NICT.6814
            human=$(get_sys_score $scores_file $sys_id "HUMAN")
            BLEU_m=$(get_sys_score $scores_file $sys_id "BLEU")

            tag="$year\n$pair\n$sys_id\n$human\n$BLEU_m"
            echo compute_scores "'${tag}'" "${sys_file}" "${ref_file}" $pair
            #echo "printf '$year\n$pair\n$sys_id\n' && $SACREBLEU "
        done
    done
}


function print_sig {

    [[ $# -eq 3 ]] || exit_log 3 "ERROR: Invalid args "
    sys_file=$1
    ref_file=$2
    lang_pair=$3


    export PYTHONPATH=$SACREBLEU
    ( python -m sacrebleu -m bleu macrof microf macrobleuf microbleuf chrf \
        --chrf-beta 1 --rebleu-beta 1 --force -l $lang_pair $ref_file < $sys_file;
    python -m sacrebleu -m chrf --chrf-beta 3 --force -l $lang_pair $ref_file < $sys_file;
    ) | cut -f1 -d ' '
}

function print_sig_all {
    year=2019

    sys_dir_year=$sys_dir/newstest$year
    langs=$(ls $sys_dir_year)
    for pair in $langs; do
        lang_dir=$sys_dir_year/$pair
        ref_file=$ref_dir/newstest$year-${pair/-/}-ref.${pair#*-}
        #echo $ref_file
        [[ -f $ref_file ]] || exit_log 2 "$ref_file not found"

        for sys_file in $(ls $lang_dir/*.$pair); do
            #echo "printf '$year\n$pair\n$sys_id\n' && $SACREBLEU "
            echo print_sig "$sys_file" "$ref_file" "$pair"
            break
        done
    done
}


export -f compute_scores
export -f get_sys_score
export -f exit_log
export -f echoerr
export -f print_sig
export -f print_sig_all


for year in 2019 2018 2017; do  #
    echo "===== $year ===="
    ( echo "Year Langs System Human BLEU_m BLEU MacroF1 MicroF1 MacroBLEUF MicroBLEUF CHRF1 CHRF3" | tr ' ' '\t'
      wmtyear $year | parallel -j $N_JOBS 
    ) > wmt-scores-$year.tsv
done

print_sig_all | parallel -j $N_JOBS  > wmt-scores-2019-signatures.txt