pipeline {

  agent any
  parameters {

        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
        booleanParam(name: 'destroy', defaultValue: false, description: 'Destroy Terraform build?')
  }

  environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
  }

  stages {
    stage('Cloning Git') {
      steps {
        checkout scm
      }
    }
    stage('initialize') {
         when {
                not {
                    equals expected: true, actual: params.destroy
                }
            }
         steps{
            script {
               sh 'terraform init -input=false'

               sh "terraform plan -input=false -out tfplan "
               sh 'terraform show -no-color tfplan > tfplan.txt'
            }
         }
    }

     stage('Approval') {
           when {
               not {
                   equals expected: true, actual: params.autoApprove
               }
               not {
                    equals expected: true, actual: params.destroy
                }
           }




           steps {
               script {
                    def plan = readFile 'tfplan.txt'
                    input message: "Do you want to apply the plan?",
                    parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
               }
           }
       }

        stage('Apply') {
            when {
                not {
                    equals expected: true, actual: params.destroy
                }
            }

            steps {
                sh "terraform apply -input=false tfplan"
            }
        }

        stage('Destroy') {
            when {
                equals expected: true, actual: params.destroy
            }

        steps {
           sh "terraform destroy --auto-approve"
        }
    }

  }
}
