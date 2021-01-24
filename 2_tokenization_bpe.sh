#!/usr/bin/env bash

# e.g. bash 2_tokenization_bpe.sh [train_data_path] [number of operation]

src=src
tgt=sgt

# bpe tokenizing
TRAIN=$1/train\.$src\-$tgt
BPEROOT=./subword-nmt/subword_nmt
BPE_CODE=$1/bpe_code
BPE_TOKENS=$2
rm -f $TRAIN
for l in $src $tgt; do
    cat $1/train.$l >> $TRAIN
done

echo "learn_bpe.py on ${TRAIN}..."
python $BPEROOT/learn_bpe.py -s $BPE_TOKENS < $TRAIN > $BPE_CODE

for L in $src $tgt; do
    for f in train valid test; do
        echo "apply_bpe.py to ${f}.bpe.${L}..."
        python $BPEROOT/apply_bpe.py -c $BPE_CODE < $1/$f\.$L > $1/$f\.bpe\.$L
    done
done