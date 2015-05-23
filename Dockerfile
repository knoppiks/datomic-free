FROM java:openjdk-7
MAINTAINER Alexander Kiel <alexanderkiel@gmx.net>

ENV DATOMIC_VERSION 0.9.5173

RUN curl --progress-bar --location \
  --url "https://my.datomic.com/downloads/free/${DATOMIC_VERSION}" \
  --output /tmp/datomic.zip

RUN unzip /tmp/datomic.zip
RUN rm /tmp/datomic.zip

WORKDIR datomic-free-${DATOMIC_VERSION}

RUN cp config/samples/free-transactor-template.properties transactor.properties

RUN sed "s/host=localhost/host=0.0.0.0/" -i transactor.properties

RUN mkdir /data
RUN sed "s/# data-dir=data/data-dir=\/data/" -i transactor.properties
VOLUME /data

RUN mkdir /log
RUN sed "s/# log-dir=log/log-dir=\/log/" -i transactor.properties
VOLUME /log

ADD start.sh ./
RUN chmod +x start.sh

EXPOSE 4334 4335 4336

CMD ["./start.sh"]