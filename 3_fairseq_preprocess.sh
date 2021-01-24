#!/usr/bin/env bash

# 
# e.g. 
#  bash 3_fairseq_preprocess.sh [train_data_path]
#  bash 3_fairseq_preprocess.sh [train_data_path] --bpe
#  bash 3_fairseq_preprocess.sh [train_data_path] --sp 4k

src=src
tgt=sgt

if [ $# -eq 1 ]
then
    echo "normal token"
    # normal token binarize
    fairseq-preprocess --source-lang $src --target-lang $tgt \
        --trainpref $1/train --validpref $1/valid --testpref $1/test \
        --destdir $1/data_bin \
        --joined-dictionary \
        --workers 20

elif [ $2 = "--bpe" ]
then
    echo "original bpe"
    # bpe token binarize
    fairseq-preprocess --source-lang $src --target-lang $tgt \
        --trainpref $1/bpe/train.bpe --validpref $1/bpe/valid.bpe --testpref $1/bpe/test.bpe \
        --destdir $1/data_bin_bpe \
        --joined-dictionary \
        --workers 20 
elif [ $2 = "--sp" ]
then
    SPPATH=sp_$3
    echo "sentencepiece bpe"
    # sentencepiece token binarize
    fairseq-preprocess --source-lang $src --target-lang $tgt \
        --trainpref $1/$SPPATH/train.sp --validpref $1/$SPPATH/valid.sp --testpref $1/$SPPATH/test.sp \
        --destdir $1/data_bin\_$SPPATH \
        --srcdict $1/$SPPATH/sentencepiece.bpe.dict\
        --tgtdict $1/$SPPATH/sentencepiece.bpe.dict\
        --workers 20 
else
    echo "failed pre-process"
fi