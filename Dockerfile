ARG IMAGE=intersystemsdc/irishealth-community
FROM $IMAGE
USER root
WORKDIR /opt/irisbuild
RUN chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/irisbuild

USER ${ISC_PACKAGE_MGRUSER}

COPY src src
COPY data data
COPY iris.script iris.script
COPY requirements.txt requirements.txt
RUN pip3 install -U -r requirements.txt

RUN iris start IRIS \
    && iris session IRIS < iris.script \
    && iris stop IRIS quietly 