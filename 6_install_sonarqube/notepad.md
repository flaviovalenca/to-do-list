# Neste passo vamos instalar e configurar o SonarQube

Baixar a imagem sonarqube
```bash
docker pull sonarqube:lts-community
```
Start no container do SonarQube
```bash
docker run -d --name sonarqube -p 9000:9000 sonarqube:lts-community
```

Script para rodar o SonarQube
```bash
#!/bin/bash

apt update -y
apt install wget -y
wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-6.2.1.4610-linux-x64.zip
unzip sonar-scanner-cli-6.2.1.4610-linux-x64.zip
./sonar-scanner-6.2.1.4610-linux-x64/bin/sonar-scanner  -X \
  -Dsonar.projectKey=XXXXXXXXX \
  -Dsonar.sources=. \
  -Dsonar.host.url=http://18.230.82.33:9000 \
  -Dsonar.login=sqp_3d1c346b4539c1d7aa98e41d74025753cb4110dd
```