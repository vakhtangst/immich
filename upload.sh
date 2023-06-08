#!/bin/bash

set -e

upload () {
    filename=$(basename "${1}")
    fileCreatedAt=`date +'%Y-%m-%d %H:%M:%S' -d"@$(stat -c '%W' ${1})"`
    fileModifiedAt=`date +'%Y-%m-%d %H:%M:%S' -d"@$(stat -c '%Y' ${1})"`    
    fileExtension=${filename##*.}
    deviceAssetId=${filename%.*}

    echo ${fileCreatedAt}
    echo ${fileModifiedAt}
    echo ${fileExtension}
    echo ${deviceAssetId}
    echo ${1}

    curl -L -X POST 'https://photos.sliton.ru/api/asset/upload' \
        -H 'Content-Type: multipart/form-data' \
        -H 'Accept: application/json' \
        -H 'x-api-key: BPy0JdhvcsgMFx2jm3HnQejDpP9luzMc6d9vHaiVWzY' \
        -F 'assetData=@"${1}"' \
        -F 'assetType="IMAGE"' \
        -F 'fileExtension="${fileExtension}"' \
        -F 'isFavorite="false"' \
        -F 'fileModifiedAt="${fileModifiedAt}"' \
        -F 'fileCreatedAt="${fileCreatedAt}"' \
        -F 'deviceId="CLI"' \
        -F 'deviceAssetId="${deviceAssetId}"'
}

export -f upload
find /home \( ! -regex '.*/\..*' \) \( ! -regex '.*/\-.*' \) -iregex ".*.\(jpg\|png\)" -exec bash -c 'upload "$0"' {} \;
