# Copyright 2018 Marcos Rafael Kaissi Barbosa
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM openjdk:8-jre-alpine
MAINTAINER Marcos Rafael Kaissi Barbosa <mrkaissi@gmail.com>
ARG VERSION
ARG CREATION_DATE
LABEL   version="${VERSION}" \
		creationDate="${CREATION_DATE}"
ARG FLYWAY_VERSION=4.2.0
ARG TZ="Etc/UTC"
ENV TZ ${TZ}
WORKDIR /flyway
RUN apk add --no-cache --update -U \
        bash \
        curl \
        dumb-init \
        openssl \
        tzdata \
    && cp -v /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo "${TZ}" > /etc/timezone \
    && wget https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/${FLYWAY_VERSION}/flyway-commandline-${FLYWAY_VERSION}.tar.gz \
    && tar -xzf flyway-commandline-${FLYWAY_VERSION}.tar.gz \
    && mv flyway-${FLYWAY_VERSION}/* . \
    && rm flyway-commandline-${FLYWAY_VERSION}.tar.gz \
    && rm sql/* \
    && rm drivers/* \
    && ln -s /flyway/flyway /usr/local/bin/flyway
COPY drivers /flyway/drivers
COPY entrypoint /usr/local/bin/
VOLUME ["/flyway/sql"]
VOLUME ["/flyway/drivers"]
ENTRYPOINT ["/usr/bin/dumb-init", "--", "entrypoint"]
CMD ["-?"]
