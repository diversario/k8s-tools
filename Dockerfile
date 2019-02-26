FROM diversario/toolbox:0.0.2 as BASE
FROM google/cloud-sdk:235.0.0-alpine as GCLOUD

FROM BASE

RUN apk update \
        && apk upgrade \
        && apk add --no-cache \
        ca-certificates su-exec python \
        && update-ca-certificates 2>/dev/null || true

COPY ./get-binaries.sh /get-binaries.sh

RUN /get-binaries.sh

COPY --from=GCLOUD /google-cloud-sdk /google-cloud-sdk
COPY ./exec.sh /exec.sh

ENV PATH=$PATH:/google-cloud-sdk/bin

ENTRYPOINT /exec.sh $@