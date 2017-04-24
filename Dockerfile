FROM bash:4.4
ADD entrypoint.sh /entrypoint.sh
ENV PATH /:$PATH
ENTRYPOINT ["entrypoint.sh"]
