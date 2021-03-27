#!groovy
import groovy.json.JsonSlurperClassic
node {

    def BUILD_NUMBER=1
    def RUN_ARTIFACT_DIR="tests/${BUILD_NUMBER}"
    def SFDC_USERNAME

    def SF_USERNAME=env.SF_USERNAME
    def SF_INSTANCE_URL = env.SF_INSTANCE_URL
    def SERVER_KEY_CREDENTALS_ID = env.JWT_CRED_ID
    def SF_CONSUMER_KEY=env.SF_CONSUMER_KEY
    println 'KEY IS' 
    println SERVER_KEY_CREDENTALS_ID
    def toolbelt = tool 'toolbelt'

    stage('checkout source') {
        // when running in multi-branch job, one must issue this command
        checkout scm
    }

    withCredentials([file(credentialsId: SERVER_KEY_CREDENTALS_ID, variable: 'jwt_key_file')]) {
        stage('Create Scratch Org') {
            if (isUnix()) {
                rc = sh returnStatus: true, script: "${toolbelt} force:auth:jwt:grant --clientid ${SF_CONSUMER_KEY} --username ${SF_USERNAME} --jwtkeyfile ${jwt_key_file} --setdefaultdevhubusername --instanceurl ${SF_INSTANCE_URL}"
            }else{
                 rc = bat returnStatus: true, script: "\"${toolbelt}\" force:auth:jwt:grant --clientid ${SF_CONSUMER_KEY} --username ${SF_USERNAME} --jwtkeyfile \"${jwt_key_file}\" --setdefaultdevhubusername --instanceurl ${SF_INSTANCE_URL}"
            }
            if (rc != 0) { error 'hub org authorization failed' }

            // need to pull out assigned username
              if (isUnix()) {
                rmsg = sh returnStdout: true, script: "${toolbelt} force:org:create --definitionfile config/enterprise-scratch-def.json --json --setdefaultusername"
              }else{
                   rmsg = bat returnStdout: true, script: "\"${toolbelt}\" force:org:create --definitionfile config/project-scratch-def.json --json --setdefaultusername"
              }
            printf rmsg
            println('Hello from a Job DSL script!')
            println(rmsg)
            def beginIndex = rmsg.indexOf('{')
            def endIndex = rmsg.indexOf('}')
            println(beginIndex)
            println(endIndex)
            def jsobSubstring = rmsg.substring(beginIndex)
            println(jsobSubstring)
            
            def jsonSlurper = new JsonSlurperClassic()
            def robj = jsonSlurper.parseText(jsobSubstring)
            //if (robj.status != "ok") { error 'org creation failed: ' + robj.message }
            SFDC_USERNAME=robj.result.username
            robj = null
            
        }
        
          stage('Push To Test Org') {
              if (isUnix()) {
                    rc = sh returnStatus: true, script: "\"${toolbelt}\" force:source:push --targetusername ${SFDC_USERNAME}"
              }else{
                  rc = bat returnStatus: true, script: "\"${toolbelt}\" force:source:push --targetusername ${SFDC_USERNAME}"
              }
            if (rc != 0) {
                error 'push failed'
            }
            
          }
             
    }
}