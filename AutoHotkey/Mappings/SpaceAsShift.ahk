#Requires AutoHotkey v2.0
#Include ../Nodes/KeyStateNode.ahk


class SpaceAsShift {
    static isDown := false
    static keys := [
        "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "'", ;"^", 
        "q", "w", "e", "r", "t", "z", "u", "i", "o", "p", "è", "¨",
        "a", "s", "d", "f", "g", "h", "j", "k", "l", "é", "à", "$",
        "<", "y", "x", "c", "v", "b", "n", "m", ",", ".", "-"
    ]


    static OnSpaceUp() {
        if (A_PriorKey = "Space"){
            SendInput("{Space}")
        }
    }

    static OnSpaceAndKey(key) {
        key := RegExReplace(key, "i)^Space & ")
        
        if GetKeyState("CapsLock", "T")
            SendInput(key)
        else {
            ; remove "Space & " from string key
            SendInput("+" key)
        }
    }

    static Init() {
        
        Hotkey "Space", (k) => {}
        
        Hotkey "Space Up", (k) => SpaceAsShift.OnSpaceUp()

        for key in SpaceAsShift.keys
            Hotkey "Space & " key, (k) => SpaceAsShift.OnSpaceAndKey(k)
    }
}

; usage:
; SpaceAsShift.Init()