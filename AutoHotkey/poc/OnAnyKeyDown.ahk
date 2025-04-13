#Requires AutoHotkey v2.0
class OnAnyKeyDown {
    static Init() {
        keys := []
        
        ; Lettres A-Z
        loop 26*2
            keys.Push(Chr(Ord("A") + A_Index - 1))

        ; Chiffres 0-9
        loop 10
            keys.Push(A_Index - 1)

        ; Swiss keys
        keys.Push("<", "§", "'", "^", "è", "$", "à", "é", "-", ".", ",", "¨", ";")

        ; Touches spéciales
        keys.Push("Tab", "Enter", "Escape", "Backspace", "Space")
        keys.Push("Up", "Down", "Left", "Right")
        keys.Push("Home", "End", "PgUp", "PgDn")
        keys.Push("Insert", "Delete")
        keys.Push("CapsLock", "ScrollLock", "NumLock")
        keys.Push("PrintScreen", "Pause", "AppsKey")

        ; F1 à F24
        loop 24
            keys.Push("F" . A_Index)

        ; Pave numérique
        loop 10
            keys.Push("Numpad" . A_Index - 1)
        keys.Push("NumpadDot", "NumpadEnter", "NumpadAdd", "NumpadSub", "NumpadMult", "NumpadDiv")

        ; Symboles usuels
        ; keys.Push(";", "=", ",", "-", ".", "/", "`", "[", "]", "\", "'", "~")

        ; Déclare les hotkeys à blanc
        for k in keys {
            try Hotkey("~*$" . k, (*) => "", "On")
        }
    }
}