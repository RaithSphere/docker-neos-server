# SteamCMD with assumed game installation for Docker

Uses my [docker-steamcmd](https://github.com/hellodeibu/docker-steamcmd) image. This barebones image is handy if you want to immediately install a specific game using SteamCMD. Simply provide the STEAM_APP_ID environment variable and that's it.

Note: You probable want to use this image as a build stage for your game-specific image, so that you can do additional setup and configuration on top of a downloaded and ready to go game setup.
