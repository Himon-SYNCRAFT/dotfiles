#!/bin/bash

cd ~

home_dir=`pwd`
projects_dir=$home_dir/Projects

RED='\033[0;31m'
NC='\033[0m' # No Color

sudo pacman -Syyu --noconfirm

echo ""
echo -e "${RED}make dir for projects${NC}"
mkdir $projects_dir

echo ""
echo -e "${RED}installing git${NC}"
sudo pacman -Sq --noconfirm git

cd $projects_dir
chown $USER:$USER $projects_dir

echo ""
echo -e "${RED}fetching dotfiles${NC}"
git clone https://github.com/Himon-SYNCRAFT/dotfiles.git
sudo pacman -Sq --noconfirm stow

echo ""
echo -e "${RED}installing st${NC}"
git clone https://github.com/Himon-SYNCRAFT/st.git
cd $projects_dir/st
make clean install
cd $projects_dir

echo ""
echo -e "${RED}installing dmenu${NC}"
git clone https://github.com/Himon-SYNCRAFT/dmenu.git
cd $projects_dir/dmenu
make clean install
cd $projects_dir

echo ""
echo -e "${RED}installing tabbed${NC}"
git clone https://github.com/Himon-SYNCRAFT/tabbed.git
cd $projects_dir/tabbed
make clean install
cd $projects_dir

echo ""
echo -e "${RED}installing yay${NC}"
git clone https://aur.archlinux.org/yay.git
chown -R $USER:$USER $projects_dir/*
cd $projects_dir/yay
makepkg -si
cd $home_dir/

echo ""
echo -e "${RED}installing networkmanager${NC}"
sudo pacman -Sq --noconfirm networkmanager network-manager-applet

echo ""
echo -e "${RED}installing cmake${NC}"
sudo pacman -Sq --noconfirm cmake make

echo ""
echo -e "${RED}installing vim${NC}"
sudo pacman -Sq --noconfirm nvim

echo ""
echo -e "${RED}installing fish shell${NC}"
sudo pacman -Sq --noconfirm fish

echo ""
echo -e "${RED}installing virtualenv${NC}"
pip install virtualenv

echo ""
echo -e "${RED}installing nodejs${NC}"
sudo pacman -Sq --noconfirm nodejs

echo ""
echo -e "${RED}installing yarn${NC}"
sudo pacman -Sq --noconfirm yarn

echo ""
echo -e "${RED}installing ripgrep${NC}"
sudo pacman -Sq --noconfirm ripgrep

echo ""
echo -e "${RED}installing brave${NC}"
sudo pacman -Sq --noconfirm brave

echo ""
echo -e "${RED}installing qutebrowser${NC}"
sudo pacman -Sq --noconfirm qutebrowser

echo ""
echo -e "${RED}installing gimp${NC}"
sudo pacman -Sq --noconfirm gimp

echo ""
echo -e "${RED}installing inkscape${NC}"
sudo pacman -Sq --noconfirm inkscape

echo ""
echo -e "${RED}installing java${NC}"
sudo pacman -Sq --noconfirm jdk8-openjdk
sudo pacman -Sq --noconfirm jdk11-openjdk
sudo pacman -Sq --noconfirm jdk14-openjdk
sudo pacman -Sq --noconfirm maven

echo ""
echo -e "${RED}installing postgres${NC}"
sudo pacman -Sq --noconfirm postgresql

echo ""
echo -e "${RED}installing calibre${NC}"
sudo pacman -Sq --noconfirm calibre

echo ""
echo -e "${RED}installing obs-studio${NC}"
sudo pacman -Sq --noconfirm obs-studio

echo ""
echo -e "${RED}installing audacity${NC}"
sudo pacman -Sq --noconfirm audacity

echo ""
echo -e "${RED}installing ms teams${NC}"
yay -S --noconfirm teams

echo ""
echo -e "${RED}installing intellij toolbox${NC}"
cd $projects_dir
wget https://download.jetbrains.com/toolbox/jetbrains-toolbox-1.17.7391.tar.gz
tar -xvzf jetbrains-toolbox-1.17.7391.tar.gz
chown -R $USER:$USER $projects_dir/*
cd $home_dir/

echo ""
echo -e "${RED}installing dbeaver${NC}"
sudo pacman -Sq --noconfirm dbeaver

echo ""
echo -e "${RED}installing window manager${NC}"
sudo pacman -Sq --noconfirm bspwm sxhkd nitrogen picom betterlockscreen birdtray
yay -S --noconfirm polybar

echo ""
echo -e "${red}installing thunderbird${nc}"
sudo pacman -sq --noconfirm thunderbird

echo ""
echo -e "${red}installing caffeine${nc}"
yay -S --noconfirm caffeine

echo ""
echo -e "${RED}installing fonts${NC}"
sudo pacman -Sq --noconfirm otf-font-awesome
yay -S --noconfirm nerd-fonts-hack ttf-material-design-icons nerd-fonts-source-code-pro nerd-fonts-jetbrains-mono

echo ""
echo -e "${RED}cli apps${NC}"
sudo pacman -Sq --noconfirm cmus ranger lm_sensors dunst ueberzug bat tree unclutter exa diff-so-fancy
yay -S --noconfirm gotop

echo ""
echo -e "${RED}vpn utils${NC}"
sudo pacman -Sq --noconfirm strongswan xl2tpd

echo ""
echo -e "${RED}audio utils${NC}"
sudo pacman -Sq --noconfirm pavucontrol pulsemixer

echo ""
echo -e "${RED}zathura${NC}"
sudo pacman -Sq --noconfirm zathura zathura-pdf-mupdf

$projects_dir/dotfiles/stowall.sh
