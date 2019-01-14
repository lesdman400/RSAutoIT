#include <MsgBoxConstants.au3>
#include <ImageS.au3>
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
HotKeySet("{NUMPAD7}", "DropLogs")

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

Func CutTree()
   MouseClick("left", 1468,763, 1, 20) ;Item1
   Sleep(500)
   MouseClick("left",1470,798, 1, 20) ;Item2
   Do
	  $aCoord = PixelSearch ( 328, 923, 383, 990, 7367017)
   Until IsArray($aCoord) = True
   Send("{6}")
EndFunc

Func DropLogs()
      MouseClick("left", 1522, 720,1)
	  Local $prevY = 0
	  Local $prevX = 0
	  Local $counterX = 0
	  Local $counterY = 0
   Do
	  Local $search = 0
	  Local $y = 0
	  Local $x = 0
	  $willowLogExists = _ImageSearchArea('WillowLog.bmp', 1, 1440, 750, 1600, 1000, $x, $y, 10)
	  If $willowLogExists = 1 Then
		 $y = 0
		 $x = 0
		 WriteToConsole("CounterX: " & $counterX)
		 WriteToConsole("CounterY: " & $counterY)
		 MouseMove(1437+(42*$counterX), 746+(35.7*$counterY))
		 Sleep(300)
		 MouseMove(1437+(42*($counterX+1)), 746+(35.7*($counterY+1)))
		 Sleep(300)
		 $search = _ImageSearchArea('WillowLog.bmp', 1, 1435+(42*$counterX), 746+(35.7*$counterY), 1435+(42*($counterX+1)), 746+(35.7*($counterY+1)), $x, $y, 50);_ImageSearch('WillowLog.bmp', 0, $x, $y, 0)
		 WriteToConsole("Finding Image")
		 If $search = 1 Then
			WriteToConsole("Image Found")
			Send("{SHIFTDOWN}")
			MouseClick("left", $x, $y, 1, 20) ;WillowLog
			Send("{SHIFTUP}")
			If $counterX < 3 Then
			   $counterX = $counterX+1
			Else
			   $counterX = 0
			   If $counterY < 6 Then
				  $counterY = $counterY+1
			   EndIf
			EndIf
		 Else
			WriteToConsole("Image Not Found")
			If $counterX < 3 Then
			   $counterX = $counterX+1
			Else
			   $counterX = 0
			   If $counterY < 6 Then
				  $counterY = $counterY+1
			   EndIf
			EndIf
		 EndIf
	  EndIf
   Until $willowLogExists = 0
EndFunc

Func CheckForFullInv()
   WriteToConsole("-----Running CheckForFullInv() function")
   Send("{F1}")
   Sleep(500)
   If IsArray(PixelSearch (1584, 982, 1584, 982, 4603672)) = True Then ;Willow Tree
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



