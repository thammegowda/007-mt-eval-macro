#!/usr/bin/env python
#
# Author: Thamme Gowda [tg (at) isi (dot) edu] 
# Created: 11/05/20

import logging as log
from scipy.stats import kendalltau, pearsonr

from pathlib import Path
import pandas as pd

log.basicConfig(level=log.INFO)

def main(**args):


    corr_methods = {'pearson': pearsonr, 'kendall': kendalltau}
    mt_metrics = 'BLEU_m,BLEU,MacroF1,MicroF1,CHRF1,MacroF3,MicroF3,CHRF3'.split(',')
    res_full = []
    res_simpl = []
    alpha = 0.05
    header = ['Year', 'Correlation', 'Langs'] + mt_metrics
    for year in [2019, 2018, 2017]:
        score_file = Path(f'tables/wmt-scores-{year}.tsv')
        df = pd.read_table(score_file, index_col=False).dropna()
        unwanted = ['Year', 'System']
        df.drop(columns=unwanted, inplace=True)
        langs = df.groupby('Langs')['Langs'].count()

        for corr_name, corr_func in corr_methods.items():
            for lang_name, sampl_size in langs.iteritems():
                lang_df = df[df['Langs'] == lang_name]
                res_full.append([year, corr_name, lang_name])
                res_simpl.append([year, corr_name, lang_name])
                for auto_name in mt_metrics:
                    corr_val, p_val = corr_func(lang_df[auto_name], lang_df['Human'])
                    corr_val = f'{abs(corr_val):.3f}'
                    res_full[-1].append(corr_val + f'|{p_val:.2f}')
                    res_simpl[-1].append(('*' if p_val >= alpha else '') + corr_val)  # * means not significant

    out_file = 'tables/wmt-correlations-all.tsv'
    log.info(f"Storing data at {out_file}")
    pd.DataFrame(res_full, columns=header).to_csv(out_file, sep='\t')

    out_file = 'tables/wmt-correlations-all-alpha0.05.tsv'
    log.info(f"Storing data at {out_file}")
    pd.DataFrame(res_simpl, columns=header).to_csv(out_file, sep='\t')


if __name__ == '__main__':
    main()
