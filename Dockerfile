FROM jenkins/jenkins:latest
USER root
ENV JENKINS_USER admin
ENV JENKINS_PASS admin
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
COPY init.groovy.d/* /usr/share/jenkins/ref/init.groovy.d/
COPY jobs.groovy.d/* /usr/share/jenkins/ref/jobs.groovy.d/
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
VOLUME /var/jenkins_home

##Custom added
USER root
RUN apt-get update
RUN apt-get -y install python python-pip git wget unzip
RUN pip install boto3
RUN pip install awscli --upgrade
RUN wget https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip && unzip terraform_0.11.7_linux_amd64.zip -d /usr/bin/

#==========
# Maven
#==========
ENV MAVEN_VERSION 3.5.0

RUN curl -fsSL http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xzf - -C /usr/share \
  && mv /usr/share/apache-maven-$MAVEN_VERSION /usr/share/maven \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven

#==========
# Ant
#==========

ENV ANT_VERSION 1.10.5

RUN curl -fsSL https://www.apache.org/dist/ant/binaries/apache-ant-$ANT_VERSION-bin.tar.gz | tar xzf - -C /usr/share \
  && mv /usr/share/apache-ant-$ANT_VERSION /usr/share/ant \
  && ln -s /usr/share/ant/bin/ant /usr/bin/ant

ENV ANT_HOME /usr/share/ant

USER jenkins
