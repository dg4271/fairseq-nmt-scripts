import random
import os
import sys

TRAINING_PERCENTAGE = 90
TEST_PERCENTAGE = 5
DEV_PERCENTAGE = 5

if __name__ == '__main__':
    
    dataset_file = os.path.splitext(sys.argv[1])[0]
    print(dataset_file)   
    src_file = dataset_file + '/all.src'
    tgt_file = dataset_file + '/all.tgt'
    
    lines = 0
    with open(src_file, 'r') as f:
        lines = len(list(enumerate(f)))

    random.seed()

    test_and_dev_percentage = sum([TEST_PERCENTAGE, DEV_PERCENTAGE])
    number_of_test_and_dev_examples = int(lines * test_and_dev_percentage / 100)
    number_of_dev_examples = int(number_of_test_and_dev_examples * DEV_PERCENTAGE / test_and_dev_percentage)

    dev_and_test = random.sample(range(lines), number_of_test_and_dev_examples)
    dev = random.sample(dev_and_test, number_of_dev_examples)

    with open(src_file) as original_src, open(tgt_file) as original_tgt:
        src = original_src.readlines()
        tar = original_tgt.readlines()

        train_src_lines, dev_src_lines, test_src_lines = [], [], []
        train_tgt_lines, dev_tgt_lines, test_tgt_lines = [], [], []
        
        for i in range(len(src)):
            src_line = src[i]
            tgt_line = tar[i]
            if i in dev_and_test:
                if i in dev:
                    dev_src_lines.append(src_line)
                    dev_tgt_lines.append(tgt_line)
                else:
                    test_src_lines.append(src_line)
                    test_tgt_lines.append(tgt_line)
            else:
                train_src_lines.append(src_line)
                train_tgt_lines.append(tgt_line)

        with open(dataset_file + '/train.src', 'w') as train_src, open(dataset_file + '/train.tgt', 'w') as train_tgt, \
             open(dataset_file + '/valid.src', 'w') as dev_src, open(dataset_file + '/valid.tgt', 'w') as dev_tgt, \
             open(dataset_file + '/test.src', 'w') as test_src, open(dataset_file + '/test.tgt', 'w') as test_tgt: 

            train_src.writelines(train_src_lines)            
            train_tgt.writelines(train_tgt_lines)
            dev_src.writelines(dev_src_lines)
            dev_tgt.writelines(dev_tgt_lines)
            test_src.writelines(test_src_lines)
            test_tgt.writelines(test_tgt_lines)
            