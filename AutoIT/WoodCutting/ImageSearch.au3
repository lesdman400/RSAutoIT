#AutoIt3Wrapper_UseX64=n ; Set to Y or N depending on your situation/preference!!
#include-once
#include <WinAPIFiles.au3> ; for _WinAPI_Wow64EnableWow64FsRedirection

#Region When running compiled script, Install needed DLLs if they don't exist yet
If Not FileExists("ImageSearchDLLx32.dll") Then FileInstall("ImageSearchDLLx32.dll", "ImageSearchDLLx32.dll", 1);FileInstall ( "source", "dest" [, flag = 0] )
If Not FileExists("ImageSearchDLLx64.dll") Then FileInstall("ImageSearchDLLx64.dll", "ImageSearchDLLx64.dll", 1)
If Not FileExists("msvcr110d.dll") Then FileInstall("msvcr110d.dll", "msvcr110d.dll", 1);Microsoft Visual C++ Redistributable dll x64
If Not FileExists("msvcr110.dll") Then FileInstall("msvcr110.dll", "msvcr110.dll", 1);Microsoft Visual C++ Redistributable dll x32
#EndRegion

Local $h_ImageSearchDLL = -1; Will become Handle returned by DllOpen() that will be referenced in the _ImageSearchRegion() function

#Region ImageSearch Startup/Shutdown
Func _ImageSearchStartup()
    _WinAPI_Wow64EnableWow64FsRedirection(True)
    $sOSArch = @OSArch ;Check if running on x64 or x32 Windows ;@OSArch Returns one of the following: "X86", "IA64", "X64" - this is the architecture type of the currently running operating system.
    $sAutoItX64 = @AutoItX64 ;Check if using x64 AutoIt ;@AutoItX64 Returns 1 if the script is running under the native x64 version of AutoIt.
    If $sOSArch = "X86" Or $sAutoItX64 = 0 Then
        $h_ImageSearchDLL = DllOpen("ImageSearchDLLx32.dll")
        If $h_ImageSearchDLL = -1 Then Return "DllOpen failure"
    ElseIf $sOSArch = "X64" And $sAutoItX64 = 1 Then
        $h_ImageSearchDLL = DllOpen("ImageSearchDLLx64.dll")
        If $h_ImageSearchDLL = -1 Then Return "DllOpen failure"
    Else
        Return "Inconsistent or incompatible Script/Windows/CPU Architecture"
    EndIf
    Return True
EndFunc   ;==>_ImageSearchStartup

Func _ImageSearchShutdown()
    DllClose($h_ImageSearchDLL)
    _WinAPI_Wow64EnableWow64FsRedirection(False)
    Return True
EndFunc   ;==>_ImageSearchShutdown
#EndRegion ImageSearch Startup/Shutdown
; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.0
; Language:       English
; Description:    Functions that assist with Image Search
;                 Require that the ImageSearchDLL.dll be loadable
;
; ------------------------------------------------------------------------------

;===============================================================================
;
; Description:      Find the position of an image on the desktop
; Syntax:           _ImageSearchArea, _ImageSearch
; Parameter(s):
;                   $findImage - the image to locate on the desktop
;                   $tolerance - 0 for no tolerance (0-255). Needed when colors of
;                                image differ from desktop. e.g GIF
;                   $resultPosition - Set where the returned x,y location of the image is.
;                                     1 for centre of image, 0 for top left of image
;                   $x $y - Return the x and y location of the image
;
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns 0
;
; Note: Use _ImageSearch to search the entire desktop, _ImageSearchArea to specify
;       a desktop region to search
;
;===============================================================================
Func _ImageSearch($findImage,$resultPosition,ByRef $x, ByRef $y,$tolerance, $HBMP=0)
   ConsoleWrite("Running")
   return _ImageSearchArea($findImage,$resultPosition,0,0,@DesktopWidth,@DesktopHeight,$x,$y,$tolerance,$HBMP)
EndFunc

Func _ImageSearchArea($findImage,$resultPosition,$x1,$y1,$right,$bottom,ByRef $x, ByRef $y, $tolerance,$HBMP=0)
   ;MsgBox(0,"asd","" & $x1 & " " & $y1 & " " & $right & " " & $bottom)
   ConsoleWrite("$findImage: " & $findImage)
   if $tolerance>0 then $findImage = "*" & $tolerance & " " & $findImage
   If IsString($findImage) Then
	   $result = DllCall("ImageSearchDLL.dll","str","ImageSearch","int",$x1,"int",$y1,"int",$right,"int",$bottom,"str",$findImage,"ptr",$HBMP)
   Else
	   $result = DllCall("ImageSearchDLL.dll","str","ImageSearch","int",$x1,"int",$y1,"int",$right,"int",$bottom,"ptr",$findImage,"ptr",$HBMP)
   EndIf

   ; Error checking goes here
   If (IsArray($result) = False) Then Return 0
   ; If error exit
   if $result[0]="0" then return 0

   ; Otherwise get the x,y location of the match and the size of the image to
   ; compute the centre of search
   $array = StringSplit($result[0],"|")

   $x=Int(Number($array[2]))
   $y=Int(Number($array[3]))
   if $resultPosition=1 then
      $x=$x + Int(Number($array[4])/2)
      $y=$y + Int(Number($array[5])/2)
   endif
   return 1
EndFunc

;===============================================================================
;
; Description:      Wait for a specified number of seconds for an image to appear
;
; Syntax:           _WaitForImageSearch, _WaitForImagesSearch
; Parameter(s):
;					$waitSecs  - seconds to try and find the image
;                   $findImage - the image to locate on the desktop
;                   $tolerance - 0 for no tolerance (0-255). Needed when colors of
;                                image differ from desktop. e.g GIF
;                   $resultPosition - Set where the returned x,y location of the image is.
;                                     1 for centre of image, 0 for top left of image
;                   $x $y - Return the x and y location of the image
;
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns 0
;
;
;===============================================================================
Func _WaitForImageSearch($findImage,$waitSecs,$resultPosition,ByRef $x, ByRef $y,$tolerance,$HBMP=0)
	$waitSecs = $waitSecs * 1000
	$startTime=TimerInit()
	While TimerDiff($startTime) < $waitSecs
		sleep(100)
		$result=_ImageSearch($findImage,$resultPosition,$x, $y,$tolerance,$HBMP)
		if $result > 0 Then
			return 1
		EndIf
	WEnd
	return 0
EndFunc

;===============================================================================
;
; Description:      Wait for a specified number of seconds for any of a set of
;                   images to appear
;
; Syntax:           _WaitForImagesSearch
; Parameter(s):
;					$waitSecs  - seconds to try and find the image
;                   $findImage - the ARRAY of images to locate on the desktop
;                              - ARRAY[0] is set to the number of images to loop through
;								 ARRAY[1] is the first image
;                   $tolerance - 0 for no tolerance (0-255). Needed when colors of
;                                image differ from desktop. e.g GIF
;                   $resultPosition - Set where the returned x,y location of the image is.
;                                     1 for centre of image, 0 for top left of image
;                   $x $y - Return the x and y location of the image
;
; Return Value(s):  On Success - Returns the index of the successful find
;                   On Failure - Returns 0
;
;
;===============================================================================
Func _WaitForImagesSearch($findImage,$waitSecs,$resultPosition,ByRef $x, ByRef $y,$tolerance,$HBMP=0)
	$waitSecs = $waitSecs * 1000
	$startTime=TimerInit()
	While TimerDiff($startTime) < $waitSecs
		for $i = 1 to $findImage[0]
		    sleep(100)
		    $result=_ImageSearch($findImage[$i],$resultPosition,$x, $y,$tolerance,$HBMP)
		    if $result > 0 Then
			    return $i
		    EndIf
		Next
	WEnd
	return 0
EndFunc

