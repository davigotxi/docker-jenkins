/**
 * Setting up jdk8 and jdk11 installations
 * in the global tool configuration
 */
import hudson.model.JDK

def descriptor = new JDK.DescriptorImpl();

def List<JDK> installations = []

javaTools=[['name':'jdk8',  'home':'/opt/java/jdk1.8.0_212'],
           ['name':'jdk11', 'home':'/opt/java/jdk-11.0.6+10']]

javaTools.each { javaTool ->
    println("Setting up tool: ${javaTool.name}")
    def jdk = new JDK(javaTool.name as String, javaTool.home as String)
    installations.add(jdk)
}
descriptor.setInstallations(installations.toArray(new JDK[installations.size()]))
descriptor.save()

