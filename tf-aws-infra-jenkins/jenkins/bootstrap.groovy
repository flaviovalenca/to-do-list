import com.cloudbees.jenkins.plugins.sshcredentials.impl.BasicSSHUserPrivateKey
import com.cloudbees.plugins.credentials.CredentialsScope
import com.cloudbees.plugins.credentials.SystemCredentialsProvider
import com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl
import hudson.security.HudsonPrivateSecurityRealm
import hudson.plugins.git.BranchSpec
import hudson.plugins.git.GitSCM
import hudson.plugins.git.UserRemoteConfig
import hudson.security.FullControlOnceLoggedInAuthorizationStrategy
import jenkins.model.Jenkins
import org.jenkinsci.plugins.workflow.cps.CpsScmFlowDefinition
import org.jenkinsci.plugins.workflow.job.WorkflowJob

Jenkins jenkins = Jenkins.get()
File secretsDir = new File('/run/jenkins-secrets')
String adminPassword = new File(secretsDir, 'jenkins_admin_password').text.trim()
String dockerhubUsername = new File(secretsDir, 'dockerhub_username').text.trim()
String dockerhubToken = new File(secretsDir, 'dockerhub_token').text.trim()
String githubRepository = new File(secretsDir, 'github_repository').text.trim()
String githubPrivateKey = new File(secretsDir, 'github_ssh_private_key').text

if (!(jenkins.getSecurityRealm() instanceof HudsonPrivateSecurityRealm)) {
    HudsonPrivateSecurityRealm realm = new HudsonPrivateSecurityRealm(false)
    realm.createAccount('admin', adminPassword)
    jenkins.setSecurityRealm(realm)
}

if (!(jenkins.getAuthorizationStrategy() instanceof FullControlOnceLoggedInAuthorizationStrategy)) {
    jenkins.setAuthorizationStrategy(new FullControlOnceLoggedInAuthorizationStrategy())
}

def credentialsStore = SystemCredentialsProvider.getInstance().getStore()
def addCredential = { Object credential ->
    if (credentialsStore.getCredentials().find { it.id == credential.id } == null) {
        credentialsStore.addCredentials(com.cloudbees.plugins.credentials.domains.Domain.global(), credential)
    }
}

addCredential(new UsernamePasswordCredentialsImpl(
    CredentialsScope.GLOBAL,
    'dockerhub',
    'Docker Hub token',
    dockerhubUsername,
    dockerhubToken
))
addCredential(new BasicSSHUserPrivateKey(
    CredentialsScope.GLOBAL,
    'jenkins-github',
    'git',
    new BasicSSHUserPrivateKey.DirectEntryPrivateKeySource(githubPrivateKey),
    '',
    'GitHub SSH key'
))

WorkflowJob job = jenkins.getItem('to-do-list-prod')
if (job == null) {
    job = jenkins.createProject(WorkflowJob.class, 'to-do-list-prod')
}

def scm = new GitSCM(
    [new UserRemoteConfig(githubRepository, null, null, 'jenkins-github')],
    [new BranchSpec('*/main')],
    false,
    [],
    null,
    null,
    []
)
job.setDefinition(new CpsScmFlowDefinition(scm, 'Jenkinsfile'))
job.save()
jenkins.save()
