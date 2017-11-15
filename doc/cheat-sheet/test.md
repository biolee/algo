# mock Mocktio+PowerMock

# Jenkins


```bash
docker run -d -it -p 10282:8080 \
	-p 50000:50000 \
	-v ${JENKINS_HOME}:/var/jenkins_home
	registry.docker-cn.com/library/jenkins:2.60.3
# OR

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