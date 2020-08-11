////
def  myapp= "wavecloud/nginx-opens"
def  myarg=" -f Dockerfile"
def myport=8081
pipeline {
    agent { node('master') }
    parameters {
        string(name: 'Greeting', defaultValue: 'Hello', description: 'How should I greet the world?')
    }
    environment {
        imageName = 'jbloggs/demo-app'
        registryCredentialSet = 'docker_id'
        registryUri = 'https://registry.hub.docker.com'
    }
    
    stages {

        stage('Verification') {
            steps {
                script {
              
                   echo "Build Docker Image"
                   sh "docker rm -f mynginx-app || true"
                   def myimg = docker.build(myapp)
                   echo "Tag Docker Image ${myimg}"
                   def mytag = myimg.tag("mytag1")
                   echo "tag resulta: ${mytag}"

                   echo "Login Docker Hub"
                   docker.withRegistry('https://index.docker.io/v1/', 'docker_id'){
                      echo "Push Docker Image"
                      myimg.push()
                   }
                   echo "Remove Docker Image"
                   sh "docker rmi $myapp"
                   
                   echo "Run Docker Image"
                   myarg="--name mynginx-app -p ${myport}:${myport}"
                   def mycon = myimg.run(myarg)
 		   
                    sleep 5
                   echo "try to Verification!"
                   
                   def myres="Welcome"
                   echo "curl route url"
                   def mycurl= "curl localhost:8081"
                   def proc= mycurl.execute().text
                   echo "compare result..."
                   def myproc= proc.contains(myres)
                   println(myproc)
                   if ( myproc) {
                       echo "TEST PASS!"
                       echo "and then remove the container"
                       mycon.stop()
                       //sh "open /Applications/Google\\ Chrome.app/  https://$route"
                   }
                   else {
                       echo "TEST ERROR!"
                       exit 1;
                   }


            }
        }
    }
}
}
