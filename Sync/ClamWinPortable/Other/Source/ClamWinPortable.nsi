;Copyright (C) 2004-2007 John T. Haller
;Additional Ideas from tracon and mai9

;Website: http://PortableApps.com/ClamWinPortable

;This software is OSI Certified Open Source Software.
;OSI Certified is a certification mark of the Open Source Initiative.

;This program is free software; you can redistribute it and/or
;modify it under the terms of the GNU General Public License
;as published by the Free Software Foundation; either version 2
;of the License, or (at your option) any later version.

;This program is distributed in the hope that it will be useful,
;but WITHOUT ANY WARRANTY; without even the implied warranty of
;MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;GNU General Public License for more details.

;You should have received a copy of the GNU General Public License
;along with this program; if not, write to the Free Software
;Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

!define NAME "ClamWinPortable"
!define PORTABLEAPPNAME "ClamWin Portable"
!define APPNAME "ClamWin"
!define VER "1.5.3.0"
!define WEBSITE "PortableApps.com/ClamWinPortable"
!define DEFAULTEXE "ClamWin.exe"
!define DEFAULTSCANEXE "clamscan.exe"
!define DEFAULTUPDATEEXE "freshclam.exe"
!define DEFAULTAPPDIR "clamwin\bin"
!define DEFAULTDBDIR "db"
!define DEFAULTLOGDIR "log"
!define DEFAULTQUARANTINEDIR "quarantine"
!define DEFAULTSETTINGSDIR "settings"

;=== Program Details
Name "${PORTABLEAPPNAME}"
OutFile "..\..\${NAME}.exe"
Caption "${PORTABLEAPPNAME} | PortableApps.com"
VIProductVersion "${VER}"
VIAddVersionKey ProductName "${PORTABLEAPPNAME}"
VIAddVersionKey Comments "Allows ${APPNAME} to be run from a removable drive.  For additional details, visit ${WEBSITE}"
VIAddVersionKey CompanyName "PortableApps.com"
VIAddVersionKey LegalCopyright "John T. Haller"
VIAddVersionKey FileDescription "${PORTABLEAPPNAME}"
VIAddVersionKey FileVersion "${VER}"
VIAddVersionKey ProductVersion "${VER}"
VIAddVersionKey InternalName "${PORTABLEAPPNAME}"
VIAddVersionKey LegalTrademarks "PortableApps.com is a Trademark of Rare Ideas, LLC."
VIAddVersionKey OriginalFilename "${NAME}.exe"
;VIAddVersionKey PrivateBuild ""
;VIAddVersionKey SpecialBuild ""

;=== Runtime Switches
CRCCheck On
WindowIcon Off
SilentInstall Silent
AutoCloseWindow True
RequestExecutionLevel user

; Best Compression
SetCompress Auto
SetCompressor /SOLID lzma
SetCompressorDictSize 32
SetDatablockOptimize On


;=== Include
!include "GetParameters.nsh"
!include "MUI.nsh"

;=== Program Icon
Icon "..\..\App\AppInfo\appicon.ico"

;=== Icon & Stye ===
!define MUI_ICON "..\..\App\AppInfo\appicon.ico"

;=== Languages
!insertmacro MUI_LANGUAGE "English"

LangString LauncherFileNotFound ${LANG_ENGLISH} "${PORTABLEAPPNAME} cannot be started. You may wish to re-install to fix this issue. (ERROR: $MISSINGFILEORPATH could not be found)"
LangString LauncherAlreadyRunning ${LANG_ENGLISH} "Another instance of ${APPNAME} is already running. Please close other instances of ${APPNAME} before launching ${PORTABLEAPPNAME}."
LangString LauncherAskCopyLocal ${LANG_ENGLISH} "${PORTABLEAPPNAME} appears to be running from a location that is read-only. Would you like to temporarily copy it to the local hard drive and run it from there?$\n$\nPrivacy Note: If you say Yes, your personal data within ${PORTABLEAPPNAME} will be temporarily copied to a local drive. Although this copy of your data will be deleted when you close ${PORTABLEAPPNAME}, it may be possible for someone else to access your data later."
LangString LauncherNoReadOnly ${LANG_ENGLISH} "${PORTABLEAPPNAME} can not run directly from a read-only location and will now close."

Var PROGRAMDIRECTORY
Var DBDIRECTORY
Var LOGDIRECTORY
Var QUARANTINEDIRECTORY
Var SETTINGSDIRECTORY
Var ADDITIONALPARAMETERS
Var EXECSTRING
Var PROGRAMEXECUTABLE
Var SCANEXECUTABLE
Var UPDATEEXECUTABLE
Var INIPATH
Var DISABLESPLASHSCREEN
Var ISDEFAULTDIRECTORY
Var MISSINGFILEORPATH

Section "Main"
	;=== Find the INI file, if there is one
		IfFileExists "$EXEDIR\${NAME}.ini" "" NoINI
			StrCpy "$INIPATH" "$EXEDIR\"
			Goto ReadINI

	ReadINI:
		;=== Read the parameters from the INI file
		ReadINIStr $0 "$INIPATH\${NAME}.ini" "${NAME}" "${APPNAME}Directory"
		StrCpy $PROGRAMDIRECTORY "$EXEDIR\$0"
		ReadINIStr $0 "$INIPATH\${NAME}.ini" "${NAME}" "DBDirectory"
		StrCpy $DBDIRECTORY "$EXEDIR\$0"
		ReadINIStr $0 "$INIPATH\${NAME}.ini" "${NAME}" "LogDirectory"
		StrCpy $LOGDIRECTORY "$EXEDIR\$0"
		ReadINIStr $0 "$INIPATH\${NAME}.ini" "${NAME}" "QuarantineDirectory"
		StrCpy $QUARANTINEDIRECTORY "$EXEDIR\$0"
		ReadINIStr $0 "$INIPATH\${NAME}.ini" "${NAME}" "SettingsDirectory"
		StrCpy $SETTINGSDIRECTORY "$EXEDIR\$0"

		;=== Check that the above required parameters are present
		IfErrors NoINI

		ReadINIStr $ADDITIONALPARAMETERS "$INIPATH\${NAME}.ini" "${NAME}" "AdditionalParameters"
		ReadINIStr $PROGRAMEXECUTABLE "$INIPATH\${NAME}.ini" "${NAME}" "${APPNAME}Executable"
		ReadINIStr $SCANEXECUTABLE "$INIPATH\${NAME}.ini" "${NAME}" "ScanExecutable"
		ReadINIStr $UPDATEEXECUTABLE "$INIPATH\${NAME}.ini" "${NAME}" "UpdateExecutable"
		ReadINIStr $DISABLESPLASHSCREEN "$INIPATH\${NAME}.ini" "${NAME}" "DisableSplashScreen"

		;=== Any missing unrequired INI entries will be an empty string, ignore associated errors
		ClearErrors

		;=== Correct PROGRAMEXECUTABLE if blank
		StrCmp $PROGRAMEXECUTABLE "" "" EndINI
			StrCpy $PROGRAMEXECUTABLE "${DEFAULTEXE}"
			Goto EndINI

	NoINI:
		;=== No INI file, so we'll use the defaults
		StrCpy $ADDITIONALPARAMETERS ""
		StrCpy $PROGRAMEXECUTABLE "${DEFAULTEXE}"
		StrCpy $SCANEXECUTABLE "${DEFAULTSCANEXE}"
		StrCpy $UPDATEEXECUTABLE "${DEFAULTUPDATEEXE}"

		IfFileExists "$EXEDIR\App\${DEFAULTAPPDIR}\${DEFAULTEXE}" "" CheckPortableProgramDIR
			StrCpy $PROGRAMDIRECTORY "$EXEDIR\App\${DEFAULTAPPDIR}"
			StrCpy $DBDIRECTORY "$EXEDIR\Data\${DEFAULTDBDIR}"
			StrCpy $LOGDIRECTORY "$EXEDIR\Data\${DEFAULTLOGDIR}"
			StrCpy $SETTINGSDIRECTORY "$EXEDIR\Data\${DEFAULTSETTINGSDIR}"
			StrCpy $QUARANTINEDIRECTORY "$EXEDIR\Data\${DEFAULTQUARANTINEDIR}"
			StrCpy $ISDEFAULTDIRECTORY "true"
			GoTo EndINI

		CheckPortableProgramDIR:
			IfFileExists "$EXEDIR\${NAME}\App\${DEFAULTAPPDIR}\${DEFAULTEXE}" "" NoProgramEXE
			StrCpy $PROGRAMDIRECTORY "$EXEDIR\${NAME}\App\${DEFAULTAPPDIR}"
			StrCpy $DBDIRECTORY "$EXEDIR\${NAME}\Data\${DEFAULTDBDIR}"
			StrCpy $LOGDIRECTORY "$EXEDIR\${NAME}\Data\${DEFAULTLOGDIR}"
			StrCpy $SETTINGSDIRECTORY "$EXEDIR\${NAME}\Data\${DEFAULTSETTINGSDIR}"
			StrCpy $QUARANTINEDIRECTORY "$EXEDIR\${NAME}\Data\${DEFAULTQUARANTINEDIR}"
			GoTo EndINI
	
	EndINI:
		IfFileExists "$PROGRAMDIRECTORY\$PROGRAMEXECUTABLE" FoundProgramEXE

	NoProgramEXE:
		;=== Program executable not where expected
		StrCpy $MISSINGFILEORPATH $PROGRAMEXECUTABLE
		MessageBox MB_OK|MB_ICONEXCLAMATION `$(LauncherFileNotFound)`
		Abort
		
	FoundProgramEXE:
		StrCmp $DISABLESPLASHSCREEN "true" GetPassedParameters
			;=== Show the splash screen before processing the files
			InitPluginsDir
			File /oname=$PLUGINSDIR\splash.jpg "${NAME}.jpg"
			newadvsplash::show /NOUNLOAD 1500 200 0 -1 /L $PLUGINSDIR\splash.jpg
	
	GetPassedParameters:
		;=== Get any passed parameters
		Call GetParameters
		Pop $0
		StrCmp "'$0'" "''" "" LaunchProgramParameters

		;=== No parameters
		StrCpy $EXECSTRING `"$PROGRAMDIRECTORY\$PROGRAMEXECUTABLE"`
		Goto AdditionalParameters

	LaunchProgramParameters:
		StrCpy $EXECSTRING `"$PROGRAMDIRECTORY\$PROGRAMEXECUTABLE" $0`

	AdditionalParameters:
		StrCmp $ADDITIONALPARAMETERS "" Settings

		;=== Additional Parameters
		StrCpy $EXECSTRING `$EXECSTRING $ADDITIONALPARAMETERS`
	
	Settings:
		IfFileExists `$SETTINGSDIRECTORY\*.*` UpdateSettings
			CreateDirectory $SETTINGSDIRECTORY
			CreateDirectory $DBDIRECTORY
			CreateDirectory $LOGDIRECTORY
			CreateDirectory $QUARANTINEDIRECTORY
			CopyFiles `$EXEDIR\App\DefaultData\ClamWin.conf` `$SETTINGSDIRECTORY`
			
	UpdateSettings:
		Rename "$SETTINGSDIRECTORY\ClamWin.conf" "$PROGRAMDIRECTORY\ClamWin.conf"
		StrCmp $ISDEFAULTDIRECTORY "true" SettingsDefault
		WriteINIStr "$PROGRAMDIRECTORY\ClamWin.conf" "ClamAV" "clamscan" "$PROGRAMDIRECTORY\$SCANEXECUTABLE"
		WriteINIStr "$PROGRAMDIRECTORY\ClamWin.conf" "ClamAV" "freshclam" "$PROGRAMDIRECTORY\$UPDATEEXECUTABLE"
		WriteINIStr "$PROGRAMDIRECTORY\ClamWin.conf" "ClamAV" "database" "$DBDIRECTORY"
		WriteINIStr "$PROGRAMDIRECTORY\ClamWin.conf" "ClamAV" "quarantinedir" "$QUARANTINEDIRECTORY"
		WriteINIStr "$PROGRAMDIRECTORY\ClamWin.conf" "ClamAV" "logfile" "$LOGDIRECTORY\ClamScanLog.txt"
		WriteINIStr "$PROGRAMDIRECTORY\ClamWin.conf" "Updates" "dbupdatelogfile" "$LOGDIRECTORY\ClamUpdateLog.txt"
		WriteINIStr "$PROGRAMDIRECTORY\ClamWin.conf" "Schedule" "path" "$PROGRAMDIRECTORY\"
		WriteINIStr "$PROGRAMDIRECTORY\ClamWin.conf" "UI" "standalone" "1"
		Goto ComSpecCheck
		
	SettingsDefault:
		ReadINIStr $0 "$PROGRAMDIRECTORY\ClamWin.conf" "ClamAV" "clamscan"
		StrCmp $0 ".\clamscan.exe" ComSpecCheck
		WriteINIStr "$PROGRAMDIRECTORY\ClamWin.conf" "ClamAV" "clamscan" ".\clamscan.exe"
		WriteINIStr "$PROGRAMDIRECTORY\ClamWin.conf" "ClamAV" "freshclam" ".\freshclam.exe"
		WriteINIStr "$PROGRAMDIRECTORY\ClamWin.conf" "ClamAV" "database" "..\..\..\Data\db"
		WriteINIStr "$PROGRAMDIRECTORY\ClamWin.conf" "ClamAV" "quarantinedir" "..\..\..\Data\quarantine"
		WriteINIStr "$PROGRAMDIRECTORY\ClamWin.conf" "ClamAV" "logfile" "..\..\..\Data\log\ClamScanLog.txt"
		WriteINIStr "$PROGRAMDIRECTORY\ClamWin.conf" "Updates" "dbupdatelogfile" "..\..\..\Data\log\ClamUpdateLog.txt"
		WriteINIStr "$PROGRAMDIRECTORY\ClamWin.conf" "Schedule" "path" ".\"
		WriteINIStr "$PROGRAMDIRECTORY\ClamWin.conf" "UI" "standalone" "1"
		
	ComSpecCheck:
		;=== Be sure the ComSpec environment variable is set right
		ReadEnvStr $R0 "COMSPEC"
		StrLen $0 $R0
		IntCmp $0 1 CreateComSpec CreateComSpec LaunchNow
		
	CreateComSpec:
		;=== We need to set the variable
		ReadEnvStr $R0 "SYSTEMROOT"
		IfFileExists "$R0\system32\cmd.exe" "" AltComSpecPath
		System::Call 'Kernel32::SetEnvironmentVariableA(t, t) i("COMSPEC", "$R0\system32\cmd.exe").r0'
		Goto LaunchNow

	AltComSpecPath:
		IfFileExists "$R0\command.com" "" NoComSpec
		System::Call 'Kernel32::SetEnvironmentVariableA(t, t) i("COMSPEC", "$R0\command.com").r0'
		Goto LaunchNow
	
	NoComSpec:
		StrCpy $MISSINGFILEORPATH `command.com/cmd.exe`
		MessageBox MB_OK|MB_ICONEXCLAMATION `$(LauncherFileNotFound)`
		Abort
	
	LaunchNow:
		ExecWait $EXECSTRING
		newadvsplash::stop /WAIT
		Sleep 300
		Delete "$SETTINGSDIRECTORY\ClamWin.conf"
		Rename "$PROGRAMDIRECTORY\ClamWin.conf" "$SETTINGSDIRECTORY\ClamWin.conf"
		Delete '$TEMP\ClamWin*.log'
		Delete '$TEMP\ClamWin*.txt'
		Delete '$TEMP\clamav-*.*'		
		Delete '$TEMP\ClamWin_Up*.*'
SectionEnd