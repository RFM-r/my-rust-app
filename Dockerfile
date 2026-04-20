FROM rust:1-slim AS builder
WORKDIR /app
COPY Cargo.toml Cargo.lock ./
RUN mkdir src && echo "fn main() {}" > src/main.rs
RUN cargo build --release && rm -f target/release/my-rust-app*
COPY src ./src
RUN cargo build --release
FROM debian:stable-slim
RUN useradd --create-home appuser
WORKDIR /home/appuser
COPY --from=builder /app/target/release/my-rust-app .
USER appuser
CMD ["./my-rust-app"]