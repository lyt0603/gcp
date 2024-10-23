FROM ubuntu:latest

# Update and install packages in one layer, and clean up afterwards
RUN apt update -y && \
    apt install -y sudo python3 python3-pip git curl wget node-hawk node-minimist && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

# Install AWS CLI and Boto3
#RUN pip3 --no-cache-dir install --upgrade awscli boto3


# Make sure twistcli is executable

# Copy twistcli to the appropriate directory

RUN curl --progress-bar -L --header "authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJhY2Nlc3NLZXlJZCI6IjEzZjAwMGM3LTJhMDctNDc0ZC1hMWYzLWQ1NmE4OTZkNDhjYiIsInN1YiI6Imx5dEB1LWluZnJhLmNvbSIsImZpcnN0TG9naW4iOmZhbHNlLCJwcmlzbWFJZCI6IjEyMDAzNDE1MTE1MTQ5MTk5MzYiLCJpcEFkZHJlc3MiOiI1OS4xMC4xMzAuMTUxIiwiaXNzIjoiaHR0cHM6Ly9hcGkuanAucHJpc21hY2xvdWQuaW8iLCJyZXN0cmljdCI6MCwiaXNBY2Nlc3NLZXlMb2dpbiI6dHJ1ZSwidXNlclJvbGVUeXBlRGV0YWlscyI6eyJoYXNPbmx5UmVhZEFjY2VzcyI6ZmFsc2V9LCJ1c2VyUm9sZVR5cGVOYW1lIjoiU3lzdGVtIEFkbWluIiwiaXNTU09TZXNzaW9uIjpmYWxzZSwibGFzdExvZ2luVGltZSI6MTcyOTY1NjY0NzMwNywiYXVkIjoiaHR0cHM6Ly9hcGkuanAucHJpc21hY2xvdWQuaW8iLCJ1c2VyUm9sZVR5cGVJZCI6MSwiYXV0aC1tZXRob2QiOiJQQVNTV09SRCIsInNlbGVjdGVkQ3VzdG9tZXJOYW1lIjoiVS1JbmZyYSBDby4sIEx0ZC4gLSAzNjcyMTUxMzA4NTUxMTEzNTcwIiwic2Vzc2lvblRpbWVvdXQiOjYwLCJ1c2VyUm9sZUlkIjoiY2U5M2I1NTItOTYzNC00ZmE1LTgzNTgtNWIwM2ZmOGNiYjM1IiwiaGFzRGVmZW5kZXJQZXJtaXNzaW9ucyI6dHJ1ZSwiZXhwIjoxNzI5NjU4ODk4LCJpYXQiOjE3Mjk2NTgyOTgsInVzZXJuYW1lIjoibHl0QHUtaW5mcmEuY29tIiwidXNlclJvbGVOYW1lIjoiU3lzdGVtIEFkbWluIn0.f90McYvFjt00l-CZbvQ9EoDYb5-GHcCEE6cImRkwUI8" https://asia-northeast1.cloud.twistlock.com/japan-1167212692/api/v1/util/twistcli > twistcli; chmod a+x twistcli;

RUN mv ./twistcli /usr/local/bin/ 
RUN chmod +x /usr/local/bin/twistcli


RUN ls -l /usr/local/bin/twistcli

# Set entrypoint to twistcli
ENTRYPOINT ["/usr/local/bin/twistcli"]
