#Requires AutoHotkey v2.0

global isSpam1Active := false
global LastM1Activity := 0
global LastKeyActivity := 0
global numSubTime := 0

F1::KeyHistory


#HotIf isSpam1Active
$q::SendInput("{Blind}w")
$w::SendInput("{Blind}q")
#HotIf

WriteLog(text) {
	FileAppend(A_NowUTC ": " text "`n", "logfile.txt") ; can provide a full path to write to another directory
}

CheckSpam1Activity(){
    global
    isSpam1Active := (A_TickCount - LastM1Activity) < 50
    if not isSpam1Active
        ToolTip()
}

isDoublePress(){
    firstPass := A_PriorHotkey == ""
    if firstPass
        return false
    
    dt := A_TickCount - LastKeyActivity
    shortTime := dt < 5
    ;sameKey := A_PriorHotkey == A_ThisHotkey
    ; ToolTip(shortTime " " sameKey ", " A_PriorHotkey " " A_ThisHotkey ", " deltaTime, , , 1)
    return shortTime ;&& sameKey
}

delayedPress(){
    global
    if not isSpam1Active
        SendInput("{Blind}{Numpad1}")
}


$NumpadSub::{
    global
    numSubTime := A_TickCount
    SetTimer CheckSpam1Activity, -10
}

$Numpad1::{
    global

    if isDoublePress() {
        isSpam1Active := true
        LastM1Activity := A_TickCount
        SetTimer CheckSpam1Activity, -75
        ToolTip("isSpam1Active", , , 1)
        return
    } else if not isSpam1Active
        SetTimer delayedPress, -10
    
    LastKeyActivity := A_TickCount
}
