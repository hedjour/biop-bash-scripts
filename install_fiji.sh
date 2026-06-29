#!/bin/bash
scriptpath=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

source "$scriptpath/global_function.sh"
source "$scriptpath/version_software_script.sh"

################################################################################
# Help                                                                         #
################################################################################
function Help()
{
   # Display Help
   echo ------ Fiji Installer Script -------------
   echo "This script file downloads and installs Fiji on your computer."
   echo "Fiji is automatically updated after download "
   echo
   echo "You can specify the folder where to install Fiji as an "
   echo "argument of this script. For instance: "
   echo ""
   echo "Windows:"
   echo "./install_fiji.sh C:/"
   echo ""
   echo "Mac:"
   echo "./install_fiji.sh /Applications/"
   echo ""
   echo "If no path is specified, you will be asked for one."
   echo
}

while getopts ":h" option; do
   case $option in
      h) # display Help
         Help
         exit;;
   esac
done

echo ------ ImageJ/Fiji Installer Script -------------
#  ------- INSTALLATION PATH VALIDATION and Check system if not already done
if [ $# -eq 0 ]; then
    path_validation
else
    path_validation "$1"
fi

# MAKE TEMP FOLDER IN CASE DOWNLOADS ARE NECESSARY
temp_dl_dir="$path_install/temp_dl"
mkdir -p "$temp_dl_dir"

# ------ Fiji ------
# Always using latest — check executable names at https://imagej.net/software/fiji/downloads
# New jaunch launcher names (Java 21+)
case "$OSTYPE" in
   linux-gnu*)
      fiji_zip_name="fiji-latest-linux64-jdk.zip"
      fiji_executable_file="fiji-linux-x64"
      ;;
   darwin*)
      fiji_zip_name="fiji-latest-macos64-jdk.zip"
      fiji_executable_file="Contents/MacOS/fiji-macos"
      ;;
   msys|cygwin)
      fiji_zip_name="fiji-latest-win64-jdk.zip"
      fiji_executable_file="fiji-windows-x64.exe"
      ;;
esac
fiji_url="https://downloads.imagej.net/fiji/latest/${fiji_zip_name}"

# ------ SETTING UP IMAGEJ/FIJI
echo ------ Setting up ImageJ/Fiji ------
# if linux we create a desktop entry for Fiji
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
	echo "Linux beta supported - please contribute to this installer to support it!"
	echo "[Desktop Entry]
Type=Application
Name=Fiji
Comment=QuPath
Icon=$path_install/Fiji.app/images/icon-flat.png
Exec="$path_install/Fiji.app/$fiji_executable_file"
Terminal=false  #ouvrir ou non un terminal lors de l'exécution du programme (false ou true)
StartupNotify=false  #notification de démarrage ou non (false ou true)
Categories=Analyse image  #Exemple: Categories=Application;;" > ~/.local/share/applications/Fiji.desktop
fi

fiji_path="$path_install/Fiji.app/$fiji_executable_file"

echo "Looking for Fiji executable: $fiji_path"
if [[ -f "$fiji_path" ]]; then
    echo "Fiji detected, bypassing installation"
else
	echo "Fiji not present, downloading it"
	fiji_zip_path="$temp_dl_dir/fiji.zip"
	curl "$fiji_url" -# -o "$fiji_zip_path"
	echo "Unzipping Fiji in $path_install"
	/usr/bin/unzip "$fiji_zip_path" -d "$path_install/"
	[[ "$OSTYPE" == "darwin"* ]] && mac_fix_permissions "$path_install/Fiji.app"
fi

if [[ -f "$fiji_path" ]]; then
    echo "Fiji successfully installed."
else
	echo "Fiji installation failed, please retry with administrator rights or install in a folder requiring less priviledge"
	pause "Press [Enter] to end the script"
	exit 1 # We cannot proceed
fi

# Updating several times because there may be some issues with removing some files after a single update is performed
echo "Updating Fiji"
"$fiji_path" --update update
echo "Fiji updated"

[[ "$OSTYPE" == "darwin"* ]] && mac_fix_permissions "$path_install/Fiji.app"

echo "Updating Fiji one last time" 
"$fiji_path" --update update
echo "Fiji should now be up-to-date"

[[ "$OSTYPE" == "darwin"* ]] && mac_fix_permissions "$path_install/Fiji.app"


echo "Removing temporary download folder $temp_dl_dir"
rm -r "$temp_dl_dir"
