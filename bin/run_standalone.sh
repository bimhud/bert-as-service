#!/bin/bash

working_dir='/home/ec2-user/bert-as-service'

#create folder if not available
mkdir ${working_dir} &
mkdir ${working_dir}/tmp &

#download bert-large model
cd ${working_dir}
wget -c https://storage.googleapis.com/bert_models/2018_10_18/uncased_L-24_H-1024_A-16.zip
unzip  uncased_L-24_H-1024_A-16.zip -d ${working_dir}


#create conda environment
conda create -n bert-as-service python=3.7 -y 
source activate bert-as-service


#install bert-as-service
cd ${working_dir}
git clone https://github.com/bimhud/bert-as-service.git
cd bert-as-service/server
pip install bert-serving-server
conda install tensorflow -y -c conda-forge

export ZEROMQ_SOCK_TMP_DIR=${working_dir}/tmp
bert-serving-start -model_dir ${working_dir}/uncased_L-24_H-1024_A-16 -num_worker=1 \
 -cpu -graph_tmp_dir ${working_dir}/tmp \
 -max_seq_len 15 \
 -max_batch_size 1024 \
 -pooling_layer -1
