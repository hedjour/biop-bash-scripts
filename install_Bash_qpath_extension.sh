#!/bin/bash
#Proposal script to avoid groovy script for QuPath extension
scriptpath=$(realpath $(dirname $0))
echo "test $scriptpath"
source "$scriptpath/global_function.sh"
source "$scriptpath/version_software_script.sh"

################################################################################
# Help                                                                         #
################################################################################
function Help()
{
   # Display Help
   echo ------QuPath extensions installer Script -------------
   echo "This batch file downloads and install some biop selected QuPath (v$qupath_version) extensions."
   echo 
   echo "  - https://github.com/BIOP/qupath-extension-biop"
   echo "  - https://github.com/BIOP/qupath-extension-cellpose"
   echo "  - https://github.com/BIOP/qupath-extension-warpy"
   echo "  - https://github.com/BIOP/qupath-extension-abba"
   echo "  - https://github.com/qupath/qupath-extension-stardist"
   echo "  - https://github.com/BIOP/qupath-extension-biop-omero"
   echo
   echo "You should specify the folder where qupath is installed"
   echo "argument of this script. For instance: "
   echo ""
   echo "Windows:"
   echo "./install_qupath_extensions.sh \"C:/\""
   echo 
   echo "Mac:"
   echo "./install_qupath_extensions.sh /Applications/"
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


# ----------------- COMPONENTS VERSION -----------
biop_extension_url="https://github.com/BIOP/qupath-extension-biop/releases/download/v${biop_extension_version}/qupath-extension-biop-${biop_extension_version}.jar"
cellpose_extension_url="https://github.com/BIOP/qupath-extension-cellpose/releases/download/v${cellpose_extension_version}/qupath-extension-cellpose-${cellpose_extension_version}.zip"
warpy_extension_url="https://github.com/BIOP/qupath-extension-warpy/releases/download/${warpy_extension_version}/qupath-extension-warpy-${warpy_extension_version}.zip"
abba_extension_url="https://github.com/BIOP/qupath-extension-abba/releases/download/${abba_extension_version}/qupath-extension-abba-${abba_extension_version}.zip"
stardist_extension_url="https://github.com/qupath/qupath-extension-stardist/releases/download/v${stardist_extension_version}/qupath-extension-stardist-${stardist_extension_version}.jar"
biop_omero_extension_url="https://github.com/BIOP/qupath-extension-biop-omero/releases/download/v${biop_omero_extension_version}/qupath-extension-biop-omero-${biop_omero_extension_version}.zip"

# ----------------- MAIN --------------------------

echo ------ QuPath extensions Installer Script -------------
echo "This batch file downloads and install QuPath extensions"

echo 
echo "- QuPath version: $qupath_version"
echo
echo "- BIOP Extension: $biop_extension_version"
echo "- CellPose Extension: $cellpose_extension_version"
echo "- Warpy Extension: $warpy_extension_version"
echo "- ABBA Extension: $abba_extension_version"
echo "- Stardist Extension: $stardist_extension_version"
echo "- BIOP OMERO Extension: $biop_omero_extension_version"

#  ------- INSTALLATION PATH VALIDATION and Check system if not already done
if [ $# -eq 0 ] 
then
	path_validation
else 	
	path_validation $1
fi

# ------ SETTING UP QUPATH ------
echo ------ Setting up QuPath ------

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
	echo "Linux beta supported - please contribute to this installer to support it!"
	qupath_executable_file="QuPath"
	qupath_path="$path_install/QuPath/bin/$qupath_executable_file"
    qupath_extension_dir="$path_install/QuPath/extensions"
elif [[ "$OSTYPE" == "darwin"* ]]; then
	qupath_executable_file="Contents/MacOS/QuPath"
	qupath_path="/Applications/QuPath.app/$qupath_executable_file"
    qupath_extension_dir="/Applications/QuPath.app/extensions"
elif [[ "$OSTYPE" == "msys" ]]; then
	qupath_executable_file="QuPath-$qupath_version.exe"
	qupath_path="$path_install/QuPath-$qupath_version/$qupath_executable_file"
    qupath_extension_dir="$path_install/QuPath-$qupath_version/extensions"
fi

if [[ -f "$qupath_path" ]]; then
    echo "QuPath correctly detected"
else
    echo "QuPath is not installed, please install it before running this script"
    echo "Please check this directory : $qupath_path"
    #pause "Press [Enter] to end the script"
    exit 1 # We cannot proceed
fi	

if [[ -f "$qupath_extension_dir" ]]; then
    echo "QuPath extensions directory correctly detected"
else
    mkdir $qupath_extension_dir
fi	
echo ------ Setting up QuPath extension ------

echo "Download biop_extension"
    echo "$biop_extension_url"
    curl "$biop_extension_url" -L -# -o "${qupath_extension_dir}/biop_extension_v${biop_extension_version}.jar"
    echo "Download start dist extension"
    curl "$stardist_extension_url" -L -# -o "${qupath_extension_dir}/stardist_v${stardist_extension_version}.jar"
    echo "Download Abba, warpy, cellpose"
    mkdir "${qupath_extension_dir}/tmp"
    curl "$cellpose_extension_url" -L -# -o "$qupath_extension_dir/tmp/cellpose.zip"
    curl "$warpy_extension_url" -L -# -o "$qupath_extension_dir/tmp/warpy.zip"
    curl "$abba_extension_url" -L -# -o "$qupath_extension_dir/tmp/abba.zip"
    #curl "$cellpose_extension_url" "$warpy_extension_url" "$abba_extension_url" -L -# --output-dir "$qupath_extension_dir"
    unzip "${qupath_extension_dir}/tmp/*.zip" -d "$qupath_extension_dir/"
    rm -rf "${qupath_extension_dir}/tmp"
