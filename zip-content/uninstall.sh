#!/sbin/sh

<<LICENSE
  Copyright (C) 2016-2017  ale5000
  This file is part of microG unofficial installer by @ale5000.

  microG unofficial installer is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version, w/microG unofficial installer zip exception.

  microG unofficial installer is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with microG unofficial installer.  If not, see <http://www.gnu.org/licenses/>.
LICENSE

list_app_files()
{
cat <<EOF
GmsCore
com.google.android.gms
GoogleFeedback
GoogleLoginService
GoogleOneTimeInitializer
GooglePartnerSetup
GoogleServicesFramework
com.google.android.gsf
GsfProxy
MarketUpdater
Phonesky
com.android.vending
PlayGames
Velvet
YouTube

GmsCore_update
GmsCoreSetupPrebuilt
PrebuiltGmsCore
WhisperPush

BlankStore
FakeStore
FDroidPriv
FDroidPrivileged
PlayStore
Vending

AMAPNetworkLocation
LegacyNetworkLocation
NetworkLocation
UnifiedNlp

com.google.android.location
com.qualcomm.location
org.microg.nlp

DejaVuBackend
DejaVuNlpBackend
org.fitchfamily.android.dejavu
IchnaeaNlpBackend
MozillaNlpBackend
org.microg.nlp.backend.ichnaea
NominatimGeocoderBackend
NominatimNlpBackend
org.microg.nlp.backend.nominatim

com.mgoogle.android.gms
EOF
}

if [[ -z "$INSTALLER" ]]; then
  ui_debug()
  {
    echo "$1"
  }

  delete_recursive()
  {
   rm -rf "$1" || ui_debug "Failed to delete '$1'"
  }

  ui_debug 'Uninstalling...'

  SYS_PATH='/system'
  PRIVAPP_PATH="${SYS_PATH}/app"
  if [[ -d "${SYS_PATH}/priv-app" ]]; then PRIVAPP_PATH="${SYS_PATH}/priv-app"; fi
fi

remove_file_if_exist()
{
  if [[ -e "$1" ]]; then
    ui_debug "Deleting '$1'..."
    delete_recursive "$1"
  fi
}

list_app_files | while read FILE; do
  if [[ -z "$FILE" ]]; then continue; fi
  remove_file_if_exist "${PRIVAPP_PATH}/$FILE"
  remove_file_if_exist "${PRIVAPP_PATH}/$FILE.apk"
  remove_file_if_exist "${PRIVAPP_PATH}/$FILE.odex"
  remove_file_if_exist "${SYS_PATH}/app/$FILE"
  remove_file_if_exist "${SYS_PATH}/app/$FILE.apk"
  remove_file_if_exist "${SYS_PATH}/app/$FILE.odex"
  remove_file_if_exist "/data/app/$FILE"-*
done

DELETE_LIST="
${SYS_PATH}/etc/permissions/com.qualcomm.location.xml

/data/data/com.android.vending

/data/data/com.mgoogle.android.gms

${SYS_PATH}/addon.d/00-1-microg.sh
${SYS_PATH}/addon.d/1-microg.sh
${SYS_PATH}/addon.d/10-mapsapi.sh
${SYS_PATH}/addon.d/70-microg.sh

${SYS_PATH}/addon.d/05-microg.sh
${SYS_PATH}/addon.d/05-microg-playstore.sh
${SYS_PATH}/addon.d/05-microg-playstore-patched.sh
${SYS_PATH}/addon.d/05-unifiednlp.sh

${SYS_PATH}/etc/default-permissions/microg-permissions.xml
${SYS_PATH}/etc/default-permissions/microg-playstore-permissions.xml
${SYS_PATH}/etc/default-permissions/microg-playstore-patched-permissions.xml
${SYS_PATH}/etc/default-permissions/unifiednlp-permissions.xml

${SYS_PATH}/etc/sysconfig/microg.xml
${SYS_PATH}/etc/sysconfig/microg-playstore.xml
${SYS_PATH}/etc/sysconfig/microg-playstore-patched.xml
"
rm -rf ${DELETE_LIST}  # Filenames cannot contain spaces

if [[ -z "$INSTALLER" ]]; then
  ui_debug 'Done.'
fi
