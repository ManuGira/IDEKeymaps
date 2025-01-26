#Requires AutoHotkey v2.0



; Fonction pour assigner une lettre à une direction
AssignDirection(key, direction) {
    Hotkey "!" key, (k) => Send("{" direction "}")
    Hotkey "+!" key, (k) => Send("+{" direction "}")
    Hotkey "^!" key, (k) => Send("^{" direction "}")
    Hotkey "^+!" key, (k) => Send("^+{" direction "}") 
    Hotkey "<^>!" key, (k) => Send("!{" direction "}")
}

; Assignation des lettres aux directions
AssignDirection("j", "Left")   ; Alt+J -> Left
AssignDirection("k", "Down")   ; Alt+K -> Down
AssignDirection("i", "Up")     ; Alt+I -> Up
AssignDirection("l", "Right")  ; Alt+L -> Right
AssignDirection("u", "Home")   ; Alt+U -> Home
AssignDirection("o", "End")    ; Alt+O -> End

