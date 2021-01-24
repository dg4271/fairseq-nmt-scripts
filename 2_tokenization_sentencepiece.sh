#!/usr/bin/env bash

# e.g. bash 2_tokenization_sentencepiece.sh [train_data_path] [vocab_size]

# sentencepiece tokenizing
python build_sentencepiece.py --data_dir $1 --vocab_size $2