  
FROM mono

LABEL Name=docker-steamcmd Version=1.0.0 Maintainer="Dave Jansen - Pretty Basic"

## Defaults
# Note: Query Port cannot be between 27020 and 27050 due to Steam using those ports.
ENV \
  PORT_STEAM=27015 \
  STEAMCMD_URL="https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" \
  USER_STEAM_ID=1000 \
  DIR_STEAMCMD=/opt/steamcmd \
  DIR_GAME=/opt/game \
  DIR_USER=/opt/user \
  DIR_APP=/opt/app
  GAME_ID=740250 \
  BETA=headless-client \
  BETA_PASSWORD=GETMEFROMDISCORD

# Start by updating and installing required packages
RUN set -ex; \
  apt-get -y update; \
  apt-get -y upgrade; \
  apt-get install -y curl lib32gcc1; \
  rm -rf /var/lib/{apt,dpkg,cache,log}/;

# Create a user and usergroup for Steam, and adjust open file limitations.
# This is required for certain games, so let's set it by default
RUN \
  ulimit -n 100000; \
  set -ex; \
  addgroup \
    -gid ${USER_STEAM_ID} \
    steam; \
  adduser \
	  --disabled-login \
	  --shell /bin/bash \
  	--gecos "" \
    --gid ${USER_STEAM_ID} \
    --uid ${USER_STEAM_ID} \
	  steam; \ 
  mkdir -p ${DIR_STEAMCMD} ${DIR_GAME} ${DIR_USER} ${DIR_APP}; \
  cd $DIR_STEAMCMD; \
  curl -sqL ${STEAMCMD_URL} | tar zxfv -; \
  chown -R steam:steam ${DIR_STEAMCMD} ${DIR_GAME} ${DIR_USER} ${DIR_APP};

# Adjust open file limitations
# TODO: Check if we need all three methods or if one of them is enough.
# RUN set -ex; \
# 	ulimit -n 100000; \
# 	sysctl -w fs.file-max=100000; \
# 	echo "session required pam_limits.so" >> /etc/pam.d/common-session;


# Make sure everything is run as the Steam user from the steam dir
USER steam
WORKDIR ${DIR_STEAMCMD}

# Announce the default Steam ports
# Note: You should open game-specific port too.
EXPOSE ${PORT_STEAM}/udp

# Optional: Initial run with anonymous login
# Run SteamCMD to finalize installation — Disable this if you run this on something like Docker Hub as it will fail
RUN [ "./steamcmd.sh", "+@NoPromptForPassword 1", "+login anonymous",  "+quit" ]

RUN ./steamcmd.sh \
  -beta ${BETA} \
  -beatapassword ${BETA_PASSWORD} \
  +@NoPromptForPassword 1 \
  +login anonymous \
  +force_install_dir ${DIR_GAME} \
  +app_update ${GAME_ID} validate \
  +quit

CMD [ "mono",  "${DIR_GAME}/HeadlessClient/Neos.exe" ]