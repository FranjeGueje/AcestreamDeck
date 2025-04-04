# AcestreamDeck
## What is it?
Acestream on Steam Deck (it is possible that it will work on other Linux) is a set of tools for running acestream links on our decks.

These tools are:

- AceStream engine --> service that uploads/downloads acestream content.
- <ins>an external</ins> Media Player --> it is necessary to have a media-player that runs video-stream (for example mpv or vlc).
- acestreamDeck.sh --> script that merges all of the above.

The acestream links can be used from the tool itself as well as from the web browser.

## Requisites
These are the requirements of this application:

- It's recommended "zenity" (already installed on Steam OS) for a user-friendly version.

## Installation
Download the releases zip and unzip it to a desired location, where you usually store your favorite programs.

## Configuration
### ACEPLAYER - MEDIA PLAYER
Edits the external player with the "ACEPLAYER" variable. Here are some examples:
```
# ACEPLAYER="vlc"
#   if you have vlc installed.
# ACEPLAYER="flatpak run --branch=stable --arch=x86_64 --command=/app/bin/vlc --file-forwarding org.videolan.VLC --fullscreen --started-from-file"
#   if you have vlc installed in flakpak mode. Important: you have to configure flatpak to run the video from "m3u" file in "/tmp"
# ACEPLAYER="mpv"
#   if you want run with your mpv application.
# ACEPLAYER="flatpak run --branch=stable --arch=x86_64 --command=mpv --file-forwarding io.mpv.Mpv --player-operation-mode=pseudo-gui"
#   if you have vlc installed in flakpak mode. Important: you have to configure flatpak to run the video from "m3u" file in "/tmp"
# ACEPLAYER="xdg-open"
#   if you want that your computer decide.
```

### ACEENGINE - ACESSTREAM ENGINE OPTIONS
Edits the parameters for the acestream engine command to run the acestream links. Examples:
```
# ACEENGINE="$ACEHOME/Acestreamengine-x86_64.AppImage --client-console"
#   Acestream engine with the default options.
# ACEENGINE="$ACEHOME/Acestreamengine-x86_64.AppImage --client-console --upload-limit 1000 --live-cache-type memory"
#   Some recomended parameters
# IMPORTANT:
#   You can get all parameters with "./Acestreamengine-x86_64.AppImage --help"
```

### ACEURL - ACESSTREAM ENGINE URL
Url to open the acestream engine.
```
# ACEURL="http://127.0.0.1:6878/ace/getstream?content_id="
#   URL with the default options.
# ACEURL="http://127.0.0.1:8888/ace/getstream?content_id="
#   URL with the port 8888 in acestream engine options
```

### Don't edit this part
ADVANCED. Do not edit from * Don't edit this part * onwards as it is the execution of the code. If you do, do it with your advanced knowledge.

## Running on user-friendly mode (with zenity)
Enter desktop mode. You must launch “acestreamDeck.sh” with double click or from commands. This is how it looks like:

![App](https://raw.githubusercontent.com/FranjeGueje/AcestreamDeck/refs/heads/master/App.png)

You can: install, uninstall, and play a link. "install" can to open acestream links from your desktop and web browser; "uninstall" undoes the above; the other action simply plays a acestream link without installing anything.

Once installed, you can open "acestream://xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" links through an app you install:

![Installed](https://raw.githubusercontent.com/FranjeGueje/AcestreamDeck/refs/heads/master/Instalado.png)

That is, if in a browser you want to open this application “AcestreamDeck”, clicking on a link “acestream://xxxxxxxxxxxxxxxxxxxxxxx” will show you a list to choose which application you want to run it with:

![Chose app](https://raw.githubusercontent.com/FranjeGueje/AcestreamDeck/refs/heads/master/Elegir_app.png)

There, look for the previous application (acestream-web) to play these links. You will have it. XD

Remember, you can play links with "play link" directly:

![Play link](https://raw.githubusercontent.com/FranjeGueje/AcestreamDeck/refs/heads/master/ReproducirEnlace.png)

## Running on console (without zenity)
Enter desktop mode. You can run the __acestreamDeck.sh__ command with --help to view the help:

```
Usage of AcestreamDeck:
./acestreamDeck.sh      [ install | uninstall | acestream://content_id | -h |--help ]
        -h|--help               -> This help.
        install                 -> creates the access as an application on our desktop.
        uninstall               -> uninstalls AcestreamDeck as an application on our desktop.
        acestream://content_id  -> plays the indicated content from Acestream.
```

"install" can to open acestream links from your desktop and web browser, creates the access as an application on our desktop. "uninstall" undoes the above; the other action (acestream://content_id) simply plays a acestream link without installing anything.

## Info about building
AcestreamDeck creates a AppImage for "acetream engine" from the "acestream.yml" file. You can to use "pkg2appimage.AppImage" to generate the AppImge file.

## Credits
- To my wife and daughter for putting up with me.
