# Docker to run a Headless Neos Client

Based on: hellodeibu/docker-steamcmd

I have no idea how to stack container images appropriately to do this so i just made my own dockerfile... yay?

# Setup

1. Setup a steam account for hosting your sessions, it is recommended that you use a separate account from your main Steam Account.
2. On a regular desktop computer login with this new account and install NeosVR's standard main build, this sets up your new account's access to Neos
3. As the Headless client is in a closed Beta right now you'll need to get the $12 Neos Patreon Tier to obtain the headless-client beta password, as I can't share this.
4. Once you have the password you'll need to build a Docker image, I can't share a built image at this time. To build it run:
```
docker build \
-t probableprime/neos-server \
--build-arg USERNAME=<Steamusername> \
--build-arg PASSWORD=<SteamPassword> \
--build-arg BETA_PASSWORD=<BETAPASSWORD> \
.
```