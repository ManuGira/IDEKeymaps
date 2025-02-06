#Requires AutoHotkey v2.0

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

    static Init() {
        Hotkey("Space", (k) => SpaceAsShift.OnSpaceDown())
        Hotkey("Space Up", (k) => SpaceAsShift.OnSpaceUp())
    }
}

; usage:
; SpaceAsShift.Init()