# docker-jenkins

Inspired by this article: https://dzone.com/articles/dockerizing-jenkins-2-setup-and-using-it-along-wit
It installs a jenkins lts version 2.222.1 including:
* All the recommended plugins
* Plugins for Blue Ocean (new Jenkins UI)
* Extra plugins for credentials, sonar, reports
* JDK8_212 and JDK11
* Maven 3.6.3
* Ability to manage docker containers living on the same host as the Jenkins docker container
