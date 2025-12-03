FROM rust:1.78-slim as planner
WORKDIR /app
COPY Cargo.toml Cargo.lock .
RUN cargo install cargo-chef
RUN cargo chef prepare --recipe-path recipe.json

FROM rust:1.78-slim as cacher
WORKDIR /app
COPY --from=planner /app/recipe.json .
RUN cargo install cargo-chef
RUN cargo chef cook --release --recipe-path recipe.json

FROM rust:1.78-slim as builder
WORKDIR /app
COPY . .
COPY --from=cacher /app/target ./target
COPY --from=cacher /usr/local/cargo /usr/local/cargo
RUN cargo build --release
RUN strip target/release/devops-demo

FROM debian:bookworm-slim
RUN useradd -m -u 1000 app
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

USER app
WORKDIR /app
COPY --from=builder /app/target/release/devops-demo .

HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
    CMD ["./devops-demo", "healthcheck"] || exit 1

EXPOSE 3000
STOPSIGNAL SIGTERM

CMD ["./devops-demo"]
