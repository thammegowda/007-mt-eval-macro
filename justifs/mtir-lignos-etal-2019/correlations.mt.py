#!/usr/bin/env python
#
# Author: Thamme Gowda [tg (at) isi (dot) edu] 
# Created: 10/16/20


import logging as log
from pathlib import Path
import pandas as pd
from scipy.stats import pearsonr, kendalltau

log.basicConfig(level=log.INFO)


def main():
    file = 'MTIR-scores-all-corrected.txt'
    table = pd.read_table(file)
    table['Group'] = table['Lang'] + ' ' + table['Dataset'] + ' ' + table['Model']
    table.drop(columns=['Lang', 'Dataset', 'Model'], inplace=True)
    groups = table.groupby('Group')['Group'].count()

    ir_mets = 'MAP P10 R10 RBO NDCG'.split()
    mt_mets = 'BLEU CHRF1 MacroF1 MicroF1 BLEURTMean BLEURTMedian'.split()

    corr_methods = [('kendall', kendalltau), ('pearson', pearsonr)]
    alpha = 0.05

    header = ['Group', 'MT'] + mt_mets

    for corr_name, corr_func in corr_methods:
        result = []
        for group_name, _ in groups.items():
            group = table[table['Group'] == group_name]
            assert len(group) == 16
            for ir_met in mt_mets: #ir_mets:
                row = [group_name, ir_met]
                for mt_met in mt_mets:
                    # print(row, mt_met)
                    corr_val, p_val = corr_func(group[mt_met], group[ir_met])
                    corr_val = f'{abs(corr_val):.3f}'
                    row.append(('*' if p_val >= alpha else '') + corr_val)
                result.append(row)

        res = pd.DataFrame(result, columns=header)
        out_file = f'MTIR-{corr_name}.mt.csv'
        log.info(f"Saving {out_file}")
        res.to_csv(out_file, sep='\t')



if __name__ == '__main__':
    main()
