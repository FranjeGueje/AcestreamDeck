#! /bin/bash

##############################################################################################################################################################
# AUTOR: Paco Guerrero <fjgj1@hotmail.com> - FranjeGueje
# LICENSE of file: MIT (haz con él lo que quieras, pero cítame)
# ABOUT: Utiliza un Ace Stream Engine externo y un reproductor que soporte Ace Stream externo y automatiza la reproducción
#        Use an external Ace Stream Engine and a external player that supports Ace Stream, and automate playback.
# PARAMETERS:
#   $1: acestream://id  --> enlace acestream a reproduccir
#       install         --> instala el enlace desktop
#       uninstall       --> desinstala la app desktop
# SALIDAS/EXITs:
#   0: Todo correcto, llegamos al final. All correct, we have reached the end.
#
##############################################################################################################################################################
ACEHOME=$(dirname "$(realpath "$0")")

##############################################################################################################################################################
#! ACEPLAYER - MEDIA PLAYER
#        Command or application to play the video. The video file will be a new random file in /tmp with extension m3u
# Examples:
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
##############################################################################################################################################################
ACEPLAYER="xdg-open"

##############################################################################################################################################################
#! ACEENGINE - ACESSTREAM ENGINE OPTIONS
#        Command to run the acestream engine with its parameters.
# Examples:
# ACEENGINE="$ACEHOME/Acestreamengine-x86_64.AppImage --client-console"
#   Acestream engine with the default options.
# ACEENGINE="$ACEHOME/Acestreamengine-x86_64.AppImage --client-console --upload-limit 1000 --live-cache-type memory"
#   Some recomended parameters
# IMPORTANT:
#   You can get all parameters with "./Acestreamengine-x86_64.AppImage --help"
##############################################################################################################################################################
ACEENGINE="$ACEHOME/Acestreamengine-x86_64.AppImage --client-console --upload-limit 1000 --live-cache-type memory"

##############################################################################################################################################################
#! ACEURL - ACESSTREAM ENGINE URL
#        Url to open the acestream engine.
# Examples:
# ACEURL="http://127.0.0.1:6878/ace/getstream?content_id="
#   URL with the default options.
# ACEURL="http://127.0.0.1:8888/ace/getstream?content_id="
#   URL with the port 8888 in acestream engine options
##############################################################################################################################################################
ACEURL="http://127.0.0.1:6878/ace/getstream?content_id="


##############################################################################################################################################################
#! Don't edit this part
##############################################################################################################################################################
#########################################
##      VARIABLES GLOBALES
NOMBRE=AcestreamDeck
VERSION=6
#########################################
##      FUNCIONES

# Función para establecer el lenguaje
function fLanguage() {

    # establecemos los textos según idioma
    case "$LANG" in
    es_ES.UTF-8)
        TEXTOBIENVENIDA="Bienvenido a $NOMBRE.\nPrograma para facilitar la ejecución de enlaces de AceStream.\n\nEl asistente se mostrará a continuación. Siga las instrucciones.\n"
        TEXTOSALIDA="Gracias por usar $NOMBRE.\n¡Saludos!"
        TEXTOACEPTAR="Aceptar"
        TEXTOCANCELAR="Cancelar"
        TEXT_TEXT="Selecciona una opción:"
        TEXTACCION="Acción"
        TEXTINSTALL="Instalar"
        TEXTUNINSTALL="Desinstalar"
        TEXTPLAY="Reproducir Enlace"
        TEXTSALIR="Salir"
        TEXTINSTALADO="¡Instalado!"
        TEXTUNINSTALADO="¡Desinstalado!"
        TEXTLINK="Introduce el enlace acestrem.\nDebe de comenzar por acestream://"
        TEXTUSODE="Uso de"
        TEXTHELP="Esta ayuda."
        TEXTHELPINS="crea un acceso a la aplicación en nuestro escritorio."
        TEXTHELPUNI="desinstala $NOMBRE como aplicación en nuestro escritorio."
        TEXTHELPPLAY="reproduce el contenido indicado desde Acestream."
        ;;
    *)
        TEXTOBIENVENIDA="Welcome to $NOMBRE.\nProgram to facilitate the execution of AceStream links.\n\nThe wizard will be displayed next. Follow the instructions\n"
        TEXTOSALIDA="Thank you for using $NOMBRE.\nGreetings!"
        TEXTOACEPTAR="OK"
        TEXTOCANCELAR="Cancel"
        TEXT_TEXT="Select an option:"
        TEXTACCION="Action"
        TEXTINSTALL="Install"
        TEXTUNINSTALL="Uninstall"
        TEXTPLAY="Play link"
        TEXTSALIR="Exit"
        TEXTINSTALADO="Installed!"
        TEXTUNINSTALADO="Uninstalled!"
        TEXTLINK="Enter the Acestream link.\nMust begin with acestream://"
        TEXTUSODE="Usage of"
        TEXTHELP="This help."
        TEXTHELPINS="creates the access as an application on our desktop."
        TEXTHELPUNI="uninstalls $NOMBRE as an application on our desktop."
        TEXTHELPPLAY="plays the indicated content from Acestream."
        ;;
    esac
}

# Función para todas las comprobaciones iniciales
function menu() {
        
    # Función de bienvenida
    zenity --title="$NOMBRE-v$VERSION" --window-icon=icon.png --timeout 6 --info --width=250 --text="$TEXTOBIENVENIDA" 2>/dev/null

    RESULTADO=$(zenity --list \
                    --title="$NOMBRE-v$VERSION" --window-icon=icon.png \
                    --height=230 \
                    --width=300 \
                    --ok-label="$TEXTOACEPTAR" \
                    --cancel-label="$TEXTOCANCELAR" \
                    --text="$TEXT_TEXT" \
                    --radiolist \
                    --column="ID" \
                    --column="$TEXTACCION" \
                    1 "$TEXTINSTALL" 2 "$TEXTUNINSTALL" 3 "$TEXTPLAY" 4 "$TEXTSALIR")
    case "$RESULTADO" in
        "$TEXTINSTALL")
            $0 install && zenity --timeout 4 --info --title="$NOMBRE-v$VERSION" --window-icon=icon.png --text="$TEXTINSTALADO" 2>/dev/null            
            ;;
        "$TEXTUNINSTALL")
            $0 uninstall && zenity --timeout 4 --info --title="$NOMBRE-v$VERSION" --window-icon=icon.png --text="$TEXTUNINSTALADO" 2>/dev/null 
            ;;
        "$TEXTPLAY")
            datos=$(zenity --forms \
               --title="$NOMBRE-v$VERSION" --window-icon=icon.png \
               --text="$TEXTLINK" \
               --add-entry="acestream://")
            ans=$?
            if [ $ans -eq 0 ];then
                datos="${datos/acestream:\/\//}"
                $0 "acestream://$datos"
            fi
        ;;
    esac
    
    zenity --timeout 4 --info --title="$NOMBRE-v$VERSION" --window-icon=icon.png \
        --width=250 --text="$TEXTOSALIDA" 2>/dev/null
    exit 0
}

# Mostrar ayuda
function showhelp() {
    echo -e "$TEXTUSODE $NOMBRE:\n$0\t[ install | uninstall | acestream://content_id | -h |--help ]"
    echo -e "\t-h|--help\t\t-> $TEXTHELP"
    echo -e "\tinstall\t\t\t-> $TEXTHELPINS"
    echo -e "\tuninstall\t\t-> $TEXTHELPUNI"
    echo -e "\tacestream://content_id\t-> $TEXTHELPPLAY"
}

#!#######################################
#!              BEGIN
#!#######################################
# Establecemos lenguaje
fLanguage

case "$1" in
    install)
        echo -ne "[Desktop Entry]\nType=Application\nName=Start AceStream-web\nExec=$(realpath "$0") %U\nIcon=$ACEHOME/icon.png\nCategories=GNOME;GTK;Network;\nStartupNotify=true\nTerminal=true\n" > \
        "$HOME/.local/share/applications/acestream-web.desktop"
        exit 0
    ;;
    uninstall)
        rm "$HOME/.local/share/applications/acestream-web.desktop"
        exit 0
    ;;
    "acestream://"*)
        ########### PRE EJECUCIÓN ############
        [ -d "$ACEHOME/Acestreamengine-x86_64.AppImage.home" ] && rm -Rf "$ACEHOME/Acestreamengine-x86_64.AppImage.home"
        mkdir -p "$ACEHOME/Acestreamengine-x86_64.AppImage.home"
        seed="${1/acestream:\/\//}"
        m3u_file=$(mktemp).m3u
        echo "$ACEURL""$seed" > "$m3u_file"
        #######################################

        ########### EJECUTAMOS ENGINE ################
        eval "$ACEENGINE" > "$0.log" 2>&1 &
        echo -e "[INFO] Running Acestream Engine on Linux. Please, wait ..." &
        t=0;
        while [ "$t" -ne 10 ]; do
            if grep "|started" < "$0.log" >/dev/null; then
                echo -e "[INFO] Acestream Engine started"
                break
            fi
            sleep 1
            ((t++))
        done
        ########### EJECUTAMOS PLAYER ################
        echo -e "[INFO] Launching the player..."
        eval "$ACEPLAYER" "$m3u_file"
        #######################################

        ########### POST EJECUCIÓN ############
        sleep 3 #Esperamos 1seg
        #Borramos caches
        [ -d "$ACEHOME/Acestreamengine-x86_64.AppImage.home" ] && rm -Rf "$ACEHOME/Acestreamengine-x86_64.AppImage.home"
        #######################################
    ;;
    -h|--help)
        showhelp
        exit 0
    ;;
    *)
        if ! zenity --help >/dev/null 2>/dev/null;then
            showhelp
        else
            menu
        fi
    ;;
esac
exit 0
