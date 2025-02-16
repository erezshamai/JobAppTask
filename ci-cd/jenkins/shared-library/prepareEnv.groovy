def call(scmVars) {
    env.GIT_COMMITTER = scmVars.GIT_COMMITTER
    env.GIT_BRANCH = scmVars.GIT_BRANCH
    echo "SCM triggered by: ${env.GIT_COMMITTER} on branch ${env.GIT_BRANCH}"
}