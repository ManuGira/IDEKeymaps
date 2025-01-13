
; List of keys to bind
keyList := [
    "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
    "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
    "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
    "F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10", "F11", "F12",
    "Space", "Tab", "Enter", "Escape", "Backspace", "Delete", "Insert",
    "Home", "End", "PgUp", "PgDn", "Up", "Down", "Left", "Right",
    "Shift", "Ctrl", "Alt", "CapsLock", "ScrollLock", "NumLock",
    "PrintScreen", "Pause", "AppsKey", "LWin", "RWin"
]

swissKeys := [
    "<", "§", "'", "^", "è", "$", "à", "é", "-", ".", ",", "¨"
]
keyList.Push(swissKeys*)

; Include numpad keys
numpadKeys := [
    "Numpad0", "Numpad1", "Numpad2", "Numpad3", "Numpad4",
    "Numpad5", "Numpad6", "Numpad7", "Numpad8", "Numpad9",
    "NumpadDot", "NumpadDiv", "NumpadMult", "NumpadAdd", "NumpadSub"
    
    ; "NumpadDel", 
    ; "NumpadEnter", 
    ; "NumpadIns", 
    ; "NumpadEnd", 
    ; "NumpadDown", 
    ; "NumpadPgDn",
    ; "NumpadLeft", 
    ; "NumpadClear", 
    ; "NumpadRight", 
    ; "NumpadHome", 
    ; "NumpadUp", 
    ; "NumpadPgUp"
]

; Combine all keys into a single list
keyList.Push(numpadKeys*)


; Function to handle keypresses
Callback(key) {
    ToolTip("Key pressed UF: " key, , , 1) ; Show the key pressed
    Sleep(500) ; Keep the tooltip visible for a short time
    ToolTip("") ; Clear the tooltip
}

OnKeyPressSubscribe(user_function) {
    ; Loop through the keys and create hotkeys
    for key in keyList {
        Hotkey "~*" key, user_function
    }
}
