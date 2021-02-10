pipeline {
    agent any
    stages{
      stage('AWS VM Creation')
	    {
	     steps{
		   withCredentials([string(credentialsId: 'vish_aws_access_key', variable: 'access_key'), string(credentialsId: 'vish_aws_secret_key', variable: 'secret_key')]) {
       sh '''
		   terraform init
       terraform plan
       terraform apply -var "access=$access_key" -var "secret=$secret_key" -auto-approve'''
       }
	   }
	 }
	}//stages closed
  
	//using terraform destroy-always runs
	post{
        always{
               sh 'terraform destroy --auto-approve'	       
               }
      }
	}