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

HotKeySet("{PAUSE}", "TogglePause")
HotKeySet("{NUMPAD0}", "Terminate")
HotKeySet("+!d", "ShowMessage") ; Shift-Alt-d

HotKeySet("{NUMPAD1}", "GetColor")
HotKeySet("{NUMPAD2}", "RecordLocations")
HotKeySet("{NUMPAD6}", "ExecuteSeries")
HotKeySet("{NUMPAD7}", "Bank")

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
	  If CheckForFullInv() = True or TimerDiff($prevTime) > 100000  Then
		 $prevTime = TimerInit()
		 ;Bank()
		 MouseClick("left",884,535, 1, 20) ;Bank
		 BankItems()
		 MakeGlass()
	  EndIf
   WEnd
EndFunc

Func Bank()
   WriteToConsole("-----Executing Bank() Function")
   MoveTowardsBank()
   ToggleRunEnergy()
   BankItems()
   SmeltFurnace()
   WriteToConsole("-----Bank() Function finished executing")
EndFunc

Func MakeGlass()
   MouseClick("left", 1468,763, 1, 20) ;Item1
   Sleep(500)
   MouseClick("left",1470,798, 1, 20) ;Item2
   Do
	  $aCoord = PixelSearch ( 328, 923, 383, 990, 7367017)
   Until IsArray($aCoord) = True
   Send("{6}")
EndFunc

Func MoveTowardsBank()
   WriteToConsole("Running MoveTowardsBank() Function")
   WriteToConsole("Opening Bank")
   MouseClick("left", Random(506,541),Random(613,644), 1, 20) ;Bank
EndFunc

Func ToggleRunEnergy()
   WriteToConsole("----------Executing ToggleRunEnergy() function")
   $aCoord = PixelSearch ( 1496, 170, 1496, 170, 9396793) ;Brown Boot
   $bCoord = PixelSearch ( 1487, 165, 1487, 165, 11250845) ;Grey Fill Bar
   If IsArray($aCoord) = True Then
	  If IsArray($bCoord) = True And IsArray($aCoord) = True Then
		 MouseClick("left", $aCoord[0], $aCoord[1], 1, 20)
	  EndIf
   EndIf
  WriteToConsole("----------ToggleRunEnergy() function finished executing")
EndFunc

Func BankItems()
   WriteToConsole("Running BankItems() Function")
   $aCoord=0
   Do
	  $aCoord = PixelSearch ( 870, 813, 900, 842, $depositBagColor)
   Until IsArray($aCoord) = True
   sleep(500)
   WriteToConsole("Depositing Items in bank")
   MouseClick("left", Random(880,890), Random(820,834), 1, 20) ;X=886, Y=828
   Sleep(500)
   ;MouseClick("left", $sandLocation[0], $sandLocation[1], 1, 20)
   MouseClick("left", $moltenGlass[0], $moltenGlass[1], 1, 20)
   ;Sleep(500)
   ;MouseClick("left", $sodaAshLocation[0], $sodaAshLocation[1], 1, 20)
   Sleep(500)
   Send("{ESC}")
EndFunc

Func SmeltFurnace()
	MouseClick("left", $furnaceLocation[0], $furnaceLocation[1], 1, 20) ;furnace
   Do
	  $aCoord = PixelSearch (210, 925, 310, 994, 14782058) ;Moltan Glass menu
   Until IsArray($aCoord) = True
   Sleep(500)
   Send("{1}")
EndFunc

Func CheckForFullInv()
   WriteToConsole("-----Running CheckForFullInv() function")
   Send("{F1}")
   Sleep(500)
   If IsArray(PixelSearch (1591, 983, 1591, 983, 8353398)) = True Then ;IsArray(PixelSearch (1583, 966, 1600, 990, 14069668)) = True Then ;Moltan Glass
	  WriteToConsole("Inventory Full")
	  Return True
   EndIf
   WriteToConsole("Inventory NOT Full")
   WriteToConsole("-----CheckForFullInv() function ended")
   Return False
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

Func RecordLocations()
   If $sandLocation = 0 Then
	  ConsoleWrite("Select Soda Ash in bank Location" & @LF )
	  $sandLocation = MouseGetPos()
   ElseIf $sodaAshLocation =  0 Then
	  ConsoleWrite("Select Furnace Location" & @LF )
	  $sodaAshLocation = MouseGetPos()
   ElseIf $furnaceLocation =  0 Then
	  ConsoleWrite("Select Molten Glass Location" & @LF )
	  $furnaceLocation = MouseGetPos()
   ElseIf $moltenGlass = 0 Then
	  $moltenGlass = MouseGetPos()
   EndIf
EndFunc



