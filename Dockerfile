FROM docker.elastic.co/elasticsearch/elasticsearch:8.9.0

ENV discovery.type=single-node
ENV bootstrap.memory_lock=true
ENV "ES_JAVA_OPTS=-Xms512m -Xmx512m"
ENV xpack.security.enabled=false

EXPOSE 9200 9300