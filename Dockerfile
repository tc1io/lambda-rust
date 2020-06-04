# https://github.com/lambci/docker-lambda#documentation
FROM softprops/lambda-rust
RUN cp /root/.cargo/bin/rustup /usr/local/bin
RUN rustup toolchain install nightly --allow-downgrade --profile minimal --component clippy
RUN rustup default nightly
