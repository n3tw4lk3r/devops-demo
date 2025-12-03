FROM rust:1.78-slim AS builder

WORKDIR /app

COPY Cargo.toml Cargo.lock ./
RUN mkdir -p src && echo 'fn main() {}' > src/main.rs
RUN cargo build --release

RUN rm -rf src
RUN rm -f target/release/deps/devops_demo*
COPY src ./src
RUN cargo build --release
RUN strip target/release/devops-demo

FROM debian:bookworm-slim

ARG USER_ID=1000
ARG GROUP_ID=1000

RUN groupadd -g ${GROUP_ID} app && \
    useradd -l -u ${USER_ID} -g app -s /bin/false app

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

USER app
WORKDIR /app

COPY --from=builder --chown=app:app /app/target/release/devops-demo .

HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
    CMD ["./devops-demo", "healthcheck"] || exit 1

EXPOSE 3000
CMD ["./devops-demo"]
