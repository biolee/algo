# mock Mocktio+PowerMock

# Jenkins


```bash
# https://docs.gitlab.com/omnibus/docker/
docker run -d -it --name some-jenkins \
	-p 8080:8080 \
	-v ${JENKINS_HOME}:/var/jenkins_home 
	-v /var/run/docker.sock:/var/run/docker.sock \
	jenkinsci/blueocean
# OR

# ubuntu install
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
# Then add the following entry in your /etc/apt/sources.list:/etc/apt/sources.list
deb https://pkg.jenkins.io/debian-stable binary/

## install and update
sudo apt-get update
sudo apt-get install jenkins

#/etc/sysconfig/jenkins
#/etc/init.d/jenkins
sudo vim /etc/sysconfig/jenkins
# change JENKINS_HOME
sudo chown jenkins:jenkins jenkins_home -R
sudo /etc/init.d/jenkins start
# get password
sudo cat /var/log/jenkins/jenkins.log
usermod -a -G docker jenkinis
groups jenkins
```

# Sonar
## data
- sonarqube_conf:/opt/sonarqube/conf
- sonarqube_data:/opt/sonarqube/data
- sonarqube_extensions:/opt/sonarqube/extensions
- sonarqube_bundled-plugins:/opt/sonarqube/lib/bundled-plugins

```bash
export SONAR_HOST=""

docker run -d -it --name some-postgres \
	-e POSTGRES_PASSWORD=sonar \
	-e POSTGRES_USER=sonar \
	-e POSTGRES_DB=sonar \
	-e PGDATA=/var/lib/postgresql/data/pgdata  \
	-p 5432:5432 \
	postgres

docker run -d -it --name sonarqube \
	-p 9000:9000 -p 9092:9092 \
	-e SONARQUBE_JDBC_USERNAME=sonar \
	-e SONARQUBE_JDBC_PASSWORD=sonar \
	-e SONARQUBE_JDBC_URL=jdbc:postgresql://${SONAR_HOST}/sonar \
	sonarqube

# Use with Jenkins
# https://docs.sonarqube.org/display/SCAN/Analyzing+with+SonarQube+Scanner+for+Jenkins

# use commandline
mvn sonar:sonar \
  -Dsonar.host.url=http://${SONAR_HOST}:9000 \
  -Dsonar.jdbc.url=jdbc:postgresql://${SONAR_HOST}/sonar

mvn sonar:sonar \
  -Dsonar.host.url=http://10.0.7.102:9000 \
  -Dsonar.login=${TOKEN}

sonar-scanner \
  -Dsonar.projectKey=scrapy \
  -Dsonar.sources=. \
  -Dsonar.host.url=http://10.0.7.102:9000 \
  -Dsonar.login=${TOKEN}
```

# Concept
- 单元测试 Unit Test testing a class in isolation of the others
- 集成测试 Integration Test
- 冒烟测试 Smoke Test
	- smoke test是比较初级的测试(a quick test)，仅仅是为了检查各个组件是否能一起工作，而并不去深究功能上是否正确
	- 注意smoke test一般是大范围的集成测试。通常可以是整个系统/端到端的测试
- 回归测试 Regression Test
	- 一种认为回归测试是为了覆盖fix的bug
	- 一种认为回归测试是覆盖新添加的功能
- 端到端测试 End-To-End Test
- 功能测试 Functional Test
- 非功能测试 Non-funtional Test
- Acceptance testing
- CI (Continuous Integration)

# lib
## artifactory
```bash
docker pull docker.bintray.io/jfrog/artifactory-oss:latest
docker run --name artifactory-oss -d \
	-v /var/opt/jfrog/artifactory:/var/opt/jfrog/artifactory \
	-p 8081:8081 \
	docker.bintray.io/jfrog/artifactory-oss:latest
docker run -it --entrypoint=/bin/bash \
	-v /var/opt`/jfrog/artifactory:/var/opt/jfrog/artifactory \
	-p 8081:8018 \
	docker.bintray.io/jfrog/artifactory-oss:latest
```

#!groovy

pipeline {
    agent {
        label 'master'
    }
    environment {
        TEST_DB_ENGINE = 'mysql'
        TEST_DB_HOST = ""
        TEST_DB_PASSWD = ""
        TEST_DB_NAME = ""
//        AN_ACCESS_KEY = credentials('my-prefined-secret-text')
    }

    stages {
        stage('Build') {
            agent {
                label 'master'
            }
            steps {
                echo "No build Now"
            }
        }

        stage("docker file") {
            agent { dockerfile true }
            steps {
                sh "uname -a"
            }
        }

        stage('Cheep Test') {
            when {
                branch 'master'
            }
            failFast true
            parallel {
                stage('Unit Test') {
                    agent {
                        label "master"
                    }
                    steps {
                        echo "Unit Test"
                    }
                }

                stage('Integration Test') {
                    agent {
                        docker {
                            image 'golang:1.9'
                            label "master"
                            args '-v /var/run/docker.sock:/var/run/docker.sock'
                        }
                    }
                    steps {
                        sh "make test"
                    }
                }
            }
        }

        stage('Expensive Test') {
            when {
                branch 'master'
            }
            failFast true
            parallel {
                stage('End to End Test') {
                    agent {
                        label "master"
                    }
                    steps {
                        echo "End to End Test"
                    }
                }

                stage('Regression Test') {
                    agent {
                        label "master"
                    }
                    steps {
                        echo "Regression TestRegression Test"
                    }
                }

                stage('Regression Test') {
                    agent {
                        dockerfile {
                            dir '.'
                            additionalBuildArgs '-f server/test_dockerfile/Dockerfile -t latest'
                        }
                    }
                    steps {
                        echo "Regression TestRegression Test"
                    }
                }

                agent { dockerfile { dir 'someSubDir' } }
            }

        }

        stage("Deploy") {
            when {
                allOf {
                    branch 'master';
                    environment name: 'DEPLOY_TO', value: 'production'
                }
            }
            steps {
                echo "no deploy now"
            }
        }
    }

    post {
        always {
            echo 'CI finish!'
        }
        changed {
            echo "Only run if the current Pipeline run has a different status from the previously completed Pipeline."
        }
        failure {
            echo "Only run if the current Pipeline has a \"failed\" status, typically denoted in the web UI with a red indication."
        }
        success {
            echo "Only run if the current Pipeline has a \"success\" status, typically denoted in the web UI with a blue or green indication."
        }
        unstable {
            echo "Only run if the current Pipeline has an \"unstable\" status, usually caused by test failures, code violations, etc. Typically denoted in the web UI with a yellow indication."
        }
        aborted {
            echo "Only run if the current Pipeline has an \"aborted\" status, usually due to the Pipeline being manually aborted. Typically denoted in the web UI with a gray indication.\n"
        }
    }
}

//node {
//    checkout scm
//    docker.withRegistry('https://registry.example.com', 'credentials-id') {
//        def customImage = docker.build("my-image:${env.BUILD_ID}")
//
//        customImage.inside {
//            sh 'make test'
//        }
//
//        /* Push the container to the custom Registry */
//        customImage.push()
//        customImage.push('latest')
//    }
//}


//node {
//    checkout scm
//    docker.image('mysql:5').withRun('-e "MYSQL_ROOT_PASSWORD=my-secret-pw"') { c ->
//        docker.image('mysql:5').inside("--link ${c.id}:db") {
//            /* Wait until mysql service is up */
//            sh 'while ! mysqladmin ping -hdb --silent; do sleep 1; done'
//        }
//        docker.image('centos:7').inside("--link ${c.id}:db") {
//            /*
//            * Run some tests which require MySQL, and assume that it is
//            * available on the host name `db`
//            */
//            sh 'make check'
//        }
//    }
//}