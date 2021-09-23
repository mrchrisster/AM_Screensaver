#NoEnv
#Persistent
#SingleInstance Force
;#InstallKeybdHook

Random,,%A_TickCount% ; Generate Seed for more randomness
SetWorkingDir %A_ScriptDir%


timebetween := 90000 ; How long to show each game, define in milliseconds

MameLaunch()
{
	global
	emuexe := "groovymame64_223.exe"
	file := "..\romlists\Arcade Horizontal.txt"
	Romset()
	Process, Close, %emuexe%
	check := list[Rand(list.MinIndex(), list.MaxIndex())]
	Run, C:\Games\Emulators\Groovymame\groovymame64_223.exe -keyboardprovider win32 -sound none -inipath C:\Games\Emulators\Groovymame\ -homepath C:\Games\Emulators\Groovymame\ %check%,,Hide
	sleep %timebetween%
}

RocketLaunch()
{
	global	
	emuexe := "retroarch.exe"
	file := "..\romlists\" sys ".txt"
	Romset()
	SendLevel, 1
	Send {Esc}
	check := list[Rand(list.MinIndex(), list.MaxIndex())]
	sleep 2000
	Run, C:\Games\RocketLauncher\RocketLauncher.exe -f "C:\Games\AttractMode\attract.exe" -p "AttractMode" -s "%sys%" -r "%check%"
	sleep %timebetween%
}

; Attract Mode generated romlists are used for input

Romset()
{
	global
	FileRead, data, %file%
	list := []
	loop, parse, data, "`n"
	{
		if (A_Index = 1)
		continue
		LineArray := StrSplit(A_LoopField, ";")
		list.push(LineArray[1])
	}
}

rand(min, max) 
{
	Random, out, min, max
	return out
}

; This Loop will make all joystick button pushes exit the screensaver

Loop 16 {
    i := A_Index
    Loop 16 {
        Hotkey, % i "Joy" A_Index, DismissScreensaver
    }
}


SetTimer, Relaunch, 1000
return

Relaunch:

Random, rand, 1, 8
	If (rand = 1)
	{
		sys := "Super Nintendo Entertainment System"
		RocketLaunch()
	}
	else if (rand = 2)
	{
		sys := "Sega Genesis"
		RocketLaunch()
	}
	else if (rand = 3)
	{
		sys := "Sega Dreamcast"
		RocketLaunch()
	}
	else if (rand = 4)
	{
		sys := "Sony Playstation"
		RocketLaunch()	
	}
	else if (rand = 5)
	{
		MameLaunch()	
	}
	else if (rand = 6)
	{
		sys := "Sammy Atomiswave"
		RocketLaunch()	
	}
	else if (rand = 7)
	{
		sys := "Panasonic 3DO"
		RocketLaunch()	
	}
	else if (rand = 8)
	{
		sys := "Daphne"
		RocketLaunch()	
	}
return		

; Exit Screensaver and return to attract mode
 
DismissScreensaver() 
	{
		global
		Process, Close, attract.exe
		Process, Close, %emuexe%
		FileCopy, ..\attract-nolaunch.cfg, ..\attract.cfg, 1
		sleep 500
		Run, ..\attract.exe --config c:\games\attractmode,,Hide
		sleep 5000
		FileCopy, ..\attract-launch.cfg, ..\attract.cfg, 1
		ExitApp
	}

return




