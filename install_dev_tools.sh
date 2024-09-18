#!/bin/bash

# Configuração do arquivo de log
LOG_FILE="/var/log/install_dev_tools.log"
exec > >(tee -i $LOG_FILE)
exec 2>&1

# Função para instalar pacotes via download de .deb ou outros instaladores
install_deb_package() {
    url=$1
    temp_file="/tmp/$(basename $url)"
    wget -O "$temp_file" "$url"
    sudo dpkg -i "$temp_file"
    sudo apt-get install -f -y  # Corrigir dependências
    rm "$temp_file"
}

# Função para adicionar repositório e instalar pacotes via apt
install_apt_package() {
    package_name=$1
    if ! dpkg -l | grep -q "$package_name"; then
        echo "Instalando $package_name..."
        sudo apt install -y "$package_name"
    else
        echo "$package_name já está instalado."
    fi
}

# 1. Verificação de dependências (wget, curl, git)
echo "Verificando dependências..."
sudo apt update
sudo apt install -y wget curl git

# Docker
if ! command -v docker &> /dev/null; then
    echo "Instalando Docker..."
    sudo apt install -y \
        ca-certificates \
        curl \
        gnupg \
        lsb-release

    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
else
    echo "Docker já está instalado."
fi

# Adicionar usuário ao grupo Docker para usar sem sudo
if ! getent group docker > /dev/null; then
    sudo groupadd docker
fi
sudo usermod -aG docker $(whoami)

# IntelliJ IDEA Ultimate
echo "Baixando e instalando IntelliJ IDEA Ultimate..."
install_deb_package https://download.jetbrains.com/idea/ideaIU-2023.2.1-no-jbr.tar.gz

# Visual Studio Code
echo "Baixando e instalando Visual Studio Code..."
install_deb_package https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64

# DBeaver
echo "Baixando e instalando DBeaver..."
install_deb_package https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb

# Postman
echo "Baixando e instalando Postman..."
install_deb_package https://dl.pstmn.io/download/latest/linux64

# SoapUI
echo "Baixando e instalando SoapUI..."
install_deb_package https://s3.amazonaws.com/downloads.eviware/soapuios/5.7.0/SoapUI-x64-5.7.0.sh

# Remmina
echo "Instalando Remmina via apt..."
install_apt_package remmina

# Google Chrome
echo "Baixando e instalando Google Chrome..."
install_deb_package https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

# Android Studio
echo "Baixando e instalando Android Studio..."
install_deb_package https://r3---sn-uxaapm-5fjl.gvt1.com/edgedl/android/studio/install/2023.1.1.0/android-studio-2023.1.1-linux.deb

# Ngrok
echo "Baixando e instalando Ngrok..."
install_deb_package https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-stable-linux-amd64.deb

# Jaspersoft Studio
echo "Baixando e instalando Jaspersoft Studio..."
install_deb_package https://sourceforge.net/projects/jasperstudio/files/JaspersoftStudio-6.20.0/TIB_js-studiocomm_6.20.0_linux_amd64.deb/download

# Sublime Text
echo "Baixando e instalando Sublime Text..."
install_deb_package https://download.sublimetext.com/sublime-text_build-3211_amd64.deb

# Notepad++
echo "Instalando Notepad++ com Wine..."
install_apt_package wine
wget -O /tmp/notepad++_installer.exe https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.5.5/npp.8.5.5.Installer.exe
wine /tmp/notepad++_installer.exe
rm /tmp/notepad++_installer.exe

# Clipman (gerenciador de clipboard)
echo "Instalando Clipman..."
install_apt_package xfce4-clipman-plugin

# guiscrcpy
echo "Instalando guiscrcpy..."
sudo add-apt-repository -y ppa:phillw/ppa
sudo apt update
install_apt_package guiscrcpy

# Adicionar o usuário ao grupo devnet
USER_NAME=$(whoami)
GROUP_NAME="devnet"

# Verificar se o grupo já existe, senão criar
if ! getent group $GROUP_NAME > /dev/null; then
    echo "Grupo $GROUP_NAME não existe. Criando o grupo..."
    sudo groupadd $GROUP_NAME
else
    echo "Grupo $GROUP_NAME já existe."
fi

# Verificar se o usuário já está no grupo, senão adicionar
if id -nG "$USER_NAME" | grep -qw "$GROUP_NAME"; then
    echo "Usuário $USER_NAME já está no grupo $GROUP_NAME."
else
    echo "Adicionando $USER_NAME ao grupo $GROUP_NAME..."
    sudo usermod -aG $GROUP_NAME $USER_NAME
    echo "Usuário $USER_NAME adicionado ao grupo $GROUP_NAME."
fi

echo "Instalação completa de todos os programas e usuário adicionado ao grupo $GROUP_NAME!"
