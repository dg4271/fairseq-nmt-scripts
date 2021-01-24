# fairseq-nmt-scripts
Fairseq scripts that can use to train NMT with various models and tokenizing (bpe, sentencepiece)


## How to use
1. Prepare a parallel corpus (raw data)
2. Write data parsing and cleansing code in "make_nmt_data".
3. Clone submodule (fairseq, subword-nmt)
```bash
git submodule init
git submodule update 
```
4. Install sentencepiece
```bash
pip install sentencepiece
```
5. Execute scripts below
### BPE
```bash
bash 1_prepare_nmt_data.sh [raw_data] [train_data_path]
bash 2_tokenization_bpe.sh [train_data_path] [number of operation]
bash 3_fairseq_preprocess.sh [train_data_path] --bpe
bash 4_fairseq_train.sh [train_data_path] transformer --bpe
bash 5_fairseq_generate.sh [train_data_path] transformer --bpe
```

### sentencepiece
```bash
bash 1_prepare_nmt_data.sh [raw_data] [train_data_path]
bash 2_tokenization_sentencepiece.sh [train_data_path] [vocab_size]
bash 3_fairseq_preprocess.sh [train_data_path] --sp [vocab_size]
bash 4_fairseq_train.sh [train_data_path] transformer --sp [vocab_size]
bash 5_fairseq_generate.sh [train_data_path] transformer --sp [vocab_size]
```


### Reference.
* https://github.com/pytorch/fairseq
* https://github.com/kakaobrain/jejueo/tree/master/translation
* https://github.com/rsennrich/subword-nmt
