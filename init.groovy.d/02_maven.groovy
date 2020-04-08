/**
 * Setting up maven3
 * in the global tool configuration
 */
import hudson.tasks.Maven.MavenInstallation;

def mavenDesc = jenkins.model.Jenkins.instance.getExtensionList(hudson.tasks.Maven.DescriptorImpl.class)[0]
def installation = new MavenInstallation("maven3", "/opt/maven/apache-maven-3.6.3", [])

mavenDesc.setInstallations(installation)
mavenDesc.save()
