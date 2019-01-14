#include <MsgBoxConstants.au3>
#include <ImageSearch.au3>
#include <GDIPlus.au3>

; Press Esc to terminate script, Pause/Break to "pause"
Global $isRunning = False
Global $g_bPaused = True

Global $bankLampColor = 13145624
Global $bankerColor = 11412501 ;TODO reopen bank by bankers shirt color
Global $depositBagColor = 4250693
Global $menuColorBlack = 0
Global $menuColorYellow = 16776960
Global $menuColorBlue = 65535
Global $menuColorBrown = 6116423
Global $menuColorWhite = 16777215
Global $worldCounter = 1
Global $traderColor[2] = [1133205,1909827];colors are blue

Global $previousTime = 0

Global $timesRun = 0

HotKeySet("{PAUSE}", "TogglePause")
HotKeySet("{NUMPAD0}", "Terminate")
HotKeySet("+!d", "ShowMessage") ; Shift-Alt-d

HotKeySet("{NUMPAD1}", "GetColor")

HotKeySet("{NUMPAD6}", "ExecuteSeries")
HotKeySet("{NUMPAD7}", "Bank")
HotKeySet("{NUMPAD8}", "ChangeWorld")
HotKeySet("{NUMPAD9}", "Buy")

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
;	  Do
;		 WriteToConsole("@@@@@@@@@@@@@@@@@@@---Logout Prevention Activated---@@@@@@@@@@@@@@@@@@@@@")
;		 Sleep((20000 - TimerDiff($previousTime)))
;	  Until TimerDiff($previousTime) >= 20000
;	  $previousTime = TimerInit()
	  If CheckForFullInv() = True Then
		 Bank()
	  Else
		 ChangeWorld()
	  EndIf
	  $timesRun = $timesRun + 1
	  WriteToConsole("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" & $timesRun & "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
   WEnd
EndFunc

Func Buy()
   WriteToConsole("-----Starting Buy() Function")
   if $isRunning = False Then
	  $isRunning = True
	  WriteToConsole("Executing Buy() Function")
	  WriteToConsole("Opening bag")
	  Send("{F1}")
	  ClickTrader()
	  ClickItems()
	  $isRunning = False
   Else
	  WriteToConsole("Please wait for script to finish executing before calling the Buy() function again")
   EndIf
   WriteToConsole("-----Ending Buy() Function")
   Sleep(1000)
EndFunc

Func ChangeWorld()
   WriteToConsole("-----Starting ChangeWorld() Function")
	  $distanceBetweenEachWorld = 16
	  WriteToConsole("Opening world change menu")
	  Send("{F12}")
	  if $worldCounter > 12 Then
		 $worldCounter = 0
	  EndIf
	  WriteToConsole("Selecting new world")
	  $menuToClick = (765 + ($distanceBetweenEachWorld * $worldCounter))
	  MouseClick("left", 1520, $menuToClick , 1, 20)
	  WriteToConsole("World changed")
	  $worldCounter = $worldCounter + 1

	  WriteToConsole("Waiting for world to load")
	  Do
		 $aCoord = PixelSearch (1520-10, $menuToClick-5, 1520+10, $menuToClick+5, 1856020) ;Green Menu
	  Until IsArray($aCoord) = True
	  WriteToConsole("-----World loaded")
	  Send("{F1}")
	  ClickTrader()
	  ClickItems()
EndFunc

Func ChangeWorldOSB()
   WriteToConsole("-----Starting ChangeWorldOSB() Function")

   $distanceBetweenEachWorld = 16
   WriteToConsole("Opening world change menu")
   Send("{F12}")
   if $worldCounter > 12 Then
	  $worldCounter = 0
   EndIf
   WriteToConsole("Selecting new world")
   $menuToClick = (765 + ($distanceBetweenEachWorld * $worldCounter))
   MouseClick("left", 1520, $menuToClick , 1, 20)
   WriteToConsole("World changed")
   $worldCounter = $worldCounter + 1

   WriteToConsole("Waiting for world to load")
   Do
	  $aCoord = PixelSearch (1520-10, $menuToClick-5, 1520+10, $menuToClick+5, 1856020) ;Green Menu
   Until IsArray($aCoord) = True
   WriteToConsole("-----World loaded")
   Send("{F1}")
   ClickTrader()
   ClickItems()
EndFunc

Func Bank()
   WriteToConsole("-----Executing Bank() Function")
   MoveTowardsBank()
   ;ToggleRunEnergy()
   BankItems()
   ClickTrader()
   ClickItems()
   ChangeWorld()
   WriteToConsole("-----Bank() Function finished executing")
EndFunc

Func ClickTrader()
   WriteToConsole("-----Running ClickTrader() Function")

   $isRunningClickTrader = True
	if $isRunningClickTrader = True Then
	  $aCoord = 0
	  Do
		 $aCoord = PixelSearch (265,514,1600,600,$traderColor[Random(0,1,1)])
		 if IsArray($aCoord) = True Then
			WriteToConsole("Trader Found: " & $aCoord[0] & "," & $aCoord[1] & ", Opening rightclick menu")

			MouseClick("right", $aCoord[0], $aCoord[1], 1, 0)
			If (IsArray(PixelSearch ($aCoord[0]-80,$aCoord[1],$aCoord[0]+80,$aCoord[1]+106,$menuColorBlack)) = False) _
				  Or (IsArray(PixelSearch ($aCoord[0]-10,$aCoord[1],$aCoord[0]+10,$aCoord[1]+25,$menuColorYellow)) = False) _
				  Or (IsArray(PixelSearch ($aCoord[0]-80,$aCoord[1],$aCoord[0]+80,$aCoord[1]+106,$menuColorWhite)) = False) _
				  Or (IsArray(PixelSearch ($aCoord[0]-80,$aCoord[1],$aCoord[0]+80,$aCoord[1]+106,$menuColorBrown)) = False) Then
			   Sleep(500)
			   WriteToConsole("!!!!!!!!!Trader Menu not found!!!!!!!!!!!!")
			   MouseMove($aCoord[0],$aCoord[1]-20)
			   WriteToConsole("Searching for trader again")
			   $aCoord = 0
			EndIf
		 EndIf
	  Until (IsArray($aCoord) = True)
	  WriteToConsole("Trader store opened")
	  if IsArray($aCoord) then MouseClick("left", Random(($aCoord[0] - 40), ($aCoord[0] + 40)), ($aCoord[1] + 47.15), 1, 10)
   EndIf
   WriteToConsole("-----ClickTrader() Function ended")
   $isRunningClickTrader = False
EndFunc

Func ClickItems()
   WriteToConsole("-----Running ClickItems() Function")

   $isRunningClickItems = False
   if $isRunningClickItems = False Then
	  $isRunningClickItems = True
	  $counter = 0
	  $aCoord = 0
	  $bCoord = 0
	  $cCoord = 0

	  WriteToConsole("Waiting for store gui to open")
	Do
		 $aCoord = PixelSearch ( 629, 449, 629, 449, 1621277) ;Slimebucket
		 $bCoord = PixelSearch ( 723, 408, 723, 408, 6884743) ;Securitybook
		 $cCoord = PixelSearch ( 632, 492, 492, 408, 12736024) ;TyrasHelmet
		 $counter = $counter + 1
	  Until (IsArray($aCoord) = True And IsArray($bCoord) = True And IsArray($cCoord) = True) Or $counter = 200

	 If IsArray($aCoord) = False And IsArray($bCoord) = False And IsArray($cCoord) = False  then
		 WriteToConsole("Finding Trader again, store did not open")
		 ClickTrader()
		 Sleep(1000)

	  Else
		 if CheckForFullInv() = False Then
			$aCoord = PixelSearch ( 629, 449, 629, 449, 1621277) ;Slimebucket
			WriteToConsole("Buying sand buckets from store")
			MouseClick("right", $aCoord[0], 456, 1, 10) ;Random replaced 725
			MouseClick("left", $aCoord[0], (456 + 76), 1, 20) ;Random replace 725
		 EndIf
;~ 		 If CheckForFullInv() = False Then
;~ 			WriteToConsole("Buying sand buckets from store")
;~ 			MouseClick("right", Random(715,735), 456, 1, 10) ;Random replaced 725
;~ 			MouseClick("left", Random(685,765), (456 + 76), 1, 20) ;Random replace 725
;~ 		 EndIf
		 Sleep(300)
		 If CheckForFullInv() = False Then
			WriteToConsole("Buying soda ash from store")
			MouseClick("right", Random(810,830), 456, 1, 10)
			MouseClick("left", Random(780,859), (456 + 76), 1, 20)
		 EndIf

		 CheckForFullInv()
	  EndIf

	  WriteToConsole("Closing store")
	  Send("{ESC}")
   EndIf
   WriteToConsole("-----ClickItems() function ended")
   $isRunningClickItems = False
   Sleep(500)
EndFunc

Func MoveTowardsBank()
   WriteToConsole("Running MoveTowardsBank() Function")

   $aCoord=0
   Do
	  $aCoord = PixelSearch ( 6, 247, 458, 330, $bankLampColor)
   Until IsArray($aCoord) = True
   $xLocation = $aCoord[0]
   If $xLocation > 390 then $xLocation = $xLocation - 15 ;Off set click location to avoid opening poll menu in bank

   WriteToConsole("Right clicking to find bank menu")
   MouseClick("right",$xLocation , $aCoord[1], 1, 10)
   Sleep(500)
   if IsArray(PixelSearch ($xLocation-10,$aCoord[1],$xLocation+10,$aCoord[1]+70,$menuColorBlue)) = False Then ;TODO search for banker shirt color
		 WriteToConsole("Bank Menu not found")
		 MoveTowardsBank()
   EndIf
   WriteToConsole("Opening Bank")
   MouseClick("left", Random(($xLocation-20),($xLocation+20)), $aCoord[1]+25, 1, 10)
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
   Send("{ESC}")
   WriteToConsole("Moving to traders via minimap")
   MouseClick("left", 1620, 174, 1, 20)
EndFunc

Func CheckForFullInv()
   WriteToConsole("-----Running CheckForFullInv() function")
   Send("{F1}")
   Sleep(500)
   If IsArray(PixelSearch ( 1593, 982, 1594, 982, 12498100)) = True Then ;Sodaash
	  WriteToConsole("Inventory Full")
	  Return True
   ElseIf IsArray(PixelSearch ( 1593, 975, 1593, 975, 9732948)) = True Then ;Bucket
	  WriteToConsole("Inventory Full")
	  Return True
   ElseIf IsArray(PixelSearch ( 1583, 966, 1600, 990, 1621277)) = True then ;slimebucket
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
   $traderColor = PixelGetColor($mouselocation[0], $mouselocation[1])
      ConsoleWrite("Color is: " & $traderColor & @LF )
EndFunc

Func SetSearchArea()
	  if $traderArea[0][0] = 0 Then
		 $mousePos =  MouseGetPos()
		$traderArea[0][0] = $mousePos[0]
		 $traderArea[0][1] = $mousePos[1]
		 ConsoleWrite("$traderArea 1x: " & $traderArea[0][0] )
		   ConsoleWrite("$traderArea 1y: " & $traderArea[0][1] & @LF )

	  Elseif $traderArea[0][0] > 0 And $traderArea[1][0] = 0 Then
			$mousePos =  MouseGetPos()
		   $traderArea[1][0] = $mousePos[0]
			$traderArea[1][1] = $mousePos[1]
			   ConsoleWrite("$traderArea 2x: " & $traderArea[1][0] )
			     ConsoleWrite("$traderArea 2y: " & $traderArea[1][1] & @LF )

	  Elseif $buyArea[0][0] = 0 Then
		 $mousePos =  MouseGetPos()
		$buyArea[0][0] = $mousePos[0]
		 $buyArea[0][1] = $mousePos[1]
		 ConsoleWrite("$buyArea 1x: " & $buyArea[0][0] )
		   ConsoleWrite("$buyArea 1y: " & $buyArea[0][1] & @LF )

	  Elseif $buyArea[0][0] > 0 And $buyArea[1][0] = 0 Then
			$mousePos =  MouseGetPos()
		   $buyArea[1][0] = $mousePos[0]
			$buyArea[1][1] = $mousePos[1]
			   ConsoleWrite("$buyArea 2x: " & $buyArea[1][0] )
			     ConsoleWrite("$buyArea 2y: " & $buyArea[1][1] & @LF )
	  EndIf
EndFunc



