# This is the base image we use to create our image from
#  LTS version: 2.222.1
FROM jenkins/jenkins:lts

# Switch from user jenkins to root
USER root

# Download and Install Maven and Java versions
RUN mkdir -p /opt/downloads \
    && mkdir -p /opt/maven \
    && mkdir -p /opt/java \
    && wget -P /opt/downloads http://apache.mirrors.nublue.co.uk/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz \
    && wget -P /opt/downloads --no-check-certificate https://github.com/frekele/oracle-java/releases/download/8u212-b10/jdk-8u212-linux-x64.tar.gz \
    && wget -P /opt/downloads --no-check-certificate https://github.com/frekele/oracle-java/releases/download/8u212-b10/jdk-8u212-linux-x64.tar.gz.md5 \
    && echo "$(cat /opt/downloads/jdk-8u212-linux-x64.tar.gz.md5) /opt/downloads/jdk-8u212-linux-x64.tar.gz" | md5sum -c \
    && wget -P /opt/downloads --no-check-certificate https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.6%2B10/OpenJDK11U-jdk_x64_linux_hotspot_11.0.6_10.tar.gz \
    && tar -xzf /opt/downloads/apache-maven-3.6.3-bin.tar.gz -C /opt/maven \
    && tar -xzf /opt/downloads/jdk-8u212-linux-x64.tar.gz -C /opt/java \
    && tar -xzf /opt/downloads/OpenJDK11U-jdk_x64_linux_hotspot_11.0.6_10.tar.gz -C /opt/java \
    && rm -rf /opt/downloads

# Install Docker CE binaries
RUN apt-get update \
    && apt-get -y install apt-transport-https ca-certificates curl gnupg2 software-properties-common acl \
    && curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey \
    && apt-key add /tmp/dkey \
    && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable" \
    && apt-get update \
    && apt-get -y install docker-ce jq

# Allow jenkins user to run docker commands against the docker host
RUN usermod -a -G docker jenkins \
    #  Not ideal but /var/run/docker.sock belongs to the host and
    #   is created with root:root
    && usermod -a -G root jenkins \
    && date > /build-date.txt

# Set environment variables for Java and Maven
USER jenkins
ENV JAVA_HOME /opt/java/jdk1.8.0_212
ENV PATH $JAVA_HOME/bin:$PATH
ENV MVN_HOME /opt/maven/apache-maven-3.6.3
ENV PATH $MVN_HOME/bin:$PATH

## Disabling this to force creating an admin user on startup
#get rid of admin password setup
#ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

# Need to use a mirror as official url seems to be down
ENV JENKINS_UC_DOWNLOAD http://mirrors.jenkins-ci.org

# Automatically installing all plugins
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

# init scripts
COPY init.groovy.d /usr/share/jenkins/ref/init.groovy.d/
