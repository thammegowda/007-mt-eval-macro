#!/usr/bin/env python
#
# Author: Thamme Gowda [tg (at) isi (dot) edu] 
# Created: 10/16/20


import logging as log
from pathlib import Path
import pandas as pd

log.basicConfig(level=log.INFO)


def main():
    files = [Path('MTIR-CSEN-Europarl-BM25.txt'), Path('MTIR-DEEN-Europarl-BM25.txt')]
    corr_dir = Path('correlations')
    corr_dir.mkdir(exist_ok=True)
    drops = ['Lang', 'Size', 'BPE'] # these cols dont need correlations
    for file in files:
        table = pd.read_table(file)

        table.drop(columns=drops, inplace=True)

        print(table)
        ##return
        for method in ['pearson', 'spearman', 'kendall']:
            corr_df = table.corr(method=method)
            out_file = corr_dir / f'{file.name.replace(".txt", "")}.{method}.tsv'
            print(f"====={out_file}====")
            print(corr_df)
            corr_df.to_csv(out_file, sep='\t', float_format='%.5f')


if __name__ == '__main__':
    main()
