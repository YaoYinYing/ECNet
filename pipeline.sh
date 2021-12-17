
# activate conda env
conda activate ECnet

# wt sequence for msa building
input_fasta=890.fasta;
prefix=${input_fasta%.fasta};

# db for hhblits
hhblits_db=/mnt/db/uniclust30/uniclust30_2018_08/uniclust30_2018_08;

# search homologous
hhblits -i $input_fasta -o $prefix\_ecnet.hhr -oa3m $prefix\_ecnet.a3m -n 3 -id 99 -cov 50 -cpu 8 -d $hhblits_db

# scripts path
path_to_hhsuite=$(which hhblits);
path_to_CCMpred=$(which ccmpred);

# reformat msa and convert it to psc for CCMPred
${path_to_hhsuite%/bin/hhblits}/scripts/reformat.pl $prefix\_ecnet.a3m $prefix\_ecnet.fas -r
python ${path_to_CCMpred%/bin/ccmpred}/scripts/convert_alignment.py $prefix\_ecnet.fas fasta $prefix\_ecnet.psc

# run ccmpred for local contacts prediction
# edited by Yinying according to the ccmpred help message.
ccmpred $prefix\_ecnet.psc $prefix\_ecnet.mat -r $prefix\_ecnet.braw

# extract variant and related fitness as a tsv table
python ../tools/transform_fitness_data_to_tsv.py ./data/P450_experi_data_encoded.csv 'variants' '11H-Cuol' -

# use run_example.py to predict the fitness data
CUDA_VISIBLE_DEVICES=0 python ../scripts/run_example.py \
        --train data/P450_experi_data_encoded.tsv \
        --fasta $input_fasta \
        --local_feature $prefix\_ecnet.braw \
        --output_dir ./output \
        --save_prediction \
        --save_checkpoint

