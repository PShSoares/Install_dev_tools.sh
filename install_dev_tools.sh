#!/bin/bash

# Atualizar o sistema
sudo apt update && sudo apt upgrade -y

# Instalar pacotes básicos
sudo apt install -y curl wget gnupg software-properties-common

# Determinar o nome de usuário atual
USER_NAME=$(whoami)

# Adicionar o usuário atual aos grupos docker e netdev
sudo usermod -aG docker $USER_NAME
sudo usermod -aG netdev $USER_NAME

# Instalar IntelliJ IDEA Ultimate
sudo snap install intellij-idea-ultimate --classic

# Instalar DBeaver
sudo apt install -y dbeaver-ce

# Instalar Jaspersoft
# Não há pacote oficial no repositório, você pode fazer o download do site oficial e seguir as instruções

# Instalar Docker
sudo apt install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker

# Instalar SQL Server no Docker
sudo docker pull mcr.microsoft.com/mssql/server

# Instalar Postman
sudo snap install postman

# Instalar Insomnia
sudo snap install insomnia

# Instalar Android Studio
wget https://dl.google.com/android/studio/ide-zips/2024.1.1.0/android-studio-2024.1.1.0-linux.tar.gz
sudo tar -xzf android-studio-2024.1.1.0-linux.tar.gz -C /opt/
sudo ln -s /opt/android-studio/bin/studio.sh /usr/local/bin/android-studio

# Instalar Gerenciador de Clipboard (Clipboard Manager)
sudo apt install -y dconf-cli

# Instalar Flameshot
sudo apt install -y flameshot

# Instalar Sublime Text
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
sudo apt-add-repository "deb https://download.sublimetext.com/ apt/stable/"
sudo apt update
sudo apt install -y sublime-text

# Instalar VSCode
wget -qO - https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt update
sudo apt install -y code

# Instalar OBS Studio
sudo apt install -y obs-studio

# Instalar SoapUI
wget https://github.com/SmartBear/soapui/releases/download/5.7.0/SoapUI-5.7.0-linux-bin.tar.gz
sudo tar -xzf SoapUI-5.7.0-linux-bin.tar.gz -C /opt/
sudo ln -s /opt/SoapUI-5.7.0/bin/soapui.sh /usr/local/bin/soapui

# Instalar Remmina
sudo apt install -y remmina

# Instalar Google Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install -y ./google-chrome-stable_current_amd64.deb

# Instalar ngrok
wget https://bin.equinox.io/c/4b2bf8d4d4fd/ngrok-stable-linux-amd64.zip
unzip ngrok-stable-linux-amd64.zip
sudo mv ngrok /usr/local/bin/

# Instalar Jaspersoft
# O Jaspersoft também precisa ser baixado do site oficial e instalado manualmente

# Instalar scrcpy
sudo apt install -y scrcpy

echo "Instalação concluída! Por favor, reinicie o sistema para aplicar as alterações."

