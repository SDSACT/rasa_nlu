FROM python:3.6.1

ENV RASA_NLU_DOCKER="YES" \
    RASA_NLU_HOME=/app \
    RASA_NLU_PYTHON_PACKAGES=/usr/local/lib/python3.6/dist-packages

VOLUME ["${RASA_NLU_HOME}", "${RASA_NLU_PYTHON_PACKAGES}"]

# Run updates, install basics and cleanup
# - build-essential: Compile specific dependencies
# - git-core: Checkout git repos
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
  apt-utils \
  tar \
  make \
  gcc \
  build-essential \
  python3-pip \
  python-mecab \
  git-core && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR ${RASA_NLU_HOME}

COPY ./requirements.txt requirements.txt

# Split into pre-requirements, so as to allow for Docker build caching
RUN pip install $(tail -n +2 requirements.txt)
RUN pip install git+https://github.com/mit-nlp/MITIE.git#egg=mitie
RUN pip install -U scikit-learn scipy sklearn-crfsuite

COPY . ${RASA_NLU_HOME}
RUN python setup.py install

#RUN pip install git+https://github.com/SDSACT/rasa_nlu@development

WORKDIR /app/mecab-0.996-ko-0.9.2
RUN ./configure && make && make check && make install
RUN pip install mecab-python3

WORKDIR /app/mecab-ko-dic-2.0.1-20150920
RUN ./tools/add-userdic.sh
RUN cp -rf /app/mecab-ko-dic-2.0.1-20150920/user-gaplant.custom /app/mecab-ko-dic-2.0.1-20150920/user-gaplant.csv



RUN ls /app

EXPOSE 5000

WORKDIR /app
ENTRYPOINT ["./entrypoint.sh"]
CMD ["help"]
