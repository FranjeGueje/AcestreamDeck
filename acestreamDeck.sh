#! /bin/bash

##############################################################################################################################################################
# AUTOR: Paco Guerrero <fjgj1@hotmail.com> - FranjeGueje
# LICENSE of file: MIT (haz con él lo que quieras, pero cítame)
# ABOUT: Utiliza un Ace Stream Engine externo y un reproductor que soporte Ace Stream externo y automatiza la reproducción
#        Use an external Ace Stream Engine and a external player that supports Ace Stream, and automate playback.
# REQUISITOS DE ESTA VERSIÓN:
#   Mpv instalado a través de flatpak: https://flathub.org/es/apps/io.mpv.Mpv
# PARAMETERS:
#   $1: acestream://id  --> enlace acestream a reproduccir
#       install         --> instala el icono desktop
# SALIDAS/EXITs:
#   0: Todo correcto, llegamos al final. All correct, we have reached the end.
#   1: Sin el reproductor instalado
#   127: Error. Enlace "acestream://" no ofrecido como primer parámetro.
#
##############################################################################################################################################################


#########################################
##      VARIABLES GLOBALES
#########################################
#Directorio de la herramienta
ACEHOME=$(dirname "$(realpath "$0")")
#Directorio del entorno en python que se creará
ACEVENV="$ACEHOME"/cache/venv

#Reproductor en flatpak
ACEPLAYER="flatpak run --branch=stable --arch=x86_64 --command=mpv --file-forwarding io.mpv.Mpv --player-operation-mode=pseudo-gui"
#Reproductor en appimage--> ACEPLAYER="$ACEHOME/Mpv.AppImage --player-operation-mode=pseudo-gui"

#Ace Stream engine. El core de AceStream
ACEENGINE="$ACEHOME/AceStream-3.1.49-v2.2.AppImage --client-console --upload-limit 1000"

#########################################
##      FUNCIONES
#########################################
# Función para todas las comprobaciones iniciales
function menu() {
    
    NOMBRE=acestreamDeck
    VERSION=1b
    TEXTOBIENVENIDA="Bienvenido a $NOMBRE.\nPrograma para facilitar la ejecución de enlaces de AceStream.\n\nEl asistente se mostrara a continuacion. Siga las instrucciones.\n"
    TEXTOSALIDA="Gracias por usar $NOMBRE.\n\Saludos!"
    
    if ! zenity --help >/dev/null 2>/dev/null;then
        echo "(log) No se encuentra el programa zenity, necesario para esta parte de la apliación"
        exit 127
    fi
        
    # Función de bienvenida
    zenity --timeout 6 --info --title="$NOMBRE v$VERSION" --width=250 --text="$TEXTOBIENVENIDA" 2>/dev/null

    RESULTADO=$(zenity --list \
                    --title="$NOMBRE v$VERSION" \
                    --height=230 \
                    --width=300 \
                    --ok-label="Aceptar" \
                    --cancel-label="Cancelar" \
                    --text="Selecciona una opción:" \
                    --radiolist \
                    --column="ID" \
                    --column="Acción" \
                    1 "Instalar" 2 "Desinstalar" 3 "Reproducir Enlace" 4 "Salir")
    case "$RESULTADO" in
        Instalar)
            echo Instalar
            $0 install && zenity --timeout 4 --info --title="$NOMBRE v$VERSION" --text="¡Instalado!" 2>/dev/null            
            ;;
        Desinstalar)
            echo Desinstalar
            rm "$HOME/.local/share/applications/acestream-web.desktop" && zenity --timeout 4 --info --title="$NOMBRE v$VERSION" --text="¡Desinstalado!" 2>/dev/null       
            ;;
        "Reproducir Enlace")
            datos=$(zenity --forms \
               --title="$NOMBRE v$VERSION" \
               --text="Introduce el enlace acestrem, (debe de comenzar por acestream://)" \
               --add-entry="acestream://")
            ans=$?
            if [ $ans -eq 0 ];then
                $0 "acestream://$datos"
            fi
        ;;
    esac
    
    zenity --timeout 4 --info --title="$NOMBRE v$VERSION" --width=250 --text="$TEXTOSALIDA" 2>/dev/null
    exit 0

}

#########################################
##              BEGIN
#########################################

#¿Tenemos el reproductor?
if ! flatpak list |grep mpv > /dev/null 2>/dev/null ;then
    echo "No tienes el reproductor Mpv instalado a través de flatpak (https://flathub.org/es/apps/io.mpv.Mpv). Por favor, instálalo para poder usar este programa."
    exit 1
fi

case "$1" in
    install)
        echo -ne "[Desktop Entry]\nType=Application\nName=Start AceStream-web\nExec=$(realpath "$0") %U\nIcon=$ACEHOME/icon.png\nCategories=GNOME;GTK;Network;\nStartupNotify=true\nTerminal=true\n" > \
        "$HOME/.local/share/applications/acestream-web.desktop"
        echo "Acceso directo \"desktop\" creado"
        exit 0
    ;;
    "acestream://"*)
        #Comprobamos si el entorno en python está creado o debemos de recrearlo
        if ! test -d "$ACEVENV";then
            python -m venv "$ACEVENV"
            # shellcheck source=/dev/null
            source "$ACEVENV"/bin/activate
            pip install acestream-launcher
        fi

        # shellcheck source=/dev/null
        cd "$ACEHOME" && source "$ACEVENV"/bin/activate

        #Matamos cualquier instancia anterior
        pkill AceStream

        ########### EJECUTAMOS ################
        acestream-launcher "$1" -p "$ACEPLAYER" -e "$ACEENGINE"
        #######################################

        ########### POST EJECUCIÓN ############
        sleep 1 #Esperamos 1seg
        #Borramos caches
        [ -d "$ACEHOME/AceStream-3.1.49-v2.2.AppImage.home" ] && cd "$ACEHOME/AceStream-3.1.49-v2.2.AppImage.home" && rm -Rf "$ACEHOME/AceStream-3.1.49-v2.2.AppImage.home/.ACEStream" "$ACEHOME/AceStream-3.1.49-v2.2.AppImage.home/.cache"
        #######################################
    ;;
    *)
        menu
        # No debe de llegar aquí
        exit 1
    ;;
esac
exit 0
