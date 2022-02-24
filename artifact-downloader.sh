#!/bin/bash

URL='https://mycompany.com/'
ENDPOINT='artifactory/api/search/buildArtifacts'
FOLDER='/tmp'

function usage {
    echo "Usage: ${0} -b BUILD_NAME -n BUILD_NUMBER [-u ARTIFACTORY_URL]" >&2
    echo "Download artifacts base on build number into temporary folder" >&2
    echo '  -b      Artifactory build name (REQUIRED)' >&2
    echo '  -n      Artifactory build number (REQUIRED)' >&2
    echo '  -u      Artifactory instance URL (OPTIONAL), default to https://mycompany.com/' >&2
    echo '  -f      Target artifact download folder, default to /tmp'
    exit 1
}

while getopts b:n:uf OPTION
do
    case ${OPTION} in
        b)
            BUILD_NAME="${OPTARG}"
            ;;
        n)
            BUILD_NUMBER="${OPTARG}"
            ;;
        u)
            URL="${OPTARG}"
            ;;
        f)
            FOLDER="${OPTARG}"
            ;;
        ?)
            echo 'Invalid option' >&2
            usage
            exit 1
            ;;
    esac
done

if [ ! "${BUILD_NAME}" ] || [ ! "${BUILD_NUMBER}" ]
then
    usage
fi

RESPONSE=$(curl -s --location --request POST "${URL}${ENDPOINT}" \
--header 'Content-Type: application/json' \
--data-raw "{
 \"buildName\": \"${BUILD_NAME}\",
 \"buildNumber\": \"${BUILD_NUMBER}\"
}")

DOWNLOAD_URIs=$(echo "${RESPONSE}" | awk -F'"' '/downloadUri/{ print $(NF-1) }')

if [ ! "${DOWNLOAD_URIs}" ]
then
    echo "Artifact not found" >&2
    exit 1
fi

cd "${FOLDER}"

for DOWNLOAD_URI in $DOWNLOAD_URIs
do
    curl -s -O ${DOWNLOAD_URI}
    FILE=$(basename ${DOWNLOAD_URI})
    echo "${PWD}/${FILE}"
done

exit 0