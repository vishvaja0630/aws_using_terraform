pipeline {
    agent any
    stages{
      stage('AWS VM Creation')
	    {
	     steps{
		   withCredentials([string(credentialsId: 'vish_aws_access_key', variable: 'access_key'), string(credentialsId: 'vish_aws_secret_key', variable: 'secret_key')]) {
       sh '''
       terraform init
       terraform plan  -var "access=$access_key" -var "secret=$secret_key"
       terraform apply -var "access=$access_key" -var "secret=$secret_key" -auto-approve
       terraform destroy -var "access=$access_key" -var "secret=$secret_key" -auto-approve'''
       }
	   }
	 }
	}//stages closed
}
