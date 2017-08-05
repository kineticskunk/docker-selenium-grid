# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE.  IT IS GENERATED.
# PLEASE UPDATE Dockerfile.txt INSTEAD OF THIS FILE
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FROM kineticskunk/node-firefox:kineticskunkmaven
LABEL authors=SeleniumHQ-KineticSkunk

USER root

################################################################################################################
# Install Maven
# https://github.com/carlossg/docker-maven
################################################################################################################

ENV MAVEN_VERSION 3.3.9

RUN apt-get update && apt-get install -y curl git && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
  && curl -fsSL http://apache.osuosl.org/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz \
    | tar -xzC /usr/share/maven --strip-components=1 \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG /home/seluser/.m2
ENV COPY_REFERENCE_FILE_LOG $MAVEN_CONFIG/copy_reference_file.log

COPY mvn-entrypoint.sh /usr/local/bin/mvn-entrypoint.sh
COPY settings-docker.xml /usr/share/maven/ref/

USER seluser

RUN mkdir /home/seluser/.m2
VOLUME /home/seluser/.m2