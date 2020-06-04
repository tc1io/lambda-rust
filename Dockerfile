# https://github.com/lambci/docker-lambda#documentation
FROM lambci/lambda:build-provided
ARG RUST_VERSION
RUN yum install -y jq
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --profile minimal --default-toolchain $RUST_VERSION
RUN cp /root/.cargo/bin/rustup /usr/local/bin
RUN rustup toolchain install nightly --allow-downgrade --profile minimal --component clippy
RUN rustup default nightly
ADD build.sh /usr/local/bin/
VOLUME ["/code"]
WORKDIR /code
ENTRYPOINT ["/usr/local/bin/build.sh"]
