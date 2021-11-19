FROM ghost:2-alpine

# Add app-insights globally
RUN  mkdir /opt/ai && \
        cd /opt/ai && \
        npm init -y && \
        npm install --production --save applicationinsights@^1.8.10 && \
        npm install --production --save applicationinsights-native-metrics@^0.0.6

# Copy the ai-bootstrap.js file
COPY    ai-bootstrap.js /opt/ai/

# Configure AI via ENV VARS
# ENV APPINSIGHTS_INSTRUMENTATIONKEY xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
# ENV APPLICATIONINSIGHTS_ROLE_NAME Frontend
# ENV APPLICATIONINSIGHTS_ROLE_INSTANCE GhostInstance
# Lets use platform agnositic node method to load AI instead of monkey patching i.e. NODE_OPTIONS='--require "/opt/ai/ai-bootstrap.js"'
ENV NODE_OPTIONS='--require /opt/ai/ai-bootstrap.js'

# Add necessary packages for Sharp to work

RUN apk add --update --no-cache gcc g++ make libc6-compat python python3

RUN apk add vips-dev fftw-dev build-base --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/community --repository https://alpine.global.ssl.fastly.net/alpine/edge/main

# Install Azure Storage

RUN npm install ghost-storage-azure
RUN cp -vR node_modules/ghost-storage-azure current/core/server/adapters/storage/ghost-storage-azure

