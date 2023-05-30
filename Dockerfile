FROM nvidia/cuda:11.7.0-cudnn8-devel-ubuntu20.04 as base

ENV DEBIAN_FRONTEND="noninteractive"

RUN apt update && \
    apt install -y git vim wget unzip cmake

RUN apt install -y libpng-dev libjpeg-dev libopenexr-dev libtiff-dev libwebp-dev ffmpeg libsm6 libxext6

WORKDIR /opt/libs/

ARG OPENCV_VER=4.7.0

WORKDIR /opt/libs/
RUN wget -O opencv.zip https://github.com/opencv/opencv/archive/${OPENCV_VER}.zip 
RUN unzip opencv.zip && mv opencv-${OPENCV_VER} opencv
WORKDIR /opt/libs/opencv/build/
RUN cmake -DWITH_FFMPEG=on .. && make -j8

RUN apt install -y python3-pip
RUN pip3 install --upgrade pip && \
    pip3 install torch torchvision opencv-python pillow jupyter

RUN pip3 install jupyterthemes && jt -t onedork

ARG USER=user

RUN addgroup --gid 1000 ${USER}
RUN adduser --disabled-password --gecos '' --uid 1000 --gid 1000 ${USER}

USER ${USER}
