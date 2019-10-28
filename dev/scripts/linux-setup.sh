# install go 1.11.13
sudo snap install go --channel=1.11/stable --classic

# install dependencies
sudo apt update
sudo apt upgrade
sudo apt install make gcc

# install open JDK & maven
sudo apt install default-jdk
sudo apt install maven
echo 'export JAVA_HOME=/usr/lib/jvm/java-1.11.0-openjdk-amd64' >>~/.bash_profile

# build Quorum
git clone https://github.com/jpmorganchase/quorum.git
cd quorum
make all
echo 'export PATH=$PATH:/home/ubuntu/quorum/build/bin' >>~/.bash_profile
cd ~

# build Tessera
git clone https://github.com/jpmorganchase/tessera.git
cd tessera
git checkout tessera-0.10.1
mvn install
echo 'export TESSERA_JAR=~/tessera/tessera-dist/tessera-app/target/tessera-app-0.10.1-jdk11_app.jar' >>~/.bash_profile
cd ~

source .bash_profile