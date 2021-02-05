FROM rust:alpine as builder

RUN apk add -qq libc-dev

WORKDIR /app

COPY Cargo.toml .

RUN mkdir src
RUN echo "#[cfg(test)] mod tests {#[test] fn it_works() {assert_eq!(2 + 2, 4);}}" > src/lib.rs
RUN RUSTFLAGS="-C target-cpu=native" cargo build --release
RUN rm -f target/release/deps/subdash*

COPY . .

RUN RUSTFLAGS="-C target-cpu=native" cargo build --release

FROM alpine:latest

ENV ROCKET_ADDRESS="0.0.0.0"

RUN addgroup -g 1000 pi
RUN adduser -D -s /bin/sh -u 1000 -G pi pi

WORKDIR /app

COPY --from=builder /app/target/release/runner /usr/local/bin/

RUN apk add -qq --no-cache tzdata && \
  cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
  apk del tzdata && \
  chown -R pi:pi .

USER pi

CMD runner
