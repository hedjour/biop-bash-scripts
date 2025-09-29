#!/bin/bash
#Here we specified the different version of each script

#Software version number

qupath_version=0.6.0 # https://github.com/qupath/qupath/releases
abba_extension_version=0.4.0 # https://github.com/BIOP/qupath-extension-abba/releases
elastix_version=5.2.0 # https://github.com/SuperElastix/elastix/releases
biop_extension_version=3.4.2 # https://github.com/BIOP/qupath-extension-biop/releases
cellpose_extension_version=0.11.0 # https://github.com/BIOP/qupath-extension-cellpose/releases
warpy_extension_version=0.4.2 # https://github.com/BIOP/qupath-extension-warpy/releases
stardist_extension_version=0.6.0 # https://github.com/qupath/qupath-extension-stardist/releases
biop_omero_extension_version=1.1.1 # https://github.com/BIOP/qupath-extension-biop-omero/releases
omero_ij_version=5.8.6 # https://www.openmicroscopy.org/omero/downloads/ 

#QuPath arguments :
argQuPathUserPath="defaultQuPathUserPath=\"$path_install/QuPath_Common_Data_0.6\""
argQuPathPrefNode="quPathPrefsNode=\"io.github.qupath/0.6\""
argQuPathExtensionURL="quPathExtensionURL=\"$qupath_abba_extension_url\""
argQuitAfterInstall="quitAfterInstall=\"true\""
