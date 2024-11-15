FROM jenkins/jenkins
USER root
RUN apt-get update -qq \
 && apt-get install -qqy apt-transport-https ca-certificates vim curl gnupg2 software-properties-common
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
RUN apt-get update  -qq \
 && apt-get -y install docker-ce
RUN usermod -aG docker jenkins

WORKDIR /home

# docker run -d -p 8080:8080 --name jenkins -v /var/run/docker.sock:/var/run/docker.sock dockerindocker
# ssh -T git@github.com

# mandar arquivos para o servidor via scp
# scp -i ~/.ssh/jenkins.pem -r * ubuntu@ec2-54-233-171-105.sa-east-1.compute.amazonaws.com:/home/ubuntu
