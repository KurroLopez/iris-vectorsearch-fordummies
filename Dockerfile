ARG IMAGE=containers.intersystems.com/intersystems/iris-community:latest-em
FROM $IMAGE
USER root
WORKDIR /opt/irisbuild
RUN chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/irisbuild

USER ${ISC_PACKAGE_MGRUSER}

COPY src src
COPY data data
COPY iris.script iris.script
COPY requirements.txt requirements.txt
RUN python3 -m venv .venv
RUN bash -c "source .venv/bin/activate && pip install -U -r requirements.txt"

RUN iris start IRIS \
    && iris session IRIS < iris.script \
    && iris stop IRIS quietly 