ARG IMAGE=containers.intersystems.com/intersystems/iris-community:latest-em
FROM $IMAGE
USER root
WORKDIR /opt/irisbuild
RUN chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/irisbuild

USER ${ISC_PACKAGE_MGRUSER}

COPY src ./src
COPY data ./data
COPY iris.script ./iris.script
COPY requirements.txt ./requirements.txt

USER root
RUN mkdir -p /opt/irisbuild/src/app/model_cache \
    && chown -R ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/irisbuild/src/app

ENV PATH="/home/irisowner/.local/bin:${PATH}"
ENV SENTENCE_TRANSFORMERS_HOME=/opt/irisbuild/src/app/model_cache

RUN pip install --no-cache-dir \
    --ignore-installed \
    --extra-index-url https://download.pytorch.org/whl/cpu \
    --break-system-packages -r requirements.txt

RUN python3 /opt/irisbuild/src/web/download_model.py

USER ${ISC_PACKAGE_MGRUSER}

RUN iris start IRIS \
    && iris session IRIS < iris.script \
    && iris stop IRIS quietly 

# Puerto que expone Flask
EXPOSE 5000

# Variables de entorno
ENV PORT=5000
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1