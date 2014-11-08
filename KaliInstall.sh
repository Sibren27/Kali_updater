#!/bin/bash
clear
#DEFINED COLOR SETTINGS
RED=$(tput setaf 1 && tput bold)
GREEN=$(tput setaf 2 && tput bold)
STAND=$(tput sgr0)
BLUE=$(tput setaf 6 && tput bold)
echo $RED "                        ====== Downloading helper.sh ======"
wget -O /usr/bin/helper.sh http://www.sbrn.nl/Kali/helper.sh -q
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
echo $RED"              +      Smetsys Kali Linux Update Script        +"
echo $RED"              +                                              +"
echo $RED"              +                  Version 1.0                 +"
echo $RED"              +                                              +"
echo $RED"              +               www.Smetsys.nl                 +"
echo $RED"              +##############################################+"
echo ""
echo $BLUE"     Visit http://www.smetsys.nl for updates to this script. Thanks"
echo ""
echo $BLUE"        This script will perform various updates and configure Kali "$STAND
sleep 3
clear
check_euid
#-----------------------------------------------------------------------------------------------------------------------------------

##### Fixing network manager
echo $RED "                        ====== Fixing network manager ======"
service network-manager stop
file=/etc/network/interfaces; [ -e $file ] && cp -n $file{,.bkup}      # ...or: /etc/NetworkManager/NetworkManager.conf
sed  -i '/iface lo inet loopback/q' $file                              # ...or: sed -i 's/managed=.*/managed=true/' $file
rm -f /var/lib/NetworkManager/NetworkManager.state
service network-manager start
sleep 10
echo $GREEN"                             ====== SUCCESS ======"
sleep 2
echo ""
#-----------------------------------------------------------------------------------------------------------------------------------

##### Installing htop ~ cli process viewer
echo $RED "                        ====== Installing Htop ======"
apt-get -y install htop &>/dev/null
echo $GREEN"                             ====== SUCCESS ======"
sleep 2
echo ""
#-----------------------------------------------------------------------------------------------------------------------------------

##### Installing File-Roller
echo $RED "                        ====== Installing file-roller ======"
apt-get -y install file-roller &>/dev/null
echo $GREEN"                             ====== SUCCESS ======"
sleep 2
echo ""
#--

##### Installing zip/unzip ~ cli file extractor
echo $RED "                        ====== Installing zip/unzip ======"
apt-get -y install zip &>/dev/null     # Compress
apt-get -y install unzip &>/dev/null   # Decompress
echo $GREEN"                             ====== SUCCESS ======"
sleep 2
echo ""
#-----------------------------------------------------------------------------------------------------------------------------------


##### Installing bully ~ WPS brute force
echo $RED "                        ====== Installing Bully ======"
apt-get -y install install bully &>/dev/null 
echo $GREEN"                             ====== SUCCESS ======"
sleep 2
echo ""
#-----------------------------------------------------------------------------------------------------------------------------------


##### Installing unicornscan ~ fast port scanner
echo $RED "                        ====== Installing Unicornscan ======"
apt-get -y install unicornscan &>/dev/null 
echo $GREEN"                             ====== SUCCESS ======"
sleep 2
echo ""
#-----------------------------------------------------------------------------------------------------------------------------------

##### Installing Python3 + pip 
echo $RED "                        ====== Installing Python 3 + pip ======"
apt-get -y install python3 python3-pip &>/dev/null 
apt-get -y install python3-pip &>/dev/null 
echo $GREEN"                             ====== SUCCESS ======"
sleep 2
echo ""
#-----------------------------------------------------------------------------------------------------------------------------------

##### Download some tools and set permissions 
echo $RED"                         ====== Downloading Conky-Manager ======"
wget -O /root/Desktop/conky-manager-latest-amd64.deb http://www.sbrn.nl/Kali/conky-manager-latest-amd64.deb -q
echo $BLUE"                             ====== Chmod Conky-Manager..... ======"
chmod +x /root/Desktop/conky-manager-latest-amd64.deb
echo $GREEN"                             ====== SUCCESS ======"
sleep 2
echo ""
#-----------------------------------------------------------------------------------------------------------------------------------
echo $RED "                        ====== Downloading themes ======"
wget -O /root/Desktop/default-themes-extra-1.cmtp.7z http://www.sbrn.nl/Kali/default-themes-extra-1.cmtp.7z -q
echo $GREEN"                             ====== SUCCESS ======"
sleep 2
echo ""
#-----------------------------------------------------------------------------------------------------------------------------------
echo $RED "                        ====== Downloading lazykali.sh ======"
wget -O /usr/bin/lazykali http://www.sbrn.nl/Kali/lazykali.sh -q
echo $BLUE"                             ====== Chmod lazykali.sh...... ======"
chmod +x /usr/bin/lazykali
echo $GREEN"                             ====== SUCCESS ======"
sleep 2
echo ""
#-----------------------------------------------------------------------------------------------------------------------------------
echo $RED "                        ====== Downloading RTL8187SetSpeed.sh ======"
wget -O /root/Desktop/RTL8187SetSpeed.sh http://www.sbrn.nl/Kali/RTL8187SPEED.sh -q
echo $BLUE"                             ====== Chmod RTL8187SetSpeed.sh...... ======"
chmod +x /root/Desktop/RTL8187SetSpeed.sh
echo $GREEN"                             ====== SUCCESS ======"
sleep 2
echo ""


#-----------------------------------------------------------------------------------------------------------------------------------

echo $RED "                        ====== Installing Flash ======"
# Install Flash
apt-get -y install flashplugin-nonfree &>/dev/null
echo $BLUE " Updating flash plugin......" &>/dev/null
update-flashplugin-nonfree --install &>/dev/null
echo $GREEN"                             ====== SUCCESS ======"
sleep 2
echo ""
#-----------------------------------------------------------------------------------------------------------------------------------

echo $RED "              ====== Installing Synaptic Package Manager ======"
# This will install Synaptic Package Manager
apt-get install synaptic -y &>/dev/null
echo $GREEN"                             ====== SUCCESS ======"
sleep 2
echo ""
#-----------------------------------------------------------------------------------------------------------------------------------

echo $RED"                        ====== Installing WPSscan ======"
#Install WPSscan
cd /root &>/dev/null
apt-get -y install libcurl4-gnutls-dev libopenssl-ruby libxml2 libxml2-dev libxslt1-dev ruby-dev &>/dev/null
git clone https://github.com/wpscanteam/wpscan.git &>/dev/null
cd /root/wpscan &>/dev/null
gem install bundle &>/dev/null && bundle install &>/dev/null
echo $GREEN"                             ====== SUCCESS ======"
sleep 2
echo ""
#-----------------------------------------------------------------------------------------------------------------------------------

echo $STAND"                            ====== Cleaning up ======"
sleep 2
#Clean up apt-get
apt-get -y autoremove
apt-get clean
echo $GREEN"                             ====== SUCCESS ======"
sleep 2
echo ""
#-----------------------------------------------------------------------------------------------------------------------------------

update_system(){
    print_status "[*] Updating the entire system."
    print_status "Performing apt-get update -y && apt-get upgrade"
    apt-get update -y && apt-get upgrade && apt-get -y dist-upgrade
    success_check
}

distupgrade_system(){

    print_status "Performing apt-get update"
    apt-get update &>> $logfile
    success_check

    print_status "Performing apt-get upgrade"
    print_notification "This WILL take a while. I'm talking at least half an hour (probably longer) on a good connection and fast system. Be patient."
    print_notification "You can monitor the programs through running (in another terminal window):"
    print_notification "tail -f $logfile"
    apt-get -y dist-upgrade &>> $logfile
    success_check
}

bleeding_edge(){
  
    print_status "Adding kali bleeding edge repo to /etc/apt/sources.list.."
    out=`grep  "kali-bleeding-edge" /etc/apt/sources.list`
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
        apt-get -y install numlockx
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

libs
ssh
hostname
numlock

#Now we run

if ask "Switch to bleeding edge?" Y; then
    bleeding_edge
fi

if ask "Update & upgrade Kali Linux?" Y; then
    update
fi

cleanup

print_status "all installations and updates complete."
print_status "Stand for something, because if you don't, you'll fall for anything."
exit 0