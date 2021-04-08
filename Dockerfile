FROM minlag/mermaid-cli:8.9.2

COPY entrypoint.sh /entrypoint.sh

RUN apt-get install -y git

USER 1001

ENTRYPOINT ["/entrypoint.sh"]
