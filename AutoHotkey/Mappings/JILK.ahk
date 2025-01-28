#Requires AutoHotkey v2.0
#Include ../Utils/Conditional.ahk


; Fonction pour assigner une lettre à une direction
;AssignDirection(key, direction) {
;    Hotkey "!" key, (k) => Send("{" direction "}")
;    Hotkey "+!" key, (k) => Send("+{" direction "}")
;    Hotkey "^!" key, (k) => Send("^{" direction "}")
;    Hotkey "^+!" key, (k) => Send("^+{" direction "}") 
;    Hotkey "<^>!" key, (k) => Send("!{" direction "}")
;

class JILK {
    static Init(condition) {
        ; Assignation des lettres aux directions
        Conditional.Remap("j", "{Left}", condition)      ; J -> Left
        Conditional.Remap("i", "{Up}", condition)        ; I -> Up
        Conditional.Remap("l", "{Right}", condition)     ; L -> Right
        Conditional.Remap("k", "{Down}", condition)      ; K -> Down
        Conditional.Remap("u", "{Home}", condition)      ; U -> Home
        Conditional.Remap("o", "{End}", condition)       ; O -> End
        Conditional.Remap("h", "{Backspace}", condition) ; H -> Backspace
        Conditional.Remap("n", "{Enter}", condition)     ; N -> Enter
        Conditional.Remap("e", "{Escape}", condition)    ; E -> Escape
    }
}