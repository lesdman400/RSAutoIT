#include <MsgBoxConstants.au3>
#include <ImageSearch.au3>
#include <GDIPlus.au3>

; Press Esc to terminate script, Pause/Break to "pause"
Global $isRunning = False
Global $g_bPaused = True

Global $banker = 0
Global $deposit = 0
Global $sandLocation = 0
Global $sodaAshLocation = 0
Global $furnaceLocation = 0
Global $activateWindow = 0
Global $depositBagColor = 4250693
Global $greyFillBar =  0
Global $brownBoot =  0
Global $moltenGlass = 0
Global $prevTime = 0
HotKeySet("{PAUSE}", "TogglePause")
HotKeySet("{NUMPAD0}", "Terminate")
HotKeySet("+!d", "ShowMessage") ; Shift-Alt-d

HotKeySet("{NUMPAD1}", "GetColor")
HotKeySet("{NUMPAD6}", "ExecuteSeries")
HotKeySet("{NUMPAD7}", "StealNatureRune")

Global $prevTime = 0
While 1
   Sleep(5000)
WEnd

Func TogglePause()
    $g_bPaused = Not $g_bPaused
    While $g_bPaused
        Sleep(100)
        ToolTip('Script is "Paused"', 0, 0)
	 WEnd
    ToolTip("")
EndFunc   ;==>TogglePause

Func Terminate()
    Exit
EndFunc   ;==>Terminate

Func ExecuteSeries()
   While True
	  $timesAlched = 0
	  $prevTime = TimerInit()
	  StealNatureRune()
	  Do
		 Sleep(100)
	  Until(IsArray(PixelSearch (602, 432, 602, 432, 12303281)) = False)
	  Do
		 If CheckForAlchItem() = True And $timesAlched < 1 Then
			HighAlch()
			$timesAlched = $timesAlched + 1
		 EndIf
	  Until TimerDiff($prevTime) > 15000
   WEnd
EndFunc

Func CheckForAlchItem()
   WriteToConsole("-----Running CheckForAlchItem() function")
   Sleep(500)
   Send("{F1}")
   If IsArray(PixelSearch (1589, 836, 1589, 836, 12035964)) = True Then ;IsArray(PixelSearch (1583, 966, 1600, 990, 14069668)) = True Then ;Moltan Glass
	  WriteToConsole("alch Item available")
	  Return True
   EndIf
   WriteToConsole("No alch Item available")
   WriteToConsole("-----CheckForAlchItem() function ended")
   Return False
EndFunc

Func StealNatureRune()
   $aCoord = PixelSearch (410, 493, 740, 665, 7631629) ;Chest
   MouseClick("Right", $aCoord[0],$aCoord[1], 1, 20) ;Search for traps
   MouseClick("Left", Random($aCoord[0]-20,$aCoord[0]+20 ,1),($aCoord[1]+(15.6 * 2.5)),1,20)
EndFunc

Func HighAlch()
   Send("{F4}")
   Sleep(500)
   MouseClick("left", 1611, 847, 1, 20) ;HA
   Sleep(300)
   MouseClick("left", 1600, 840, 1, 20) ;HA
   Sleep(500)
EndFunc

Func WriteToConsole($var)
   ConsoleWrite($var & @lf)
EndFunc

Func GetColor()
      $mouselocation = MouseGetPos()
         ConsoleWrite("Mouse Pos: " & $mouselocation[0] & "," & $mouselocation[1] & @LF )
   $Color = PixelGetColor($mouselocation[0], $mouselocation[1])
      ConsoleWrite("Color is: " & $Color & @LF )
EndFunc



