#!/usr/bin/env bash
set -e
INPUT="/in/openapi.json"

if [[ ! -f $INPUT ]]; then
   echo "$INPUT not exists"
   exit 1
fi
   
mkdir /work

echo "clearing out dir"
rm -r /out/* || true

echo "converting schema"

SWAGGER="/work/swagger.json"

api-spec-converter --from openapi_3 --to swagger_2 $INPUT > $SWAGGER

echo "generating client"

# TODO why paperclip requires this var?
export USER=user

/paperclip --api v2 --name openapi --out /out $SWAGGER
