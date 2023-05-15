pipeline {
	agent { 
		docker {
			image 'node:16.20.0-alpine' 
			args '-u root:root'
			// args '--tmpfs /usr'
		} 
	}
	stages {
		stage('Installing SonaQube Scanner') {
			steps {
				sh 'apk update'
				sh 'apk add --no-cache openjdk11-jre'
				// sh 'curl https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.8.0.2856-linux.zip -o sonar-scanner.zip'
				sh 'apk add --no-cache \
  					ca-certificates \
  					curl'
				sh 'mkdir -p /opt'
				sh 'curl https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.8.0.2856.zip -o /opt/sonar-scanner.zip'
				sh 'unzip /opt/sonar-scanner.zip -d /opt'
				sh 'rm /opt/sonar-scanner.zip'
				sh 'ln -s /opt/sonar-scanner-4.8.0.2856/bin/sonar-scanner /usr/bin/sonar-scanner'
			}
		}
		stage('Starting the SonarQube Scan...') {
			steps {
				withCredentials([string(credentialsId: 'sonar-hadiya-frontend', variable: 'SONARKEY')]) {
					sh 'sonar-scanner \
						-Dsonar.exclusions="**/node_modules/**/*,**/*.spec.ts" \
  						-Dsonar.projectKey=hadiya-node-16 \
  						-Dsonar.sources=. \
						-Dsonar.projectVersion=0.1 \
  						-Dsonar.host.url=https://sonar.prasaddevops.cloud \
  						-Dsonar.login=$SONARKEY'
				}
			}
		}
		stage('Cleaning Cache...') {
			steps {
				// sh 'npm install -g npm@latest'
				sh 'npm cache clean --force'
			}
		}
		stage('Installing Depedencies...') {
			steps {
				// sh 'cd products_admin'
				// sh 'pwd'
				sh 'npm install -g @angular/cli'
				sh 'npm install'
				// sh 'ls'
				// sh 'wtf'
			}
		}
		stage('Building the code...') {
			steps {
				sh 'ng build'
			}
		}
	}
	post {
		always {
			archiveArtifacts artifacts: 'dist/hadiya_products_admin/*', 
			onlyIfSuccessful: true
		}
	}
}