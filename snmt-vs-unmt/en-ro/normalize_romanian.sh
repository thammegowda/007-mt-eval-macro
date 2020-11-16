TOOLS_PATH=/Users/weiqiuyou/Documents/USC_ISI/QUM/QUM/tools
WMT16_SCRIPTS=$TOOLS_PATH/wmt16-scripts
NORMALIZE_ROMANIAN=$WMT16_SCRIPTS/preprocess/normalise-romanian.py
REMOVE_DIACRITICS=$WMT16_SCRIPTS/preprocess/remove-diacritics.py

INPUT_FILE="$1"

PROCESSING="$NORMALIZE_ROMANIAN | $REMOVE_DIACRITICS"

eval "cat $INPUT_FILE | $PROCESSING > $INPUT_FILE.norm"