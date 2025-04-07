#!/bin/bash

apt upgrade -y && apt update
pkg install unzip -y
pkg install mono -y

if [ -d "TerrariaServer" ]; then
    echo -e -n "\033[0;34m 
TerrariaServer is already installed. Do you want to repair it? [Y/n]: "
    read -r choice
    case "$choice" in
        [Yy]* )
            echo -e "\033[0;33m Overwriting existing TerrariaServer..."
            rm -rf TerrariaServer
            ;;
        [Nn]* )
            echo -e "\033[0;31m Aborting installation..."
            rm -f terraria-server-1449.zip
            exit 0
            ;;
        * )
            echo -e "\033[0;31m Invalid choice. Aborting."
            rm -f terraria-server-1449.zip
            exit 1
            ;;
    esac
fi

curl -O https://terraria.org/api/download/pc-dedicated-server/terraria-server-1449.zip
unzip terraria-server-1449.zip
rm terraria-server-1449.zip
mv 1449 TerrariaServer
chmod +x TerrariaServer/Linux/TerrariaS*
rm TerrariaServer/Linux/System*
rm TerrariaServer/Linux/Mono*
rm TerrariaServer/Linux/monoconfig
rm TerrariaServer/Linux/mscorlib.dll
rm -rf TerrariaServer/Mac
rm -rf TerrariaServer/Windows

touch TerrariaServer/Linux/serverconfig.txt

touch ~/../usr/bin/start-terraserver
echo -e "#!/bin/bash\nclear
mono ${PWD}/TerrariaServer/Linux/TerrariaServer.exe
" > ~/../usr/bin/start-terraserver

touch ~/../usr/bin/start-terraserver-config
echo -e "#!/bin/bash\nclear
mono TerrariaServer/Linux/TerrariaServer.exe -config TerrariaServer/Linux/serverconfig.txt" > ~/../usr/bin/start-terraserver-config

touch ~/../usr/bin/edit-serverconfig
echo -e "#!/bin/bash\nnano $PWD/TerrariaServer/Linux/serverconfig.txt" > ~/../usr/bin/edit-serverconfig

cp install-terraserver.sh ~/../usr/bin/repair-terraserver

chmod +x ~/../usr/bin/start-terraserver
chmod +x ~/../usr/bin/start-terraserver-config
chmod +x ~/../usr/bin/edit-serverconfig
chmod +x ~/../usr/bin/repair-terraserver

echo -e "\033[0;36m TerrariaServer Successfully installed!
Here are commands list."

echo -e "\033[0;35m start-terraserver"
echo -e "\033[0;32m -- Runs the Server"
echo -e "\033[0;35m start-terraserver-config"
echo -e "\033[0;32m -- Runs the Server with serverconfig.txt"
echo -e "\033[0;35m edit-serverconfig"
echo -e "\033[0;32m -- Edits the serverconfig.txt file."
echo -e "\033[0;35m repair-terraserver"
echo -e "\033[0;32m -- Reinstalls the server."