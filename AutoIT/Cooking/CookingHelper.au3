#include <MsgBoxConstants.au3>

; Press Esc to terminate script, Pause/Break to "pause"

Global $g_bPaused = True
Global $banker = 0
Global $deposit = 0
Global $fishBank = 0
Global $fishInv = 0
Global $fire = 0
Global $activateWindow = 0
Global $firstTreeActive = False

HotKeySet("{PAUSE}", "TogglePause")
HotKeySet("{NUMPAD0}", "Terminate")
HotKeySet("+!d", "ShowMessage") ; Shift-Alt-d

HotKeySet("{NUMPAD1}", "RecordLocations")

HotKeySet("{NUMPAD9}", "BankAndCook")


While 1
   Sleep(100)
   While Not $g_bPaused
        BankAndCook()
   WEnd
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

Func ShowMessage()
    MsgBox($MB_SYSTEMMODAL, "", "This is a message.")
EndFunc

Func BankAndCook()
   MouseClick("left", $activateWindow[0], $activateWindow[1], 1, 10)
   Sleep(500)
   MouseClick("left", $banker[0], $banker[1], 1, 10)
   Sleep(500)
   MouseClick("left", $deposit[0], $deposit[1], 1, 10)
   Sleep(500)
   MouseClick("left", $fishBank[0], $fishBank[1], 1, 10)
   Sleep(500)
   Send("{ESC}")
   Sleep(500)
   MouseClick("left", $fishInv[0], $fishInv[1], 1, 10)
   Sleep(500)
   MouseClick("left", $fire[0], $fire[1], 1, 10)
   Sleep(1000)
   Send("{1}")
   Sleep(69000)
EndFunc

Func RecordLocations()
   ConsoleWrite("Banker Location has been selected" & @LF )
   if $banker = 0 Then
	  ConsoleWrite("Select deposit Location" & @LF )
	  $banker = MouseGetPos()
   ElseIf $deposit = 0 Then
	  ConsoleWrite("Select fish in bank Location" & @LF )
	  $deposit = MouseGetPos()
   ElseIf $fishBank =  0 Then
	  ConsoleWrite("Select fish in inv Location" & @LF )
	  $fishBank = MouseGetPos()
   ElseIf $fishInv = 0 Then
	  ConsoleWrite("Select fire Location" & @LF )
	  $fishInv = MouseGetPos()
   ElseIf $fire = 0 Then
	  ConsoleWrite("Select active window Location" & @LF )
	  $fire = MouseGetPos()
   ElseIf $activateWindow = 0 Then
	  $activateWindow = MouseGetPos()
   EndIf
EndFunc



