#!/usr/bin/env bash

# - e.g. bash 5_fairseq_generate.sh [train_data_path] fconv_wmt_en_de
# - e.g. bash 5_fairseq_generate.sh [train_data_path] transformer
# - e.g. bash 5_fairseq_generate.sh [train_data_path] transformer --bpe
# - e.g. bash 5_fairseq_generate.sh [train_data_path] transformer --sp 4k


domain=$(echo $1 | awk -F'/' '{print $3}')

if [ $# -eq 2 ]
then
     # for normal tokenization
     CHECKPOINT=fairseq_checkpoints/$domain/$2
     DATABIN=$1/data_bin
elif [ $3 = "--bpe" ]
then
     # for original bpe tokenization
     CHECKPOINT=fairseq_checkpoints/$domain/$2\_bpe
     DATABIN=$1/data_bin_bpe
elif [ $3 = "--sp" ]
then
     # for sentencepiece tokenization
     CHECKPOINT=fairseq_checkpoints/$domain/$2\_sp\_$4
     DATABIN=$1/data_bin_sp\_$4
else
     echo "failed generation"
fi

RESULT=$CHECKPOINT/results
mkdir -p $RESULT

fairseq-generate $DATABIN \
     --path $CHECKPOINT/checkpoint_best.pt \
     --batch-size 128 --beam 5 --remove-bpe sentencepiece | tee $RESULT/$domain\_$2.out

# Compute BLEU score
# system output
grep ^H $RESULT/$domain\_$2.out | cut -f3- > $RESULT/$domain\_$2.out.sys
# Target of test data
grep ^T $RESULT/$domain\_$2.out | cut -f2- > $RESULT/$domain\_$2.out.ref
fairseq-score --sys $RESULT/$domain\_$2.out.sys --ref $RESULT/$domain\_$2.out.ref