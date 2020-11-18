FROM debian:latest
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

ENV PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN apt-get update --fix-missing && apt-get install -y wget ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    git mercurial subversion \
    nodejs npm \
    default-jre

ENV JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"

RUN export JAVA_HOME

RUN apt-get -qq update && apt-get -qq -y install curl bzip2 \
    && curl -sSL https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -o /tmp/miniconda.sh \
    && bash /tmp/miniconda.sh -bfp /usr/local \
    && rm -rf /tmp/miniconda.sh \
    && conda install -y python=3.7 \
    && conda update conda \
    && apt-get -qq -y remove curl bzip2 \
    && apt-get -qq -y autoremove \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* /var/log/dpkg.log \
    && conda clean --all --yes



RUN conda install -y -v -c conda-forge boto3

RUN conda install jupyter -y --quiet
RUN mkdir /opt/notebooks

RUN conda install -c anaconda pandas numpy pandasql seaborn && \
    conda install -c conda-forge folium ijson koalas scipy matplotlib && \
    conda install -c intel scikit-learn

# RUN conda install -c anaconda pandas numpy dnspython pandasql psycopg2 && \
#     conda install -c conda-forge pyarrow kubernetes faker redis-py python-confluent-kafka sqlalchemy && \
#     conda install -c bioconda grep && \
#     conda install pymongo

#install data-science libaries
# RUN conda install -c anaconda seaborn scikit-learn tensorflow && \
#     conda install -c intel mkl && \
#     conda install -c conda-forge imbalanced-learn

# RUN pip3 install openshift confluent-kafka branca==0.3.0 folium==0.7.0 matplotlib presto-python-client

COPY spark-3.0.1-bin-hadoop3.2 /home/spark-3.0.0-bin-hadoop3.2
WORKDIR /home/spark-3.0.0-bin-hadoop3.2/python
RUN python3 setup.py sdist
RUN pip3 install -e .

ENV SPARK_HOME="/home/spark-3.0.0-bin-hadoop3.2"

# COPY jars/delta-core_2.11-0.5.0.jar             $SPARK_HOME/jars/delta-core_2.11-0.5.0.jar
# COPY jars/postgresql-42.2.5.jar                 $SPARK_HOME/jars/postgresql-42.2.5.jar
# COPY jars/delta-core_2.12-0.7.0.jar             $SPARK_HOME/jars/delta-core_2.12-0.7.0.jar

CMD [ "/bin/bash" ]