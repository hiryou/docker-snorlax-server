FROM bde2020/hadoop-resourcemanager:master

MAINTAINER Long Nguyen <littlefinzer@gmail.com>

ENV SPARK_VERSION=2.4.5
ENV SPARK_LONG_VERSION=${SPARK_VERSION}-bin-without-hadoop
ENV SPARK_DOWNLOAD_URL https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_LONG_VERSION}.tgz

RUN set -x \
    && curl -fSL "${SPARK_DOWNLOAD_URL}" -o /tmp/spark.tgz \
    #&& curl -fSL "${SPARK_DOWNLOAD_URL}.asc" -o /tmp/spark.tgz.asc \
    #&& gpg --verify /tmp/spark.tgz.asc \
    && tar -xvf /tmp/spark.tgz -C /opt/ \
    && rm /tmp/spark.tgz* \
    && cd /

ENV SPARK_HOME=/opt/spark-${SPARK_LONG_VERSION}
ENV USER=root
ENV PATH ${SPARK_HOME}/bin/:$PATH

# Fix the value of PYTHONHASHSEED
# Note: this is needed when you use Python 3.3 or greater
ENV PYTHONHASHSEED 1

ADD run.sh /run.sh
RUN chmod a+x /run.sh

EXPOSE 8088

CMD ["/run.sh"]