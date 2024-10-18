FROM ubuntu:latest
RUN apt update -y
RUN apt install python3-pip git curl wget node-hawk node-minimist -y
RUN pip3 --no-cache-dir install --upgrade awscli boto3
COPY ./twistcli /usr/local/bin
ENTRYPOINT ["twistcli"]
