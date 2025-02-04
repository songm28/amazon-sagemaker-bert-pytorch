# Copyright 2017-2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"). You
# may not use this file except in compliance with the License. A copy of
# the License is located at
#
#     http://aws.amazon.com/apache2.0/
#
# or in the "license" file accompanying this file. This file is
# distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
# ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

# For more information on creating a Dockerfile
# https://docs.docker.com/compose/gettingstarted/#step-2-create-a-dockerfile
# https://github.com/awslabs/amazon-sagemaker-examples/master/advanced_functionality/pytorch_extending_our_containers/pytorch_extending_our_containers.ipynb
# SageMaker PyTorch image
# FROM 520713654638.dkr.ecr.us-west-2.amazonaws.com/sagemaker-pytorch:0.4.0-cpu-py3
FROM 763104351884.dkr.ecr.us-east-1.amazonaws.com/pytorch-training:1.5.0-cpu-py36-ubuntu16.04

ENV PATH="/opt/ml/code:${PATH}"

# /opt/ml and all subdirectories are utilized by SageMaker, we use the /code subdirectory to store our user code.
COPY ./code /opt/ml/code

RUN mkdir -p /opt/ml/model && \
    ls -l /opt/ml/code && \
    pip install -r /opt/ml/code/requirements.txt 

# this environment variable is used by the SageMaker PyTorch container to determine our user code directory.
ENV SAGEMAKER_SUBMIT_DIRECTORY /opt/ml/code

# this environment variable is used by the SageMaker PyTorch container to determine our program entry point
# for training and serving.
# For more information: https://github.com/aws/sagemaker-pytorch-container
ENV SAGEMAKER_PROGRAM train_deploy.py

# ENV var must align with the entrypoint script
ENV SM_HOSTS='["algo-1","algo-2"]'
ENV SM_CURRENT_HOST=algo-1
ENV SM_MODEL_DIR=/opt/ml/model
#ENV SM_CHANNEL_TRAINING=/opt/ml/input/data/training
#ENV SM_CHANNEL_TESTING=/opt/ml/input/data/testing
ENV SM_CHANNEL_TRAINING=s3://sagemaker-us-east-1-420737321821/sagemaker/ivy-demo-pytorch-bert/data/input
ENV SM_CHANNEL_TESTING=s3://sagemaker-us-east-1-420737321821/sagemaker/ivy-demo-pytorch-bert/data/input
ENV SM_NUM_GPUS=0
