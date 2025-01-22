#Requires AutoHotkey v2.0
#Include KeyStateObserver.ahk


class SpaceIsShift {
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
        ; remove "Space & " from string key
        key := RegExReplace(key, "i)^Space & ")
        SendInput("+" key)
    }

    static Init() {
        
        Hotkey "Space", (k) => {}
        
        Hotkey "Space Up", (k) => SpaceIsShift.OnSpaceUp()

        for key in SpaceIsShift.keys
            Hotkey "Space & " key, (k) => SpaceIsShift.OnSpaceAndKey(k)
    }
}

; usage:
; SpaceIsShift.Init()