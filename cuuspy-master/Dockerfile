FROM docker.io/rust:1.78-alpine as chef
RUN apk add --no-cache alpine-sdk
RUN cargo install cargo-chef
WORKDIR /usr/src/cuuspy

FROM chef AS planner
COPY . .
RUN cargo chef prepare  --recipe-path recipe.json

FROM chef AS builder
COPY --from=planner /usr/src/cuuspy/recipe.json recipe.json
RUN cargo chef cook --release --recipe-path recipe.json
COPY . .
RUN cargo build --release --workspace

FROM docker.io/alpine:3.19
RUN apk add --no-cache sqlite
COPY --from=builder /usr/src/cuuspy/target/release/cuuspy /usr/local/bin/cuuspy
RUN mkdir /data
EXPOSE 3001
CMD ["cuuspy"]
