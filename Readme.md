This repository contains Dockerfile for the `docker.pkg.github.com/jjs-dev/openapi-gen/gen` image.

usage:
 - Mount /in to folder containing `openapi.json` (e.g. obtained from JJS apiserver).
 - Mount /out to folder that will contain generated client.
 
Internally, we use `paperclip` and `api-spec-converter`.

Compatibility is not guaranteed.