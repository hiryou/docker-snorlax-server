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

COPY startup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/startup.sh

COPY entryhive.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entryhive.sh

EXPOSE 10000
EXPOSE 10002

ENTRYPOINT ["entryhive.sh"]
CMD startup.sh
