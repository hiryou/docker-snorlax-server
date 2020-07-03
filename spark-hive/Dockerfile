#FROM bde2020/hadoop-base:master
FROM bde2020/hive:2.3.2-postgresql-metastore

MAINTAINER Long Nguyen <littlefinzer@gmail.com>

ENV SPARK_VERSION=2.4.5
ENV SPARK_LONG_VERSION=${SPARK_VERSION}-bin-without-hadoop
ENV SPARK_DOWNLOAD_URL https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_LONG_VERSION}.tgz

RUN apt-get update \
    && apt-get install -y \
        python python3 \
    && curl -fSL "${SPARK_DOWNLOAD_URL}" -o /tmp/spark.tgz \
    #&& curl -fSL "${SPARK_DOWNLOAD_URL}.asc" -o /tmp/spark.tgz.asc \
    #&& gpg --verify /tmp/spark.tgz.asc \
    && tar -xvf /tmp/spark.tgz -C /opt/ \
    && rm /tmp/spark.tgz* \
    && cd /

# Integrate spark with hive
RUN cp ${HIVE_HOME}/conf/hive-site.xml ${SPARK_HOME}/conf/

# Spark variables
# See more http://blog.ditullio.fr/2015/10/24/mini-cluster-part-iii-hadoop-spark-installation/#Installing_Spark
ENV YARN_CONF_DIR=${HADOOP_HOME}/etc/hadoop
ENV SPARK_HOME=/opt/spark-${SPARK_LONG_VERSION}
ENV USER=root
ENV PATH ${HIVE_HOME}/bin:${SPARK_HOME}/bin/:$PATH

# Set python to used for pyspark
ENV PYSPARK_PYTHON="python3"

# Fix exception when doing spark-submit or pyspark: java.lang.NoClassDefFoundError: org/slf4j/Logger
# https://stackoverflow.com/questions/32547832/error-to-start-pre-built-spark-master-when-slf4j-is-not-installed
#export SPARK_DIST_CLASSPATH=$(hadoop classpath)
ENV SPARK_DIST_CLASSPATH="/etc/hadoop:$HADOOP_HOME/share/hadoop/common/lib/*:$HADOOP_HOME/share/hadoop/common/*:$HADOOP_HOME/share/hadoop/hdfs:$HADOOP_HOME/share/hadoop/hdfs/lib/*:$HADOOP_HOME/share/hadoop/hdfs/*:$HADOOP_HOME/share/hadoop/mapreduce/lib/*:$HADOOP_HOME/share/hadoop/mapreduce/*:$HADOOP_HOME/share/hadoop/yarn:$HADOOP_HOME/share/hadoop/yarn/lib/*:$HADOOP_HOME/share/hadoop/yarn/*"
ENV SPARK_DIST_CLASSPATH=${HIVE_HOME}/lib/:${SPARK_DIST_CLASSPATH}

# Fix the value of PYTHONHASHSEED
# Note: this is needed when you use Python 3.3 or greater
ENV PYTHONHASHSEED 1

ADD run.sh /run.sh
RUN chmod a+x /run.sh

EXPOSE 8088

CMD ["/run.sh"]
