FROM ubuntu:latest

# Build arguments
ARG twistcli_TOKEN  # 빌드 시 전달받는 아규먼트

# Install dependencies and clean up
RUN apt update -y && \
    apt install -y sudo python3 python3-pip git curl wget node-hawk node-minimist && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

# Download twistcli binary using the twistcli_TOKEN
RUN curl --progress-bar -L \
    --header "authorization: Bearer ${twistcli_TOKEN}" \
    https://asia-northeast1.cloud.twistlock.com/japan-1167212692/api/v1/util/twistcli > twistcli; \
    chmod a+x twistcli

RUN mv ./twistcli /usr/local/bin/ 
RUN chmod +x /usr/local/bin/twistcli
RUN ls -l /usr/local/bin/twistcli 

# Set the entrypoint
ENTRYPOINT ["/usr/local/bin/twistcli"]
