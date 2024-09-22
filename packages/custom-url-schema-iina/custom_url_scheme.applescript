on open location url_scheme
	set homePath to POSIX path of (path to home folder)
	set appPath to homePath & "Applications/Home Manager Apps/IINA.app/Contents/MacOS/IINA"
	
	set AppleScript's text item delimiters to {"openiina://"}
	set txt_items to text items of url_scheme
	set AppleScript's text item delimiters to {""}
	set scheme_txt to txt_items as Unicode text
	
	do shell script quoted form of appPath & " http://" & scheme_txt
end open location
