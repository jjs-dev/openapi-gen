FROM ubuntu:focal as paperclip
RUN apt-get update -y && apt-get install --no-install-recommends -y \
  curl git ca-certificates build-essential libssl-dev pkg-config
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | \
  sh /dev/stdin -y --default-toolchain nightly --quiet --profile minimal
ENV PATH /root/.cargo/bin:${PATH}
WORKDIR /src
RUN git clone --single-branch --branch all \
   https://github.com/mikailbag/paperclip .
RUN git checkout e75879de3e3eb939b7f6ad01f763c528c051d1fd
RUN mkdir /out
RUN cargo build -Zunstable-options --out-dir /out --features codegen,cli,v2 --release

FROM node:slim
WORKDIR /entry
RUN npm install -g api-spec-converter
RUN apt-get update -y && apt-get install -y libssl-dev
COPY main.sh main.sh
COPY --from=paperclip /out/paperclip /
VOLUME [ "/in", "/out" ]
ENTRYPOINT ["bash"]
CMD ["/entry/main.sh"]
