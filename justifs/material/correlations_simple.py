#!/usr/bin/env python
#
# Author: Thamme Gowda [tg (at) isi (dot) edu] 
# Created: 11/04/20

import logging as log

from scipy.stats import kendalltau, pearsonr
import pandas as pd

log.basicConfig(level=log.INFO)

def main(**args):
    alpha = 0.05  # significance testing
    df = pd.read_table('tables/Material-Joel-AQWV-MAP-2B2C2S.tsv', index_col=False).dropna()

    experiments = df.groupby('expt')['expt'].count()

    mt_metrics = ['BLEU', 'MacroF1', 'MicroF1', 'ChrF1', 'BLEURTMean', 'BLEURTMedian']
    ir_metrics = ['mAQWV', 'MAP']
    corr_methods = {'pearson': pearsonr, 'kendall': kendalltau}

    columns = ['Experiment', 'Correlation', 'IR'] + mt_metrics  # header
    res = []
    for corr_name, corr_func in corr_methods.items():
        for exp_name, n_exps in experiments.iteritems():
            exp_df = df[df['expt'] == exp_name]
            inner_delim = ' | '
            row = [exp_name, corr_name, inner_delim.join(ir_metrics)]
            res.append(row)

            for mt_metric in mt_metrics:
                cell_complex = []
                for ir_metric in ir_metrics:
                    corr_val, p_val = corr_func(exp_df[mt_metric], exp_df[ir_metric])
                    corr_val = f'{corr_val:.3f}'
                    if p_val >= alpha:
                        corr_val += '*'  # * means NOT significant i.e. p_val >= alpha
                    cell_complex.append(corr_val)
                row.append(inner_delim.join(cell_complex))

    #print(res)
    out_file = 'tables/material-correlations-simpl.tsv'
    log.info(f"Storing data at {out_file}")
    res_df = pd.DataFrame(data=res, columns=columns)
    res_df.to_csv(out_file, sep='\t')


if __name__ == '__main__':
    main()
