FROM rust AS builder
RUN rustup target add x86_64-unknown-linux-musl

WORKDIR /usr/src/serv

# cache deps by compiling a dummy file
COPY serv/dummy.rs .
COPY serv/Cargo.toml .
COPY serv/Cargo.lock .
RUN sed -i 's#src/main.rs#dummy.rs#' Cargo.toml
RUN cargo build --release --target=x86_64-unknown-linux-musl
RUN sed -i 's#dummy.rs#src/main.rs#' Cargo.toml

# now copy the real source in and build
COPY serv/src ./src
RUN cargo build --release --target=x86_64-unknown-linux-musl
RUN strip target/x86_64-unknown-linux-musl/release/serv

FROM scratch
COPY --from=builder /usr/src/serv/target/x86_64-unknown-linux-musl/release/serv /bin/serv
EXPOSE 3030
CMD ["/bin/serv"]
