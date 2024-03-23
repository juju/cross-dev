ARG BASE_IMAGE
FROM $BASE_IMAGE

ADD setup-toolchain.sh .
RUN chmod +x setup-toolchain.sh && ./setup-toolchain.sh && rm setup-toolchain.sh

ARG GOVERSION
ADD install-go.sh .
RUN chmod +x install-go.sh && ./install-go.sh && rm install-go.sh
