FROM ubuntu:14.04

RUN apt-get update \
  && sudo apt-get install -y software-properties-common \
  && add-apt-repository ppa:george-edison55/cmake-3.x \
  && apt-get update \
  && apt-get install -y \
                build-essential \
                cmake \
                git \
                libpng-dev \
                libjpeg-dev \
                libtiff-dev \
                libxxf86vm1 \
                libxxf86vm-dev \
                libxi-dev \
                libxrandr-dev \
                graphviz

# Pin to 1.4
RUN git clone -b v1.4 --recursive https://github.com/openMVG/openMVG.git

# Adds Mavic Pro sensor to sensor database 
# (workaround until merge of https://github.com/openMVG/openMVG/pull/763)
RUN echo 'FC220;6.17' >> ./openMVG/src/openMVG/exif/sensor_width_database/sensor_width_camera_database.txt

RUN mkdir /openMVG_Build
WORKDIR /openMVG_Build
RUN cmake -DCMAKE_BUILD_TYPE=RELEASE . /openMVG/src/
RUN make

ENV PATH=/openMVG_Build/Linux-x86_64-RELEASE/:$PATH

RUN mkdir /work
WORKDIR /work