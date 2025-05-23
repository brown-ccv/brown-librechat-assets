FROM alpine:latest as patcher

RUN apk add --no-cache jq git


# download librechat source code. depth only clones source code not git history
RUN git clone --branch v0.7.8 --depth 1 https://github.com/danny-avila/LibreChat.git

# copy path files to container
WORKDIR /patches

COPY patches/translations/en/patch.json .
COPY patches/config/librechat.yaml config/librechat.yaml
COPY patches/images/logo.svg images/logo.svg
COPY patches/images/favicon-16x16.png images/favicon-16x16.png
COPY patches/images/favicon-32x32.png images/favicon-32x32.png


# patch files

# Patch translation.json C:\Projects\Github\LibreChat\client\src\locales\en\translation.json
RUN jq -s '.[0] * .[1]' /LibreChat/client/src/locales/en/translation.json ./patch.json > /LibreChat/client/src/locales/en/translation.json.tmp \
    && mv /LibreChat/client/src/locales/en/translation.json.tmp /LibreChat/client/src/locales/en/translation.json

# Replace branding assets
RUN mv images/logo.svg /LibreChat/client/public/assets/logo.svg && \
    mv images/favicon-16x16.png /LibreChat/client/public/assets/favicon-16x16.png && \
    mv images/favicon-32x32.png /LibreChat/client/public/assets/favicon-32x32.png && \
    mv config/librechat.yaml /LibreChat/librechat.yaml

# Prepare the environment
#RUN  mv  /LibreChat/.env.example /LibreChat/.env
# RUN  mv  /LibreChat/librechat.example.yaml /LibreChat/librechat.yaml

# Final stage: use original LibreChat Dockerfile
FROM node:20-alpine

# Install jemalloc
RUN apk add --no-cache jemalloc

WORKDIR /app

COPY --from=patcher /LibreChat /app

# Continue with LibreChat's Dockerfile logic
RUN npm config set fetch-retry-maxtimeout 600000 && \
    npm config set fetch-retries 5 && \
    npm config set fetch-retry-mintimeout 15000 && \
    npm install --no-audit && \
    NODE_OPTIONS="--max-old-space-size=2048" npm run frontend && \
    npm prune --production && \
    npm cache clean --force

EXPOSE 3080
ENV LD_PRELOAD=/usr/lib/libjemalloc.so.2
ENV HOST=0.0.0.0
CMD ["npm", "run", "backend"]