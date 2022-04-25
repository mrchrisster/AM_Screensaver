#NoEnv
#Persistent
#SingleInstance Force

FormatTime, TimeString
Process, Close, attract.exe

Random,,%A_TickCount% ; Generate Seed for more randomness
SetWorkingDir %A_ScriptDir%

; Delete previous log file
FileDelete,d:\lastgame.txt


timebetween := 130000 ; How long to show each game, define in milliseconds

RetroLaunch()
{
	global	
	emuexe := "retroarch.exe"
	; Attract Mode generated romlists are used for input
	file := "..\romlists\" sys ".txt"
	Romset()
	Romcheck()
	SendLevel, 1
	Send {Esc}
	sleep 1500
	Send {Esc}
	Process, Close, %emuexe%

	FileAppend,%sys% - %check% (%TimeString%)`n,d:\lastgame.txt
	sleep 2000
	SetWorkingDir, "C:\Games\Emulators\Retroarch"
	Run, C:\Games\Emulators\Retroarch\retroarch.exe --config C:\Games\Emulators\RetroArch\retroarchss.cfg -L "%libcore%" "C:\Games\Games\%sys%\%check%.%end%"
	sleep %timebetween%
}

Daphne()
{
	global	
	; Attract Mode generated romlists are used for input
	file := "..\romlists\" sys ".txt"
	Romset()
	Romcheck()
	SendLevel, 1
	Send {Esc}
	sleep 1500
	Send {Esc}
	Process, Close, groovymame64_223.exe
	Process, Close, %emuexe%

	FileAppend,%sys% - %check% (%TimeString%)`n,d:\lastgame.txt
	sleep 2000
	Run, C:\Games\Emulators\Daphne\daphne.exe %check% vldp -blank_searches -noserversend -fastboot -useoverlaysb 1  -fullscreen -x 640 -y 480 -homedir . -nosound -framefile "C:\Games\Emulators\%sys%\framefile\%check%.%end%"
	sleep %timebetween%
}




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

; Make sure check variable is not empty
Romcheck()
{	
	global
	Loop
		{
		check := list[Rand(list.MinIndex(), list.MaxIndex())]
			If (check = "")
				continue
			else
				break
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

Hotkey, 1, DismissScreensaver

SetTimer, Relaunch, 1000
return

Relaunch:

;Random, rand, 5, 5
Random, rand, 1, 11
	If (rand = 1)
	{
		sys := "Super Nintendo Entertainment System"
		end := "sfc"
		libcore := "C:\Games\Emulators\RetroArch\cores\bsnes_mercury_balanced_libretro.dll"
		RetroLaunch()
	}
	else if (rand = 2)
	{
		sys := "Sega Genesis"
		end := "md"
		libcore := "C:\Games\Emulators\RetroArch\cores\genesis_plus_gx_libretro.dll"
		RetroLaunch()
	}
	else if (rand = 3)
	{
		sys := "Sega Dreamcast"
		end := "chd"
		libcore := "C:\Games\Emulators\RetroArch\cores\flycast_libretro.dll"		
		RetroLaunch()
	}
	else if (rand = 4)
	{
		sys := "Sony Playstation"
		end := "chd"
		libcore := "C:\Games\Emulators\RetroArch\cores\duckstation_libretro.dll"
		RetroLaunch()	
	}
	else if (rand = 5)
	{
		sys := "Mame Horizontal"
		end := "zip"
		libcore := "C:\Games\Emulators\RetroArch\cores\mame_libretro.dll"
		RetroLaunch()	

	
	}
	else if (rand = 6)
	{
		sys := "Sammy Atomiswave"
		end := "zip"
		libcore := "C:\Games\Emulators\RetroArch\cores\flycast_libretro.dll"
		RetroLaunch()	
	}
	else if (rand = 7)
	{
		sys := "Panasonic 3DO"
		end := "chd"
		libcore := "C:\Games\Emulators\RetroArch\cores\4do_libretro.dll"
		RetroLaunch()	
	}
	else if (rand = 8)
	{
		sys := "Daphne"
		end := "txt"
		Daphne()	
	}
	else if (rand = 9)
	{
		sys := "Sega Saturn"
		end := "chd"
		libcore := "C:\Games\Emulators\RetroArch\cores\mednafen_saturn_libretro.dll"
		RetroLaunch()	
	}
	else if (rand = 10)
	{
		sys := "Nintendo 64"
		end := "n64"
		libcore := "C:\Games\Emulators\RetroArch\cores\mupen64plus_next_libretro.dll"
		RetroLaunch()	
	}
	else if (rand = 11)
	{
		sys := "Nintendo Gamecube"
		end := "gcz"
		libcore := "C:\Games\Emulators\RetroArch\cores\dolphin_libretro.dll"
		RetroLaunch()	
	}
return		

; Exit Screensaver and return to attract mode
 
DismissScreensaver() 
	{
		global
		Process, Close, attract.exe
		Process, Close, %emuexe%
		sleep 150
		Send {Esc}
		
		; don't start a game on startup
		FileRead, text, ..\attract.cfg
		startupnolaunch := "startup_mode         default"
		startuplaunch := "startup_mode         launch_last_game"
		newtext := strreplace(text, startuplaunch, startupnolaunch)
		filedelete, ..\attract.cfg
		fileappend, %newtext%, ..\attract.cfg
		sleep 500
		Run, ..\attract.exe --config c:\games\attractmode,,Hide
		;sleep 5000
		;newtext := strreplace(text, startupnolaunch, startuplaunch)
		;filedelete, ..\attract.cfg
		;fileappend, %newtext%, ..\attract.cfg
		
		ExitApp
	}

return




