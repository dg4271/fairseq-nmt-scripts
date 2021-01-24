#!/usr/bin/env bash

# e.g. bash 1_prepare_nmt_data.sh [raw_data] [train_data_path]

src=src
tgt=sgt

# download & parsing & cleasing data
#   e.g. python make_nmt_data.py [raw_data] [train_data_path]
python make_nmt_data.py $1 $2

# split train/dev/text
#   e.g. python split_in_train_dev_test.py [train_data_path]
python split_in_train_dev_test.py $2