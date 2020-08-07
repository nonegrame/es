FROM elasticsearch:7.7.1

RUN ./bin/elasticsearch-plugin install -b https://github.com/medcl/elasticsearch-analysis-ik/releases/download/v7.7.1/elasticsearch-analysis-ik-7.7.1.zip

RUN mkdir -p /usr/share/elasticsearch/config/analysis-ik/custom

COPY ./dict/custom-dict.txt /usr/share/elasticsearch/config/analysis-ik/custom/custom-dict.dic
COPY ./dict/ptt-dict.txt /usr/share/elasticsearch/config/analysis-ik/custom/ptt-dict.dic
COPY ./dict/judicial-dict.txt /usr/share/elasticsearch/config/analysis-ik/custom/judicial-dict.dic

COPY ./dict/synonym.txt /usr/share/elasticsearch/config/analysis/synonym.txt

COPY IKAnalyzer.cfg.xml /usr/share/elasticsearch/config/analysis-ik/IKAnalyzer.cfg.xml

USER elasticsearch