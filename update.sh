#!/bin/bash
clear
#DEFINED COLOR SETTINGS
RED=$(tput setaf 1 && tput bold)
GREEN=$(tput setaf 2 && tput bold)
STAND=$(tput sgr0)
BLUE=$(tput setaf 6 && tput bold)
logfile="/root/installerscript.log"
echo $RED "                        ====== Downloading helper.sh ======"
wget -O /usr/bin/helper.sh https://raw.githubusercontent.com/Sibren27/Kali_updater/master/includes/helper.sh -q
echo $GREEN"                             ====== SUCCESS ======"
sleep 2
echo ""
#!/bin/bash
. /usr/bin/helper.sh
clear

echo ""
echo ""
echo ""
echo $RED"              +##############################################+"
echo $RED"              +      smetsys Kali Linux Update Script        +"
echo $RED"              +                                              +"
echo $RED"              +                  Version 1.0                 +"
echo $RED"              +                                              +"
echo $RED"              +   https://github.com/Sibren27/Kali_updater   +"
echo $RED"              +##############################################+"
echo ""
echo $BLUE"     Visit https://github.com/Sibren27/Kali_updater for updates to this script. Thanks"
echo ""
echo $BLUE"        This script will perform various updates and configure Kali "$STAND
sleep 3
clear
check_euid

network_manager(){
    if ask "Fix network manager?" Y; then
       service network-manager stop
       file=/etc/network/interfaces; [ -e $file ] && cp -n $file{,.bkup}      # ...or: /etc/NetworkManager/NetworkManager.conf
       sed  -i '/iface lo inet loopback/q' $file                              # ...or: sed -i 's/managed=.*/managed=true/' $file
       rm -f /var/lib/NetworkManager/NetworkManager.state
       service network-manager start
       sleep 4
    fi
}

htop(){
    if ask "Install HTOP?" Y; then
       apt-get -y install htop &>/dev/null
    fi
}

file-roller(){
    if ask "Install File-Roller?" Y; then
       apt-get -y install file-roller &>/dev/null
    fi
}

zip_unzip(){
    if ask "Install zip/unzip?" Y; then
       apt-get -y install zip &>/dev/null     # Compress
       apt-get -y install unzip &>/dev/null   # Decompress
    fi
}

bully(){
    if ask "Install bully ~ WPS brute force?" Y; then
       apt-get -y install install bully &>/dev/null 
    fi
}

unicornscan(){
    if ask "Installing Unicornscan ~ fast port scanner?" Y; then
       apt-get -y install unicornscan &>/dev/null 
    fi
}

py_pip3(){
    if ask "Python3 + pip?" Y; then
       apt-get -y install python3 &>/dev/null 
       apt-get -y install python3-pip &>/dev/null 
    fi
}

tools(){
    if ask "Download some tools?" Y; then
       wget -O /root/Desktop/default-themes-extra-1.cmtp.7z https://raw.githubusercontent.com/Sibren27/Kali_updater/master/includes/default-themes-extra-1.cmtp.7z -q
       wget -O /root/Desktop/RTL8187SetSpeed.sh https://raw.githubusercontent.com/Sibren27/Kali_updater/master/includes/RTL8187SPEED.sh -q
       chmod +x /root/Desktop/RTL8187SetSpeed.sh
    fi
}

lazykali(){
    if ask "Install lazykali.sh?" Y; then
       wget -O /usr/bin/lazykali https://lazykali.googlecode.com/files/lazykali.sh -q
       chmod +x /usr/bin/lazykali
    fi
}

flash(){
    if ask "Install Flash?" Y; then
       apt-get -y install flashplugin-nonfree &>/dev/null
       update-flashplugin-nonfree --install &>/dev/null
    fi
}

synaptic(){
    if ask "Install Synaptic Package Manager?" Y; then
       apt-get install synaptic -y &>/dev/null
    fi
}

WPScan(){
    if ask "Install WPScan?" Y; then
       cd /root &>/dev/null
       apt-get -y install libcurl4-gnutls-dev libopenssl-ruby libxml2 libxml2-dev libxslt1-dev ruby-dev &>/dev/null
       git clone https://github.com/wpscanteam/wpscan.git &>/dev/null
       cd /root/wpscan &>/dev/null
       gem install bundle &>/dev/null && bundle install &>/dev/null
       sleep 2
    fi
}

update_system(){
    print_status "[*] Updating the entire system."
    print_status "Performing apt-get update -y && apt-get upgrade"
    apt-get update -y && apt-get upgrade && apt-get -y dist-upgrade
    success_check
}

distupgrade_system(){
    if ask "Update & upgrade Kali Linux?" Y; then
       print_status "Performing apt-get update"
       apt-get update &>> $logfile
       success_check
       print_status "Performing apt-get upgrade"
       print_notification "This WILL take a while. I'm talking at least half an hour (probably longer) on a good connection and fast system. Be patient."
       print_notification "You can monitor the programs through running (in another terminal window):"
       print_notification "tail -f $logfile"
       apt-get -y dist-upgrade &>> $logfile
       success_check
	fi
}

bleeding_edge(){
  if ask "Switch to bleeding edge?" Y; then
    print_status "Adding kali bleeding edge repo to /etc/apt/sources.list.."
    out=`grep  "kali-bleeding-edge" /etc/apt/sources.list`
	fi
    if [[ "$out" !=  *kali-bleeding-edge* ]]; then
        echo "# bleeding edge repository" >> /etc/apt/sources.list
        echo "deb http://repo.kali.org/kali kali-bleeding-edge main" >> /etc/apt/sources.list
        echo "deb http://http.kali.org/kali kali main non-free contrib" >> /etc/apt/sources.list
        echo "deb http://security.kali.org/kali-security kali/updates main contrib non-free" >> /etc/apt/sources.listi
    fi
}

cleanup(){
    if ask "Clean up?" Y; then
        apt-get -y autoremove && apt-get -y clean
    fi
}

ssh(){
    if ask "Enable SSH?" Y; then
        update-rc.d ssh enable && update-rc.d ssh defaults
        /etc/init.d/ssh start
    fi
}

hostname(){
    if ask "Do you want a different hostname on every boot?" N; then
        grep -q "hostname" /etc/rc.local hostname || sed -i 's#^exit 0#hostname $(cat /dev/urandom | tr -dc "A-Za-z" | head -c8)\nexit 0#' /etc/rc.local
    fi
	}
	
numlock(){
    if ask "Do you want to enable numlock on boot?" N; then
        apt-get -y install numlockx &>/dev/null
        cp -n /etc/gdm3/Init/Default{,.bkup}
        grep -q '/usr/bin/numlockx' /etc/gdm3/Init/Default || sed -i 's#exit 0#if [ -x /usr/bin/numlockx ]; then\n/usr/bin/numlockx on\nfi\nexit 0#' /etc/gdm3/Init/Default
    fi
}

libs(){
    if [ `getconf LONG_BIT` = "64" ] ; then
        if ask "64-bit OS detected. Installing 32-bit libs?" Y; then
            dpkg --add-architecture i386 && apt-get update -y && apt-get install ia32-libs -y
            success_check
        fi
    fi
}

teamviewer(){
    if ask "Install Teamviewer?" Y; then
       apt-get -y install lib32asound2 &>/dev/null
       apt-get -y install lib32z1 &>/dev/null
       wget http://download.teamviewer.com/download/teamviewer_linux_x64.deb
       dpkg -i teamviewer_linux_x64.deb
       rm teamviewer_linux_x64.deb
    fi
}

vpn(){
    if ask "Install VPN support?" Y; then
       apt-get -y install network-manager-openvpn-gnome network-manager-pptp network-manager-pptp-gnome network-manager-strongswan network-manager-vpnc network-manager-vpnc-gnome ipsec-tools libart-2.0-2 libbonoboui2-0 libbonoboui2-common libfcgi0ldbl libgnomecanvas2-0 libgnomecanvas2-common libgnomeui-0 libgnomeui-common libstrongswan network-manager-openvpn pptp-linux strongswan-ikev2 strongswan-nm &>/dev/null
    fi
}

tor(){
    if ask "Install tor support?" Y; then
       apt-get -y install tor privoxy doc-base libyaml-tiny-perl tor-geoipdb torsocks
       apt-get -y install vidalia polipo
       echo "forward-socks4a / localhost:9050 ." >> /etc/privoxy/config
    fi
}

tor_startup(){
    if ask "Add tor to startup?" Y; then
       update-rc.d tor enable
       update-rc.d privoxy enable 
    fi
}

conky_manager(){
    if ask "Install conky + Manager?" Y; then
       wget -O /root/realpath_1.18_amd64.deb http://repo.kali.org/kali/pool/main/r/realpath/realpath_1.18_amd64.deb
       dpkg -i /root/realpath_1.18_amd64.deb
       rm realpath_1.18_amd64.deb
       apt-get -y install conky conky-std libaudclient2 libxmmsclient6 &>/dev/null
       wget -O /root/conky-manager-latest-amd64.deb https://launchpad.net/~teejee2008/+archive/ubuntu/ppa/+build/6548237/+files/conky-manager_2.3.3%7E132%7Eubuntu15.04.1_amd64.deb
       dpkg -i --ignore-depends=libglib2.0-0 /root/conky-manager-latest-amd64.deb
       rm /root/conky-manager-latest-amd64.deb
    fi
}

complete(){
    if ask "Reboot system now" Y; then
    reboot 
    fi
}

network_manager
htop
file-roller
zip_unzip
bully
unicornscan
py_pip3
tools
lazykali
flash
synaptic
WPScan
libs
ssh
hostname
numlock
bleeding_edge
teamviewer
conky_manager
vpn
tor
tor_startup
cleanup
distupgrade_system
cleanup

print_status "all installations and updates complete."

complete

exit 0
