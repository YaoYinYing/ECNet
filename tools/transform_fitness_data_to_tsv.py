#! python
'''
@Usage
 python transform_fitness_data_to_tsv.py <dataset.csv> <column of variants> <column of fitness> <mutation separator>

'''
'''
@example
 python transform_fitness_data_to_tsv.py ~/Documents/projects/P450/Test_Transformer_890_experi/merged/P450_experi_data_encoded.csv 'variants' '11H-Cuol' -
/Users/yyy/Documents/projects/P450/Test_Transformer_890_experi/merged/P450_experi_data_encoded.csv
'''

import pandas as pd
import pathlib
import sys
import os

in_csv = pathlib.Path(sys.argv[1]).resolve()
data_path = in_csv.parent
out_tsv = pathlib.Path(f'{data_path}/{in_csv.stem}.tsv').resolve()

variant_col = sys.argv[2]
fitness_col = sys.argv[3]
try:
	sep = sys.argv[4]
except Exception as e:
	print(e)
	sep = '-'
print(in_csv)

df = pd.read_csv(in_csv, usecols=[variant_col, fitness_col])

# remove WT colume bcs this is not a mutant variant
try:
	df.drop(index=df[df.loc[:, variant_col] == 'WT'].index, inplace=True)
except:
	pass

variants = df.variants

# as the format required by ECNet fitness table
for v in variants:
	df.loc[(df.loc[:, variant_col] == v), 'mutation'] = v.replace(sep, ';')

df.drop(columns=[variant_col], inplace=True)

df.to_csv(out_tsv, sep='\t',index=False)
