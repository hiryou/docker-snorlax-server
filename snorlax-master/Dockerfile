FROM snorlax/hadoop-base:master

MAINTAINER Long Nguyen <littlefinzer@gmail.com>

ENV HIVE_VERSION 2.3.6
ENV HIVE_HOME /opt/hive
ENV PATH ${HIVE_HOME}/bin:$PATH

ENV SPARK_VERSION=2.4.5
ENV SPARK_LONG_VERSION=${SPARK_VERSION}-bin-without-hadoop
ENV SPARK_DOWNLOAD_URL https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_LONG_VERSION}.tgz

WORKDIR /opt

#Install Hive and PostgreSQL JDBC
RUN apt-get update && apt-get install -y wget procps && \
	wget http://archive.apache.org/dist/hive/hive-${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz && \
	tar -xzvf apache-hive-${HIVE_VERSION}-bin.tar.gz && \
	mv apache-hive-${HIVE_VERSION}-bin hive && \
	wget https://jdbc.postgresql.org/download/postgresql-9.4.1209.jre7.jar -O ${HIVE_HOME}/lib/postgresql-jdbc.jar && \
	rm apache-hive-${HIVE_VERSION}-bin.tar.gz && \
	apt-get --purge remove -y wget && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

WORKDIR /
RUN apt-get update \
    && apt-get install -y \
        python python3 \
    && curl -fSL "${SPARK_DOWNLOAD_URL}" -o /tmp/spark.tgz \
    #&& curl -fSL "${SPARK_DOWNLOAD_URL}.asc" -o /tmp/spark.tgz.asc \
    #&& gpg --verify /tmp/spark.tgz.asc \
    && tar -xvf /tmp/spark.tgz -C /opt/ \
    && mv /opt/spark-${SPARK_LONG_VERSION} /opt/spark \
    && rm /tmp/spark.tgz* \
    && cd /


#Spark should be compiled with Hive to be able to use it
#hive-site.xml should be copied to ${SPARK_HOME}/conf folder

#Custom configuration goes here
ADD conf/hive-site.xml ${HIVE_HOME}/conf
ADD conf/beeline-log4j2.properties ${HIVE_HOME}/conf
ADD conf/hive-env.sh ${HIVE_HOME}/conf
ADD conf/hive-exec-log4j2.properties ${HIVE_HOME}/conf
ADD conf/hive-log4j2.properties ${HIVE_HOME}/conf
ADD conf/ivysettings.xml ${HIVE_HOME}/conf
ADD conf/llap-daemon-log4j2.properties ${HIVE_HOME}/conf

# Spark variables
# See more http://blog.ditullio.fr/2015/10/24/mini-cluster-part-iii-hadoop-spark-installation/#Installing_Spark
ENV YARN_CONF_DIR=${HADOOP_HOME}/etc/hadoop
ENV SPARK_HOME=/opt/spark
ENV USER=root
ENV PATH ${HIVE_HOME}/bin:${SPARK_HOME}/bin/:$PATH

# integrate hive into spark
ADD conf/hive-site.xml ${SPARK_HOME}/conf

# Set python to used for pyspark
ENV PYSPARK_PYTHON="python3"

# Fix exception when doing spark-submit or pyspark: java.lang.NoClassDefFoundError: org/slf4j/Logger
# https://stackoverflow.com/questions/32547832/error-to-start-pre-built-spark-master-when-slf4j-is-not-installed
#export SPARK_DIST_CLASSPATH=$(hadoop classpath)
ENV SPARK_DIST_CLASSPATH="/etc/hadoop:/opt/hadoop/share/hadoop/common/lib/*:/opt/hadoop/share/hadoop/common/*:/opt/hadoop/share/hadoop/hdfs:/opt/hadoop/share/hadoop/hdfs/lib/*:/opt/hadoop/share/hadoop/hdfs/*:/opt/hadoop/share/hadoop/yarn/lib/*:/opt/hadoop/share/hadoop/yarn/*:/opt/hadoop/share/hadoop/mapreduce/lib/*:/opt/hadoop/share/hadoop/mapreduce/*:/usr/lib/jvm/java-8-openjdk-amd64//lib/tools.jar:/opt/hadoop/contrib/capacity-scheduler/*.jar"
#ENV SPARK_DIST_CLASSPATH=${HIVE_HOME}/lib/:${SPARK_DIST_CLASSPATH}

# Fix the value of PYTHONHASHSEED
# Note: this is needed when you use Python 3.3 or greater
ENV PYTHONHASHSEED 1

COPY startup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/startup.sh

COPY entryhive.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entryhive.sh

EXPOSE 10000
EXPOSE 10002

ENTRYPOINT ["entryhive.sh"]
CMD startup.sh
