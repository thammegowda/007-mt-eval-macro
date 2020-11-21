
N_JOB=10

metrics="bleu chrf macrof microf";
rebleu="PYTHONPATH=../007-mt-eval-macro/libs/sacrebleu/ python -m sacrebleu "
(echo "System $metrics";
 for sys in mt_test_output_corrected/*/sys.detok.txt; do ref=${sys/sys.detok/ref};  echo " (echo $(dirname $sys) && $rebleu $ref -m $metrics --width 2 --chrf-beta 1 -b < $sys ) | tr '\n' ' ' && echo ''"; done | parallel -J $N_JOB )
