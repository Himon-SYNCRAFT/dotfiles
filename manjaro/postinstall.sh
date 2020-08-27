#!/bin/bash

cd ~

home_dir=`pwd`
projects_dir=$home_dir/Projects

RED='\033[0;31m'
NC='\033[0m' # No Color

sudo pacman -Syyuu --noconfirm

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

echo ""
echo -e "${RED}installing yay${NC}"
git clone https://aur.archlinux.org/yay.git
chown -R $USER:$USER $projects_dir/*
cd $projects_dir/yay
makepkg -si
cd $home_dir/

ln -s $projects_dir/dotfiles/.vimrc $home_dir/.vimrc
ln -s $projects_dir/dotfiles/.tmux.conf $home_dir/.tmux.conf
ln -s $projects_dir/dotfiles/alacritty.yml $home_dir/.alacritty.yml
ln -s $projects_dir/dotfiles/picom.conf $home_dir/.config/picom.conf
ln -s $projects_dir/dotfiles/polybar $home_dir/.config/polybar

echo ""
echo -e "${RED}installing networkmanager${NC}"
sudo pacman -Sq --noconfirm networkmanager

echo ""
echo -e "${RED}installing vim${NC}"
sudo pacman -Sq --noconfirm gvim

ln -s $projects_dir/dotfiles/UltiSnips/ $projects_dir/.vim/UltiSnips

echo ""
echo -e "${RED}installing tmux${NC}"
sudo pacman -Sq --noconfirm tmux
git clone https://github.com/tmux-plugins/tpm $home_dir/.tmux/plugins/tpm

echo ""
echo -e "${RED}installing alacritty${NC}"
sudo pacman -Sq --noconfirm alacritty

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
echo -e "${RED}installing google-chrome${NC}"
yay -S --noconfirm google-chrome

echo ""
echo -e "${RED}installing brave${NC}"
yay -S --noconfirm brave

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
sudo pacman -Sq --noconfirm jre8-openjdk
sudo pacman -Sq --noconfirm jre11-openjdk
sudo pacman -Sq --noconfirm jre14-openjdk

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
echo -e "${RED}installing rescutime${NC}"
yay -S --noconfirm rescuetime2

echo ""
echo -e "${RED}installing bspwm${NC}"
sudo pacman -Sq --noconfirm i3-gaps nitrogen dmenu picom
yay -S --noconfirm polybar

echo ""
echo -e "${RED}installing nerd fonts${NC}"
yay -S --noconfirm nerd-fonts-complete

echo ""
echo -e "${RED}cli apps: neofetch cmus htpo pipes${NC}"
sudo pacman -Sq --noconfirm cmus htop ranger
yay -S --noconfirm pfetch

echo ""
echo -e "${RED}vpn utils${NC}"
sudo pacman -Sq --noconfirm strongswan xl2tpd
