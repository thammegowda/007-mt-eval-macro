#!/usr/bin/env python
#
# Author: Thamme Gowda [tg (at) isi (dot) edu] 
# Created: 10/28/20

import logging as log

from pathlib import Path
import pandas as pd

log.basicConfig(level=log.INFO)

def main(**args):
    out_file = 'tables/wmt-correlations.xlsx'
    log.info(f"Storing data at {out_file}")
    writer = pd.ExcelWriter(out_file, engine='xlsxwriter')

    for year in [2019, 2018, 2017]:
        score_file = Path(f'tables/wmt-scores-{year}.tsv')
        df = pd.read_table(score_file, index_col=False).dropna()
        unwanted = ['Year', 'System']
        df.drop(columns=unwanted, inplace=True)
        sample_sizes = df.groupby('Langs')['Langs'].count()
        sample_sizes.to_excel(writer, sheet_name=f'{year}-SampleSizes')

        for method in ['pearson', 'spearman', 'kendall']:
            log.info(f"{year} {method}")
            corr_full = df.groupby('Langs').corr(method=method)
            corr_min = corr_full.loc[['Human' in idx for idx in corr_full.index]]
            corr_min.drop(columns=['Human'], inplace=True)

            #out_file = score_file.with_name(score_file.name.replace('-scores', f'-corr-{method}'))
            #corr_min.to_csv(out_file, sep='\t', float_format='%.3f')
            corr_min.to_excel(writer, sheet_name=f'{year}-{method}', float_format='%.3f')

    writer.close()

if __name__ == '__main__':
    main()
