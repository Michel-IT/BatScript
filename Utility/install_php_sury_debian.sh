#!/bin/bash

# Colori per il menu
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Funzione per aggiungere i repository Sury
add_sury_repo() {
    echo -e "${YELLOW}Aggiunta repository Sury per PHP...${NC}"
    apt install -y apt-transport-https lsb-release ca-certificates curl
    curl -sSLo /usr/share/keyrings/deb.sury.org-php.gpg https://packages.sury.org/php/apt.gpg
    sh -c 'echo "deb [signed-by=/usr/share/keyrings/deb.sury.org-php.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'
    apt update
    echo -e "${GREEN}Repository Sury aggiunto con successo!${NC}"
}

# Funzione per installare le versioni PHP
install_php_versions() {
    echo -e "${YELLOW}Installazione delle versioni PHP...${NC}"
    
    PHP_VERSIONS=("8.2" "8.1" "8.0" "7.4" "7.3" "7.2" "7.1" "7.0" "5.6")
    PHP_MODULES="fpm mysql curl gd intl mbstring xml zip soap cli opcache ldap imap redis"
    
    for version in "${PHP_VERSIONS[@]}"; do
        echo -e "${YELLOW}Installazione PHP $version...${NC}"
        modules=""
        for module in $PHP_MODULES; do
            modules="$modules php$version-$module"
        done
        apt install -y php$version $modules
    done
    
    echo -e "${GREEN}Tutte le versioni PHP sono state installate!${NC}"
}

# Funzione per abilitare i servizi FPM
enable_fpm_services() {
    echo -e "${YELLOW}Abilitazione servizi FPM...${NC}"
    
    PHP_VERSIONS=("5.6" "7.0" "7.1" "7.2" "7.3" "7.4" "8.0" "8.1" "8.2")
    
    for version in "${PHP_VERSIONS[@]}"; do
        echo "Abilitazione PHP $version-fpm..."
        systemctl enable php$version-fpm
        systemctl start php$version-fpm
    done
    
    echo -e "${GREEN}Tutti i servizi FPM sono stati abilitati!${NC}"
}

# Funzione per configurare Apache
configure_apache() {
    echo -e "${YELLOW}Configurazione Apache per PHP-FPM...${NC}"
    
    a2enmod proxy_fcgi setenvif
    PHP_VERSIONS=("5.6" "7.0" "7.1" "7.2" "7.3" "7.4" "8.0" "8.1" "8.2")
    
    for version in "${PHP_VERSIONS[@]}"; do
        echo "Configurazione PHP $version per Apache..."
        a2enconf php$version-fpm
    done
    
    systemctl restart apache2
    echo -e "${GREEN}Apache configurato con successo!${NC}"
}

# Funzione per il menu principale
show_menu() {
    clear
    echo -e "${YELLOW}=== MENU INSTALLAZIONE PHP MULTIPLO ===${NC}"
    echo "1) Aggiungi repository Sury per PHP"
    echo "2) Installa le versioni PHP (5.6 - 8.2)"
    echo "3) Abilita servizi FPM"
    echo "4) Configura Apache per PHP-FPM"
    echo "5) Esegui tutto"
    echo "0) Esci"
    echo -e "${YELLOW}=======================================${NC}"
}

# Loop principale
while true; do
    show_menu
    read -p "Seleziona un'opzione [0-5]: " choice
    
    case $choice in
        1)
            add_sury_repo
            read -p "Premi Enter per continuare..."
            ;;
        2)
            install_php_versions
            read -p "Premi Enter per continuare..."
            ;;
        3)
            enable_fpm_services
            read -p "Premi Enter per continuare..."
            ;;
        4)
            configure_apache
            read -p "Premi Enter per continuare..."
            ;;
        5)
            echo -e "${YELLOW}Esecuzione di tutte le operazioni...${NC}"
            add_sury_repo
            install_php_versions
            enable_fpm_services
            configure_apache
            echo -e "${GREEN}Tutte le operazioni completate con successo!${NC}"
            read -p "Premi Enter per continuare..."
            ;;
        0)
            echo -e "${GREEN}Uscita dal programma. Arrivederci!${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Opzione non valida!${NC}"
            read -p "Premi Enter per continuare..."
            ;;
    esac
done
