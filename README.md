# aria2c-download-helper
simple script to download magnets or torrents using aria2c

## Requirements
since this script uses [aria2c](https://github.com/aria2/aria2 "aria2 GitHub page") to download torrents you will need to install it  
as an optional functionality the script can access magnet links from your clipboard so you don't have to paste them into the console.  
for this to work you need to download and install [paste.exe](https://gist.github.com/jpflouret/19da43372e643352a1bf "paste.exe GitHub Page")

## Functionality
this script will prompt the user for a name of the download as well as a magnet link.  
it will then create a subfolder with said name in the specified directory and begin installing any files from the magnet link in this new folder.  
it will also create a new batch file in the same folder which will resume the download / resume seeding if the process got terminated.
the script does **not** allow for partial downloads of any torrent. you can still use aria2c for this. ([aria2c doc](https://aria2.github.io/manual/en/html/aria2c.html#cmdoption-select-file "aria2c doc: --select-file"))

## Parameters
there's 5 parameters which can be tweaked by the user:
+ `optionalOutputDirectory`: by default the script will download any files into the users video directory. use this to specify any other existing directory.
+ `requirePasteExe`: decides if any errors caused by missing paste.exe will be ignored.
+ `seedRatio`: specifies the seed ratio for the download ([aria2c doc](https://aria2.github.io/manual/en/html/aria2c.html#cmdoption-seed-ratio "aria2c doc: --seed-ratio")).
+ Both paste.exe and aria2c.exe are intended to be placed in system32. If you have them installed in another directory you need to specify so:
  + `optionalPathToPasteExe`: path to the paste.exe file if it's not in system32.
  + `optionalPathToAria2cExe`: path to the aria2c.exe file if it's not in system32.

## Usage
you can either run the script directly or launch it from the console.  
if you decide to launch it directly it will prompt you for a name and magnet link.  
the name input is required and cannot be left empty.  
if you leave the magnet input empty and have paste.exe installed it will use your clipboard content as the magnet link.  

if you want to start the script from the console you can use the first 2 start parameters to specify tbe name and the magnet link in that order:  
`"C:\Path\To\Script\Script Name.bat" "Optional Name Of Download" "Optional Magnet Link"`  
the script will not ask for parameters that were specified on launch.  
to leave the name empty but start it with a magnet link simply leave the name parameter blank:  
`"C:\Path\To\Script\Script Name.bat" "" "Optional Magnet Link"` 
