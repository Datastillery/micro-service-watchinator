library(
    identifier:'pipeline-lib@4.2.0',
    retriever:modernSCM([$class:'GitSCMSource',
    remote:'https://github.com/SmartColumbusOS/pipeline-lib',
    credentialsId:'jenkins-github-user'])
)

def image, imageName
def doStageIf = scos.&doStageIf
def doStageIfRelease = doStageIf.curry(scos.isRelease(env.BRANCH_NAME))
def doStageUnlessRelease = doStageIf.curry(!scos.isRelease(env.BRANCH_NAME))
def doStageIfPromoted = doStageIf.curry(env.BRANCH_NAME == 'master')

node('infrastructure') {
    ansiColor('xterm') {
        scos.doCheckoutStage()
        def SERVICE_NAME="micro-service-watchinator"
        imageName = "scos/${SERVICE_NAME}:${env.GIT_COMMIT_HASH}"

        doStageUnlessRelease('Build') {

            image = docker.build(imageName)
            println image.getClass()
        }

        dir('micro-service-watchinator') {
            doStageUnlessRelease('Deploy to Dev') {
                scos.withDockerRegistry {
                    image.push()
                    image.push('latest')
                }
                deployTo('dev')
            }

            doStageIfPromoted('Deploy to Staging')  {
                def promotionTag = scos.releaseCandidateNumber()

                deployTo('staging')

                scos.applyAndPushGitHubTag(promotionTag)

                scos.withDockerRegistry {
                    image.push(promotionTag)
                }
            }

            doStageIfRelease('Deploy to Production') {
                def releaseTag = env.BRANCH_NAME
                def promotionTag = 'prod'

                deployTo('prod')

                scos.applyAndPushGitHubTag(promotionTag)

                scos.withDockerRegistry {
                    image = scos.pullImageFromDockerRegistry("scos/${SERVICE_NAME}", env.GIT_COMMIT_HASH)
                    image.push(releaseTag)
                    image.push(promotionTag)
                }
            }
        }
    }
}


def deployTo(enviornment) {
    def extraArgs = [
        'watchinator_image_name': "${org.scos.pipeline.ECRepository.hostname()}/${imageName}"
    ]

    def terraform = scos.terraform(enviornment)
    sh "terraform init"
    terraform.plan(terraform.defaultVarFile, extraArgs)
    terraform.apply()
}