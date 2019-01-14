#include <MsgBoxConstants.au3>

; Press Esc to terminate script, Pause/Break to "pause"

Global $g_bPaused = False
Global $tree_1 = 0
Global $tree_2 = 0
Global $inventoryStart = 0
Global $inventoryItemSpacing = 0
Global $activateWindow = 0
Global $firstTreeActive = False

HotKeySet("{PAUSE}", "TogglePause")
HotKeySet("{ESC}", "Terminate")
HotKeySet("+!d", "ShowMessage") ; Shift-Alt-d

HotKeySet("{NUMPAD0}", "GetTreeLocation")
HotKeySet("{NUMPAD1}", "GetInvStartAndEndPos")
HotKeySet("{NUMPAD2}", "Window")

HotKeySet("{NUMPAD8}", "DropInv")
HotKeySet("{NUMPAD9}", "ClickTree")


While 1
   Sleep(100)
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

Func DropInv()
   $previousMousePosition = MouseGetPos()
   $column = 0
   $row = 0
   MouseClick("left", $activateWindow[0], $activateWindow[1],1)
   While $row < 7
	  While $column < 4
		 MouseMove((($inventoryStart[0] - ($column * ($inventoryStart[0] - $inventoryItemSpacing[0])))) + Random(-3,3),(($inventoryStart[1] - ($row * ($inventoryStart[1] - $inventoryItemSpacing[1])))) + Random(-3,3))
		 Sleep(100)
		 Send("{SHIFTDOWN}")
		 MouseClick("left")
		 Send("{SHIFTUP}")
		 $column = $column+1
	   ConsoleWrite('Column# ' & $column & @LF )
	  WEnd
	   ConsoleWrite('Row# ' & $row & @LF )
	   $column = 0
	  $row = $row+1
   WEnd
   ConsoleWrite("Ending DropInv() Function" & @LF )

   ClickTree()
   MouseMove($previousMousePosition[0], $previousMousePosition[1])
 EndFunc

 Func ClickTree()
	$previousMousePosition = MouseGetPos()
   If Not $firstTreeActive Then
	  MouseClick("left", $tree_1[0]+Random(-5,5), $tree_1[1]+Random(-5,5), 1)
	  $firstTreeActive = True
   Else
	  MouseClick("left", $tree_2[0]+Random(-5,5), $tree_2[1]+Random(-5,5), 1)
	  $firstTreeActive = False
   EndIf
	  MouseMove($previousMousePosition[0], $previousMousePosition[1])
    ConsoleWrite("First Tree Clicked" & $firstTreeActive & @LF )
EndFunc


Func Window()
   $activateWindow = MouseGetPos()
    ConsoleWrite($activateWindow[0] & $activateWindow[1])
EndFunc

Func GetInvStartAndEndPos()
   If $inventoryStart = "" Then
	  $inventoryStart = MouseGetPos()
	  ConsoleWrite($inventoryStart[0] & $inventoryStart[1])
   Else
	  $inventoryItemSpacing = MouseGetPos()
	  ConsoleWrite($inventoryItemSpacing[0] & $inventoryItemSpacing[1])
   EndIf
EndFunc

Func GetTreeLocation()
   If $tree_1 = "" Then
	  $tree_1 = MouseGetPos()
	  ConsoleWrite($tree_1[0] & $tree_1[1])

   Else
	  $tree_2 = MouseGetPos()
	  ConsoleWrite($tree_2[0] & $tree_2[1])
   EndIf
EndFunc

