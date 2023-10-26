#!/bin/bash

##### INITIALIZATION
# User var (please modify)
# var_outputloc="/Users/YOURUSERNAMEHERE/Movies/yt-dlp"
var_outputloc="/Users/johndeuf/Movies/yt-dlp"

# Other var (don't touch!)
var_regex='(https?|ftp|file)://[-[:alnum:]\+&@#/%?=~_|!:,.;]*[-[:alnum:]\+&@#/%=~_|]'	# For URL check
var_whilecheck=0
var_filename=""
var_newname=""
var_url=""
var_usrinput=""

##### FUNCTIONS
# Stylish messages in "ASCII art"
msg_clipboard () {
echo -e "\n\n"
echo "====================="
echo "Retrieving clipboard..."
echo "====================="
}
msg_valid () {
echo -e "\n\n"
echo "====================="
echo "Valid link."
echo "====================="
}
msg_invalid () {
echo -e "\n\n"
echo "====================="
echo "Empty or invalid URL."
echo "Force continue?"
echo "====================="
}
msg_cancel () {
echo -e "\n\n"
echo "====================="
echo "Cancelled."
echo "====================="
}
msg_continue () {
echo -e "\n\n"
echo "====================="
echo "Continuing..."
echo "====================="
}
msg_webm () {
echo -e "\n\n"
echo "====================="
echo "Warning, .WEBM format"
echo "detected. Would you like"
echo "to convert to .MP4 ?"
echo "====================="
}
msg_del () {
echo -e "\n\n"
echo "====================="
echo "Delete original file"
echo "(in .WEBM format) ?"
echo "====================="
}
msg_bandcamp () {
echo -e "\n\n"
echo "====================="
echo "Warning, URL is not"
echo "a bandcamp link."
echo "Force continue?"
echo "====================="
}
msg_update () {
echo -e "\n\n"
echo "====================="
echo "Do you really want"
echo "to update yt-dlp and"
echo "ffmpeg (through brew)?"
echo "====================="
}
msg_stop () {
echo -e "\n\n"
echo "====================="
echo "End of script."
echo "Files are located in..."
echo $var_outputloc
echo "Please input command+W"
echo "to close this window."
echo "====================="
}
msg_menu () {
echo -e "\n\n"
echo "8==========xXx==========8"
echo "......Please choose......"
echo "1. Standard download"
echo "2. ... Audio only (.MP3)"
echo "3. Playlist-compatible"
echo "4. ... Audio only (.MP3)"
echo "5. Bandcamp-optimized"
echo "........................"
echo "8. Update componments"
echo "9. Help"
echo "x. Close menu"
echo "Tip: press CTRL+W anytime to"
echo "cancel the current operation." 
echo "8==========xXx==========8"
}
msg_sillyquestion () {
read -n 1 -p "Is that clear ? y/n: " var_usrinput
	case $var_usrinput in
		"y") echo -e "\nYes? It better be!!!";;
		"n") echo -e "\nNo? Well I don't care!!!";;
		"?") echo -e "\nWhat do you mean '?'??? Bye!!!";;
		*) echo -e "\nThe youth nowadays!!! Can't even answer a question!!!";;
	esac
}
# YT-DLP Standard Mode
code_standard () {
	echo -e "\n\n"
	#	Get filename
	var_filename=$(yt-dlp -o "$var_outputloc/%(webpage_url_domain)s/%(title)s.%(ext)s" --get-filename --no-download-archive $var_url)
	#	Download
	yt-dlp $var_url --no-playlist -o "$var_outputloc/%(webpage_url_domain)s/%(title)s.%(ext)s"
	#	If file is in WEBM format
	if [[ $var_filename == *.webm ]]; then
		msg_webm
		read -n 1 -p "y/n: " var_usrinput
		if [[ "$var_usrinput" = "y" ]]; then
			#	Set new filename as old filename with .MP4 instead of .WEBM
			var_newname=${var_filename//webm/mp4}
			ffmpeg -i "$var_filename" "$var_newname"
			echo "Original file : "$var_filename
			echo "Converted file : "$var_newname
			msg_del
			read -n 1 -p "y/n: " var_usrinput
			#	Check if old file must be deleted
			if [[ "$var_usrinput" = "y" ]]; then
				rm "$var_filename"
				echo -e "\n\nDeleted"
			else
				echo -e "\n\nNot deleted"
			fi
		fi
	fi
}
help_standard () {
	echo -e "\n\n"
	echo "8======help===[?]===help======8"
	echo "SHORT: Basic yt-dlp command"
	echo "without playlist compatibility."
	echo "LONG: Downloads specified URL,"
	echo "checks if it in .WEBM format"
	echo "(since macOS doesn't like it),"
	echo "if true, asks user if file must"
	echo "be converted to .MP4, if yes,"
	echo "converts and asks user if old"
	echo "file must be deleted."
	echo "8=============[?]=============8"
	msg_sillyquestion
}
# YT-DLP Standard, Audio-only Mode
code_standard_audio () {
	echo -e "\n\n"
	#	Download
	yt-dlp $var_url --no-playlist -x --audio-format mp3 --audio-quality 0 -o "$var_outputloc/%(webpage_url_domain)s/%(title)s.%(ext)s"
}
help_standard_audio () {
	echo -e "\n\n"
	echo "8======help===[?]===help======8"
	echo "Basic yt-dlp command with forced"
	echo "audio-only output in .MP3 format."
	echo "Not playlist-compatible."
	echo "8=============[?]=============8"
	msg_sillyquestion
}
# YT-DLP Playlist-compatible Mode
code_plst () {
	echo -e "\n\n"
	#	Download
	yt-dlp $var_url --yes-playlist -o "$var_outputloc/%(webpage_url_domain)s/%(title)s.%(ext)s"
}
help_plst () {
	echo -e "\n\n"
	echo "8======help===[?]===help======8"
	echo "Basic yt-dlp command that allows"
	echo "downloading of playlists."
	echo "8=============[?]=============8"
	msg_sillyquestion
}
# YT-DLP Playlist, Audio-only Mode
code_plst_audio () {
	echo -e "\n\n"
	#	Download
	yt-dlp $var_url --yes-playlist -x --audio-format mp3 --audio-quality 0 -o "$var_outputloc/%(webpage_url_domain)s/%(title)s.%(ext)s"
}
help_plst_audio () {
	echo -e "\n\n"
	echo "8======help===[?]===help======8"
	echo "Basic yt-dlp command that allows"
	echo "downloading of playlists, with"
	echo "forced audio-only output in .MP3."
	echo "8=============[?]=============8"
	msg_sillyquestion
}
# YT-DLP Bandcamp-optimized Mode
code_bandcamp () {
	echo -e "\n\n"
	#	Check if URL is bandcamp
	if [[ "$var_url" != *"bandcamp"* ]]; then
		msg_bandcamp
		read -n 1 -p "y/n :" var_usrinput
		if [[ "$var_usrinput" != "y" ]]; then
			msg_cancel
			return
		fi
		echo -e "\n\n"
	fi
	# Download
	yt-dlp $var_url --embed-thumbnail --embed-metadata -o "$var_outputloc/%(webpage_url_domain)s/%(playlist)s/%(playlist_index)s. %(title)s.%(ext)s"
}
help_bandcamp () {
	echo -e "\n\n"
	echo "8======help===[?]===help======8"
	echo "Yt-dlp command that is specifically"
	echo "designed to download from bandcamp"
	echo "albums. You must copy the album's"
	echo "URL for this mode to work, not the"
	echo "individual tracks' URLs."
	echo "8=============[?]=============8"
	msg_sillyquestion
}
# YT-DLP Update Mode
code_update () {
	echo -e "\n\n"
	#	Retrieve available updates from brew
	brew update
	msg_update
	read -n 1 -p "y/n: " var_usrinput
	if [[ "$var_usrinput" != "y" ]]; then
			msg_cancel
			return
	fi
	brew upgrade yt-dlp
	brew upgrade ffmpeg
}
help_update () {
	echo -e "\n\n"
	echo "8======help===[?]===help======8"
	echo "Use this to quickly update both"
	echo "ffmpeg and yt-dlp through brew."
	echo "How it works: checks available"
	echo "brew updates, asks if user wants"
	echo "to update ffmpeg and yt-dlp, if"
	echo "yes, update said componments."
	echo "8=============[?]=============8"
	msg_sillyquestion
}
help_helpmenu () {
	echo -e "\n\n"
	echo "8======help===[?]===help======8"
	echo "The help menu is a menu which can"
	echo "help those who need help. Should"
	echo "you ever need help, please check"
	echo "the help menu. Such menu will be"
	echo "of great help if the need for help,"
	echo "and for a menu, as well as a help"
	echo "menu, arises. HELP!"
	echo "8=============[?]=============8"
	msg_sillyquestion
}
# Help Menu
code_helpmenu () {
	echo -e "\n"
	read -n 1 -p "Choose which option to get help on: " var_usrinput
	case $var_usrinput in
		"1") help_standard;;
		"2") help_standard_audio;;
		"3") help_plst;;
		"4") help_plst_audio;;
		"5") help_bandcamp;;
		"8") help_update;;
		"9") help_helpmenu;;
		"x") return;;
		*) echo -e "\n\nInvalid input.";;
	esac
}
# Main Menu
code_mainmenu () {
	msg_menu
	read -n 1 -p "Choose: " var_usrinput
	case $var_usrinput in
		"1") code_standard;;
		"2") code_standard_audio;;
		"3") code_plst;;
		"4") code_plst_audio;;
		"5") code_bandcamp;;
		"8") code_update;;
		"9") code_helpmenu;;
		"x") return;;
		"0") echo -e "\n\nby Ayazel ... no Copyright!!! 2023\n\n";;
		*) echo -e "\n\nInvalid input.";;
	esac
}


##### MAIN SCRIPT
# Check if user var was modified as requested
if [[ $var_outputloc == *"YOURUSERNAMEHERE"* ]]; then
	echo -e "\n\n\nPlease modify the user var before launching the script.\n\n"
	read -n 1 -p "Waiting for input..."
	exit
fi
# Beginning
while [ "$var_whilecheck" -eq 0 ]; do
	msg_clipboard
	read  -p "Waiting for input..."
	var_url=$(pbpaste)
	if [[ "$var_url" =~ $var_regex ]]; then			# Check if URL is valid
		msg_valid
		code_mainmenu								# If valid: show main menu
	else
		msg_invalid									# If invalid: ask if user wants to continue anyway
		read -n 1 -p "y/n: " var_usrinput
		if [ "$var_usrinput" = "y" ]; then
			code_mainmenu
		else
			msg_cancel
		fi
	fi
	echo -e "\n\n"
	read -n 1 -p "Continue? y/n :" var_usrinput		# Choice before end of program
	if [[ "$var_usrinput" = "y" ]]; then
		msg_continue
	else
		((var_whilecheck++))						# End
	fi
done

msg_stop
exit
