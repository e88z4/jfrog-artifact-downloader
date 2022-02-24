# Build Artifact Extractor

Download artifacts from JFrog Artifactory base on build name and build number

## Running from shell scripting

```bash
./artifact-downloader.sh -b [BUILD_NAME] -n [BUILD_NUMBER]
```

## Running with Docker

```bash
docker run --rm -it build-artifact-extractor:latest ./artifact-downloader.sh -b my_build_name -n my_build_number
```

## Running the script inside Dockerfile in multistage build

```bash
FROM build-artifact-extractor:latest AS artifact-downloader
ARG BUILD_NAME
ARG BUILD_NUMBER
CMD ./artifact-downloader.sh -b ${BUILD_NAME} -n ${BUILD_NUMBER}

FROM openjdk:latest
COPY --FROM=artifact-downloader /my.jar /my.jar
CMD java -jar /my.jar
```
