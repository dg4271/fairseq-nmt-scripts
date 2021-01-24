'''
e.g.,
python build_sentencepiece.py --data_dir [train_data_path] --vocab_size 4000

ref. https://github.com/kakaobrain/jejueo/blob/master/translation/bpe_segment.py
'''

import os
import codecs
import sentencepiece as spm
import argparse

def train_sp(data_dir, vocab_size):

    sp_dir = data_dir+'/sp_{}k'.format(str(vocab_size)[:-3])
    os.makedirs(sp_dir, exist_ok=True)

    train_arg = f'--input={data_dir}/train.dialect-standard \
              --normalization_rule_name=identity \
              --model_prefix={sp_dir}/sentencepiece.bpe \
              --character_coverage=0.995 \
              --vocab_size={vocab_size} \
              --model_type=bpe'

    spm.SentencePieceTrainer.Train(train_arg)

    # modify Dictionary
    lines = [line.replace("\t", " ") for line in codecs.open(f'{sp_dir}/sentencepiece.bpe.vocab', 'r', 'utf8').read().splitlines()[3:]]
    with codecs.open(f'{sp_dir}/sentencepiece.bpe.dict', 'w', 'utf8') as fout:
        fout.write("\n".join(lines))
    os.system(f'rm {sp_dir}/sentencepiece.bpe.vocab')

    

def apply_sp(data_dir, vocab_size):
    
    sp_dir = data_dir+'/sp_{}k'.format(str(vocab_size)[:-3])
    
    # train/valid/test
    train_dialect = codecs.open(f"{data_dir}/train.dialect", 'r', 'utf8').read().splitlines()
    train_standard = codecs.open(f"{data_dir}/train.standard", 'r', 'utf8').read().splitlines()
    
    valid_dialect = codecs.open(f"{data_dir}/valid.dialect", 'r', 'utf8').read().splitlines()
    valid_standard = codecs.open(f"{data_dir}/valid.standard", 'r', 'utf8').read().splitlines()
    
    test_dialect = codecs.open(f"{data_dir}/test.dialect", 'r', 'utf8').read().splitlines()
    test_standard = codecs.open(f"{data_dir}/test.standard", 'r', 'utf8').read().splitlines()

    sp = spm.SentencePieceProcessor()
    sp.Load(f'{sp_dir}/sentencepiece.bpe.model')

    encode_as_sp(sp, train_dialect, f'{sp_dir}/train.sp.dialect')
    encode_as_sp(sp, train_standard, f'{sp_dir}/train.sp.standard')
    encode_as_sp(sp, valid_dialect, f'{sp_dir}/valid.sp.dialect')
    encode_as_sp(sp, valid_standard, f'{sp_dir}/valid.sp.standard')
    encode_as_sp(sp, test_dialect, f'{sp_dir}/test.sp.dialect')
    encode_as_sp(sp, test_standard, f'{sp_dir}/test.sp.standard')

def encode_as_sp(sp, sents, out_file):
    with codecs.open(out_file, 'w', 'utf8') as fout:
        fout.write("\n".join(" ".join(sp.EncodeAsPieces(sent)) for sent in sents))


if __name__ == "__main__":
    
    parser = argparse.ArgumentParser()
    parser.add_argument('--data_dir', type=str, required=True,
                        help="Dataset directory path")
    parser.add_argument('--vocab_size', type=int, default=4000,
                        help='Vocabulary size of SentencePiece')
    arg = parser.parse_args()

        
    # train&save sentencepiece model
    train_sp(f'{arg.data_dir}', arg.vocab_size)

    # load&apply sentencepiece model
    apply_sp(f'{arg.data_dir}', arg.vocab_size)
    
