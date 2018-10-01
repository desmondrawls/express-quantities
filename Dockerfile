FROM node:8

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./
COPY bower.json ./

RUN npm install -g bower pulp download-or-build-purescript

ENV PURESCRIPT_DOWNLOAD_SHA1 08d4839f2800a6fdb398ec45b7182eada112ea89
RUN cd /opt \
    && wget https://github.com/purescript/purescript/releases/download/v0.12.0/linux64.tar.gz \
    && echo "$PURESCRIPT_DOWNLOAD_SHA1 linux64.tar.gz" | sha1sum -c - \
    && tar -xvf linux64.tar.gz \
    && rm /opt/linux64.tar.gz

ENV PATH /opt/purescript:$PATH

RUN npm install

RUN bower install --allow-root
# If you are building your code for production
# RUN npm install --only=production

# Bundle app source
COPY . .

EXPOSE 8080
ENTRYPOINT [ "pulp", "run" ]
