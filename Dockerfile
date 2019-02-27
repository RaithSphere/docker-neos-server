# These don't have to be replaced unless you, for example, 
# want to refer to a locally built version
ARG STEAM_IMG=docker-steamcmd
ARG STEAMCMD_TAG=latest

FROM ${STEAM_IMG}:${STEAMCMD_TAG}

# E.g. To install Counter Strike Source, run:
# docker build --build-arg GAME_ID=232330 --rm -t game-cssource:latest .
ARG GAME_ID

# Preserve the ID specified for future reference
ENV INSTALLED_GAME_ID=${GAME_ID}

USER steam

VOLUME [ ${DIR_GAME} ]

# Installs the game specified in GAME_ID
# Note: The game is installed in the DIR_GAME directory
# prepared by docker-steamcmd.

WORKDIR ${DIR_STEAMCMD}

# TODO: Check if it's worth using proper steam login
# not sure if Steam has rate limiting on anonymous accounts
RUN ./steamcmd.sh \
  +@NoPromptForPassword 1 \
  +login anonymous \
  +force_install_dir ${DIR_GAME} \
  +app_update ${GAME_ID} validate \
  +quit

CMD [ "./steamcmd.sh" ]

# CMD [ "./steamcmd.sh", \
#   "+@NoPromptForPassword 1", \
#   "+login anonymous", \
#   "+force_install_dir ${DIR_GAME}", \
#   "+app_update ${GAME_ID} validate", \
#   "+quit" \
#   ]