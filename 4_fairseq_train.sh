#!/usr/bin/env bash

# bash 4_fairseq_train.sh [train_data_path] [arch] [args..]
# - e.g. bash 4_fairseq_train.sh [train_data_path] fconv_wmt_en_de --bpe
# - e.g. bash 4_fairseq_train.sh [train_data_path] fconv_wmt_en_de --sp 4k
# - e.g. bash 4_fairseq_train.sh [train_data_path] transformer --bpe
# - e.g. bash 4_fairseq_train.sh [train_data_path] transformer --sp 4k

domain=$(echo $1 | awk -F'/' '{print $3}')

if [ $# -eq 2 ]
then
    echo "for normal tokenization"
    CHECKPOINT=fairseq_checkpoints/$domain/$2
    DATABIN=$1/data_bin
elif [ $3 = "--bpe" ]
then
    echo "for original bpe tokenization"
    CHECKPOINT=fairseq_checkpoints/$domain/$2\_bpe
    DATABIN=$1/data_bin_bpe
elif [ $3 = "--sp" ]
then
    echo "for sentencepiece tokenization"
    CHECKPOINT=fairseq_checkpoints/$domain/$2\_sp\_$4
    DATABIN=$1/data_bin_sp\_$4
else
    echo "failed training"
fi

mkdir -p $CHECKPOINT


#input = $2
if [ $2 = "fconv_wmt_en_de" ]  # conv-seq2seq
then
    nohup fairseq-train \
        $DATABIN \
        --arch $2 \
        --dropout 0.2 \
        --criterion label_smoothed_cross_entropy --label-smoothing 0.1 \
        --optimizer nag --clip-norm 0.1 \
        --lr 0.5 --lr-scheduler fixed --force-anneal 50 \
        --max-tokens 4000 --max-epoch 100\
        --save-dir $CHECKPOINT > $CHECKPOINT.out &
elif [ $2 = "transformer" ] # transformer
then
    nohup fairseq-train \
        $DATABIN \
        --arch $2       \
        --optimizer adam \
        --lr 0.0005 \
        --label-smoothing 0.1 \
        --dropout 0.3       \
        --max-tokens 4000 \
        --stop-min-lr '1e-09' \
        --lr-scheduler inverse_sqrt       \
        --weight-decay 0.0001 \
        --criterion label_smoothed_cross_entropy       \
        --max-epoch 100 \
        --warmup-updates 4000 \
        --warmup-init-lr '1e-07'    \
        --adam-betas '(0.9, 0.98)'       \
        --save-dir $CHECKPOINT > $CHECKPOINT.out &
else
    echo "couldn't find archtecture"
    echo "bash fairseq_train.sh [path_to_domain] [archtecture] [--bpe]"
fi