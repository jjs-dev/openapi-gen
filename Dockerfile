FROM ubuntu:focal as paperclip
RUN apt-get update -y && apt-get install --no-install-recommends -y \
  curl git ca-certificates build-essential libssl-dev pkg-config
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | \
  sh /dev/stdin -y --default-toolchain nightly --quiet --profile minimal
ENV PATH /root/.cargo/bin:${PATH}
WORKDIR /src
RUN git clone --depth 1 --single-branch --branch custom-client \
  https://github.com/mikailbag/paperclip .
RUN mkdir /out
RUN cargo build -Zunstable-options --out-dir /out --features codegen,cli,v2 --release


FROM node:14.3.0
WORKDIR /entry
RUN npm install -g api-spec-converter
COPY main.sh main.sh
COPY --from=paperclip /out/paperclip /
VOLUME [ "/in", "/out" ]
ENTRYPOINT ["bash", "/entry/main.sh"]
