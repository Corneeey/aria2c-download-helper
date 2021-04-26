:: simple script to download magnet links using aria2c.
:: author: Corneeey (https://github.com/Corneeey)
:: repository: https://github.com/Corneeey/aria2c-download-helper
@echo off


:: initializes all variables.
:Variables
	:: the path of the folder to which all torrents will be downloaded.
	:: if none is specified the active users video directory will be used.
	set optionalOutputDirectory=""

	:: paste.exe is used to read clipboard content.
	:: this functionality is optional.
	set requirePasteExe=true

	:: specifies the seed ratio
	:: (1.0 means for 1MB downloaded up to 1MB will be uploaded)
	:: for more information see official aria2c doc:
	:: https://aria2.github.io/manual/en/html/aria2c.html#cmdoption-seed-ratio
	set seedRatio=1.0

	:: by default paste.exe and aria2c.exe are expected to be in system32.
	:: if you want them to be installed somewhere else please specify so here.
	set optionalPathToPasteExe=""
	set optionalPathToAria2cExe=""

	:: reads potential start parameters.
	set subfolderName=%~2
	set magnet=%~1


:: checks for a valid output directory as well as aria2c.exe and paste.exe
:Requirements
	if %optionalOutputDirectory% equ "" (
		set outputDirectory="%homepath%\Videos"
	) else (
		set outputDirectory=%optionalOutputDirectory%
	)

	if %optionalPathToPasteExe% equ "" (
		set pathToPasteExe="%systemroot%\System32\paste.exe"
	) else (
		set pathToPasteExe=%optionalPathToPasteExe%
	)

	if %optionalPathToAria2cExe% equ "" (
		set pathToAria2cExe="%systemroot%\System32\aria2c.exe"
	) else (
		set pathToAria2cExe=%optionalPathToAria2cExe%
	)

	if %requirePasteExe% equ true (
		if not exist %pathToPasteExe% (
			echo paste.exe not found. Please download from
			echo https://gist.github.com/jpflouret/19da43372e643352a1bf
			echo and place into System32 or specify the directory in the script.
			echo.
			pause
			goto Exit
		)
	)

	if not exist %outputDirectory% (
		echo The Output Directory Isn't Valid
		goto Exit
	)

	if not exist %pathToAria2cExe% (
		echo aria2c.exe not found. Please download from
		echo https://github.com/aria2/aria2
		echo and place into System32 or specify the directory in the script.
		echo.
		pause
		goto Exit
	)


:: handles all parameter related code.
:Parameters
	if "%subfolderName%" == "" goto AskForName
	if "%magnet%" == "" goto AskForMagnet


:: handles all directory related code.
:Directory
	set outputDirectory=%outputDirectory:"=%
	md "%outputDirectory%\%subfolderName%"
	cd "%outputDirectory%\%subfolderName%"

:: creates a file to start / resume the download
:CreateResumeDownloadFile
	set magnet="%magnet:"=%"
	if not exist "%cd%\Resume Download.bat" (
		echo %pathToAria2cExe% --file-allocation=none --seed-ratio=%seedRatio% %magnet%> "Resume Download.bat"
	) else (
		if not exist "%cd%\Resume Download %date%.bat" (
			echo %pathToAria2cExe% --file-allocation=none --seed-ratio=%seedRatio% %magnet%> "Resume Download %date%.bat"
		) else (
			echo %pathToAria2cExe% --file-allocation=none --seed-ratio=%seedRatio% %magnet%> "Resume Download %date% %time::=.%.bat"
		)
	)

:: starts the download
:Download
	cls
	%pathToAria2cExe% --file-allocation=none --seed-ratio=%seedRatio% %magnet%

:: exits the script. all code after this won't be called by default.
:Exit
	exit


:: prompts the user to enter a name of the ouput subfolder.
:AskForName
	cls
	set /p subfolderName="Enter the name of the torrent: "
	goto Parameters


:: prompts the user to enter a magnet to the wanted file(s).
:AskForMagnet
	cls
	if exist %pathToPasteExe% (
		echo Enter a magnet or link to a torrent.
		echo Leave blank to use clipboard content.
		set /p magnet="magnet: "
	) else (
		set /p magnet="Enter a magnet or link to a torrent: "
	)
	if exist %pathToPasteExe% (
		if "%magnet%" equ "" (
			%pathToPasteExe% > tmp
			for /F "delims=" %%i in (tmp) do set magnet="%%i"
		)
	)
	if exist tmp (
		del tmp
	)
	goto Directory
