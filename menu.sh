#!/bin/bash

# Some important variables!
CURRENT_DATE=$(date +"%d-%m-%Y")
CURRENT_TIME=$(date +"%H:%M:%S")
restart=true

# Functions!
# ------------------------------------------------------------------------------------------
weather () {
	echo "Please enter your city (replace any spaces with +): "
	read city
	echo "Fahrenheit or Celsius[f/c]: "
	read tu
	if [ "$tu" = 'f' ]
	then
		curl wttr.in/$city?u
	elif [ "$tu" = 'c' ]
	then
		curl wttr.in/$city?m
	else
		echo "Please enter f or c!"
	fi

	read -p "Press enter to head back!"
	clear
	restart=true
	# Visit https://linuxconfig.org/get-your-weather-forecast-from-the-linux-cli for more info!
}

gifmaker () {
	clear
	echo "Lets make an ASCII gif!"
        echo ">>Warning: This requires an install!<<"
        echo "#######################################################"
	echo "1) View gif in terminal"
	echo "2) Export a gif"
	echo "3) Go back"
	read gifchoice
	if [ "$gifchoice" = "1" ]
	then
		echo "Enter a gif location or a link to a gif: "
                read gifloc
                echo "Default, true color, 256 colors, or no colors?[default/truecolor/256/nocolor]: "
                read color
		if [ "$color" = "default" ]
		then
			clear
			gif-for-cli $gifloc
		elif [[ "$color" = "truecolor" || "$color" = "256" || "$color" = "nocolor" ]]
		then
			clear
			gif-for-cli -m $color $gifloc
		else
			echo "asd"
		fi
	elif [ "$gifchoice" = "2" ]
	then
        	echo "Enter a gif location or a link to a gif: "
                read gifloc
                echo "Default, true color, 256 colors, or no colors?[default/truecolor/256/nocolor]: "
                read color
        	echo "What would you like to call the gif? (Include extention: .mp4, .gif, etc)"
		read gifname
		echo "This will save to your current directory!"
		if [ "$color" = "default" ]
		then
			gif-for-cli $gifloc --export=$gifname
		else
			gif-for-cli -m $color $gifloc --export=$gifname
		fi
	else
		retry2=true
	fi
	# For more info: https://github.com/google/gif-for-cli
}

gifinstall () {
	echo "Checking to see if pip is installed..."
	dpkg -s python3-pip &> /dev/null
	if [ $? = 0 ]
	then
		echo "Pip is installed!"
	else
		echo "Pip is not installed. Installing now..."
		sudo apt-get -y install python3-pip
		echo "Pip is installed!"
	fi
        echo "Continuing installation..."
	sudo apt-get install zlib* libjpeg* python3-setuptools
	sudo apt install ffmpeg
        pip3 install --user gif-for-cli
        echo "Adding gif-for-cli to your path..."
	export PATH="$HOME/.local/bin:$PATH"
        source ~/.bashrc
	rm -r ~/.cache/gif-for-cli/1.1.2/*
        echo "gif-for-cli is installed!"
	# Not sure why exporting doesn't work
	# Manually entering the command below gets it working
	export PATH="$HOME/.local/bin:$PATH"
}

aqinstall () {
	dpkg -s libcurses-perl &> /dev/null
	if [ $? = 0 ]
	then
		echo "You have libcurses-perl! Skipping..."
	else
		echo "Installing Perl Module Term-Animation..."
		sudo apt-get install libcurses-perl
	fi
	echo "Compiling Term-Animation..."
	dpkg -s make &> /dev/null
	if [ $? != 0 ]
	then
		sudo apt-get install make
	fi
	cd /tmp && wget http://search.cpan.org/CPAN/authors/id/K/KB/KBAUCOM/Term-Animation-2.6.tar.gz && tar -zxvf Term-Animation-2.6.tar.gz && cd Term-Animation-2.6/ && perl Makefile.PL && make && make test && sudo make install
	echo "Done!"
	read -p "Enter"
	echo "Installing ASCIIQuarium..."
	cd /tmp && wget https://robobunny.com/projects/asciiquarium/asciiquarium.tar.gz && tar -zxvf asciiquarium.tar.gz && cd asciiquarium_1.1/ && sudo cp asciiquarium /usr/local/bin && sudo chmod 0755 /usr/local/bin/asciiquarium
	echo "Install finished!"
	read -p  "Press enter to go back..."
	clear
}

ftos () {
	linestart="#!/bin/bash"
	clear
	echo "What function would you like to export? (in an .sh file)"
	echo "############################################"
	echo "1) Weather"
	echo "2) ASCII gifmaker"
	echo "3) Gif-for-cli installer"
	echo "4) asciiquarium installer"
	echo "5) lolcat and font installer"
	echo "6) Go back"
	read ans
	case $ans in
		1|2|3|4|5)
			echo "Enter a name for the .sh file:"
			read ename
			case $ans in
				1)
					type weather >> $ename.sh && sudo sed -i "1s|.*|$linestart|" $ename.sh && echo "weather" >> $ename.sh && chmod +x $ename.sh
					;;
				2)
					type gifmaker >> $ename.sh && sudo sed -i "1s|.*|$linestart|" $ename.sh && echo "gifmaker" >> $ename.sh && chmod +x $ename.sh
					;;
				3)
					type gifinstall >> $ename.sh && sudo sed -i "1s|.*|$linestart|" $ename.sh && echo "gifinstall" >> $ename.sh && chmod +x $ename.sh
					;;
				4)
					type aqinstall >> $ename.sh && sudo sed -i "1s|.*|$linestart|" $ename.sh && echo "aqinstall" >> $ename.sh && chmod +x $ename.sh
					;;
				5)
					type font_lolcatinstall >> $ename.sh && sudo sed -i "1s|.*|$linestart|" $ename.sh && echo "font_lolcatinstall" >> $ename.sh && chmod +x $ename.sh
					;;
			esac
			echo "Where would you like this file? (Press enter to skip)"
			read elocation
			if [ "$elocation" != "" ]
			then
				sudo mv $ename.sh $elocation
			else
				echo "Skipped!"
			fi
			echo "Done! Your file is located at:"
			readlink -f $ename.sh
			read -p "Continue?"
			clear
			retry1=true
			;;
		5)
			retry1=true
			;;
	esac
}

font_lolcatinstall () {
	# Warning:
	# This function is far from perfect.
	# Id like to completely rewrite it at some point because its more complex than it needs to be.
	# Errors are expected.

	dpkg -s figlet &> /dev/null
	if [ $? = 0 ]
	then
		echo "Figlet is installed!"
	else
		echo "Installing figlet..."
		sudo apt-get install figlet
		dpkg -s figlet &> /dev/null
		if [ $? = 0 ]
		then
			echo "Install finished!"
		else
			echo "Install failed!"
			echo "Returning to base"
			read -p ""
			retry3=true
		fi
	fi
	if [ "$lolcheck" = "true" ] && [ "$fontcheck" = "1" ]
	then
		echo "You already have lolcat and the 3d font!"
		read -p "Press enter to head back..."
		clear
		retry3=true
	elif [ "$lolcheck" = "true" ] && [ "$fontcheck" != "1" ]
	then
		echo "Installing the 3d.flf font for figlet in /usr/share/figlet/"
		cd && cd /usr/share/figlet/ && sudo curl -o 3d.flf https://raw.githubusercontent.com/xero/figlet-fonts/master/3d.flf && cd
		figlet -f 3d "Done!" | lolcat
		read -p  "Press enter to head back..."
		retry3=true
	elif [ "$lolcheck" = "false" ] && [ "$fontcheck" = "1" ]
	then
		echo "lolcat requires ruby to be installed."
		echo "Cheking for ruby..."
		dpkg -s ruby &> /dev/null
		if [ $? = 0 ]
		then
			clear
			echo "Ruby is installed!"
			echo "Installing lolcat now..."
			wget https://github.com/busyloop/lolcat/archive/master.zip && unzip master.zip && cd lolcat-master/bin && sudo gem install lolcat
			echo "lolcat installed!"
			read -p "Press enter to head back..."
			retry3=true
		else
			clear
			echo "Looks like ruby need to be installed."
			read -p  "Press enter to give the ok!"
			echo "Installing ruby..."
			sudo apt-get install ruby
			echo "Ruby is now installed!"
			echo "Installing lolcat now..."
			wget https://github.com/busyloop/lolcat/archive/master.zip && unzip master.zip && cd lolcat-master/bin && sudo gem install lolcat && rm master.zip && cd .. && cd .. && rm -r /lolcat-master
			echo "lolcat installed!"
			read -p "Press enter to head back..."
			retry3=true
		fi
	elif [ "$lolcheck" != "true" ] && [ "$fontcheck" != "1" ]
	then
		echo "Looks like ruby need to be installed."
		read -p  "Press enter to give the ok!"
		echo "Installing ruby..."
		sudo apt-get install ruby
		echo "Ruby is now installed!"
		echo "Installing lolcat now..."
		wget https://github.com/busyloop/lolcat/archive/master.zip && unzip master.zip && cd lolcat-master/bin && sudo gem install lolcat && rm master.zip && cd .. && cd .. && rm -r /lolcat-master
		echo "lolcat installed!"
		clear
		echo "Installing the font!"
		cd && cd /usr/share/figlet/ && sudo curl -o 3d.flf https://raw.githubusercontent.com/xero/figlet-fonts/master/3d.flf && cd
		figlet -f 3d "Done!" | lolcat
		read -p "Press enter to head back..."
		retry3=true
	fi
}

# -----------------------------------------------------------MENU-----------------------------------------------------------
while [ "$restart" != "false" ]
do
	# ---------------------This section checks for installed packages---------------------
	clear
	dpkg -s curl &> /dev/null
	if [ $? != 0 ]
	then
		echo "Welcome to this menu! Before continuing, please read this warning:"
		echo ">>>>This requires curl!<<<<"
		read -p "Press enter to install..."
		sudo apt install curl
	fi
	lolcheck=$(gem list lolcat -i)
	fontcheck=$(find /usr/share/figlet/ -name 3d.flf | wc -l) 
	clear
	dpkg -s figlet &> /dev/null
	if [ $? = 0 ]
	then
		if [ "$lolcheck" = "true" ] && [ "$fontcheck" = "1" ]
		then
			figlet -f 3d "Greetings!" | lolcat
		elif [ "$lolcheck" = "true" ]
		then
			figlet "Greetings!" | lolcat
		else
			figlet Greetings!
		fi
	else
		echo "GREETINGS!"
	fi
	# ------------------------------------------------------------------------------------

	# Here is our main menu!
	echo -e "\nApparently today is " $CURRENT_DATE
	echo -e "Your clock says " $CURRENT_TIME "\n"
	echo "Welcome to this useless menu! Choose an option to get started!"
	echo "################################################################"
	echo "1) Tools"
	echo "2) Extras"
	echo "3) Installer"
	echo "4) Exit"
	echo "################################################################"
	read choicem

	case $choicem in
		1)
			retry1=true
			while [ "$retry1" != "false" ]
			do
				clear
				dpkg -s figlet &> /dev/null
				if [ $? = 0 ]
				then
					if [ "$lolcheck" = "true" ] && [ "$fontcheck" = "1" ]
        				then
                			figlet -f 3d "TOOLS" | lolcat
        				elif [ "$lolcheck" = "true" ]
        				then
                				figlet "TOOLS" | lolcat
        				else
                				figlet "TOOLS"
        				fi
				else
					echo "TOOLS"
				fi
				echo "##########################################################"
				echo "1) Weather"
				echo "2) Export tools and extras"
				echo "3) Go back"
				read choice1

				case $choice1 in
					1)
						clear
						weather
						;;
					2)
						ftos
						;;
					3)
						clear
						restart=true
						retry1=false
						;;
					*)
						clear
						echo "Please enter an option!"
						read -p "Press enter to try again..."
						retry1=true
						;;
				esac
			done
			;;
		2)
			retry2=true
			while [ "$retry2" != "false" ]
			do
				clear
				dpkg -s figlet &> /dev/null
				if [ $? = 0 ]
				then
					if [ "$lolcheck" = "true" ] && [ "$fontcheck" = "1" ]
        				then
                				figlet -f 3d "EXTRAS" | lolcat
        				elif [ "$lolcheck" = "true" ]
        				then
                				figlet "EXTRAS" | lolcat
        				else
                				figlet "EXTRAS"
        				fi
				else
					echo "EXTRAS"
				fi
				echo "###############################################################"
				echo "1) Gif to ASCII (gif-for-cli REQUIRED!)"
				echo "2) Go to the aquarium (aquarium REQUIRED!)"
				echo "3) ASCII Fire (caca-utils REQUIRED!)"
				echo "4) Go back"
				read choice2

				case $choice2 in
					1)
						clear
						gifmaker
						;;
					2)
						echo "Enjoy your stay!" && echo "Press q to quite" && read -p ""
						asciiquarium
						retry2=true
						;;
					3)
						clear
						cacafire
						retry2=true
						;;
					4)
						clear
						restart=true
						retry2=false
						;;
					*)
                                        	clear
                                        	echo "Please enter an option!"
						read -p "Press enter to try again..."
                                        	retry2=true
                                        	;;
				esac
			done
			;;
		3)
			retry3=true
			while [ "$retry3" != "false" ]
			do
				sudo apt-get update
				clear
				dpkg -s figlet &> /dev/null
				if [ $? = 0 ]
				then
					if [ "$lolcheck" = "true" ] && [ "$fontcheck" = "1" ]
        				then
                				figlet -f 3d "INSTALL" | lolcat
        				elif [ "$lolcheck" = "true" ]
        				then
                				figlet "INSTALL" | lolcat
        				else
                				figlet "INSTALL"
        				fi
				else
					echo "INSTALL"
				fi
				echo "#################################################################"
				echo "1) gif-for-cli"
				echo "2) caca-utils"
				echo "3) aquarium"
				echo "4) fancy greeting (lolcat)"
				echo "5) Go back"
				read choice3

				case $choice3 in
					1)
						clear
						gifinstall
						read -p "Press enter to continue"
						;;
					2)
						clear
						echo "Installing caca-utils..."
						sudo apt-get install caca-utils
						echo "Installed!"
						echo "Enjoy!"
						read -p  "Press enter to head back..."
						clear
						retry3=true
						;;
					3)
						clear
						aqinstall
						retry3=true
						;;
					4)
						clear
						font_lolcatinstall
						retry3=true
						;;
					5)
						clear
						restart=true
						retry3=false
						;;
					*)
						clear
						echo "Please select an option!"
						read -p "Press enter to try again..."
						retry3=true
						;;
				esac
			done
			;;
		4)
			clear
			exit 0
			;;
		*)
			clear
			echo "Please select an option! (1-5)"
			read -p "Press enter to try again..."
			restart=true
			;;
	esac
done