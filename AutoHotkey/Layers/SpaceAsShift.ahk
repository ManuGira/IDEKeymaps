#Requires AutoHotkey v2.0
#Include ../Utils/Conditional.ahk
class SpaceAsShift {
    static OnSpaceDown() {
        SendInput("{Blind}{ShiftDown}")
    }
    
    static OnSpaceUp() {
        if (A_PriorKey = "Space")
            SendInput("{ShiftUp}{Space}")
        else
            SendInput("{ShiftUp}")
    }

    static Init(condition) {
        Conditional.Hotkey("$Space", (k) => SpaceAsShift.OnSpaceDown(), condition)
        Conditional.Hotkey("$Space Up", (k) => SpaceAsShift.OnSpaceUp(), condition)
    }
}

; usage:
; SpaceAsShift.Init()