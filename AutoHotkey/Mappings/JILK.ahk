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
    ;static selectLine := "{Home}{Home}{ShiftDown}{End}{Right}{ShiftUp}"
    static selectLine := "{End}{End}{ShiftDown}{Home}{Home}{Left}{ShiftUp}"

    static Init(condition) {
        ; Assignation des lettres aux directions
        Conditional.Remap("j", "{Left}", condition)      ; J -> Left
        Conditional.Remap("i", "{Up}", condition)        ; I -> Up
        Conditional.Remap("l", "{Right}", condition)     ; L -> Right
        Conditional.Remap("k", "{Down}", condition)      ; K -> Down
        Conditional.Remap("u", "{Home}", condition)      ; U -> Home
        Conditional.Remap("o", "{End}", condition)       ; O -> End
        Conditional.Remap("h", "{Backspace}", condition) ; H -> Backspace
        Conditional.Remap("é", "{Delete}", condition)    ; é -> Delete
        Conditional.Remap("n", "{Enter}", condition)     ; N -> Enter
        Conditional.Remap("m", "{Escape}", condition)    ; M -> Escape
        Conditional.Remap("p", "{F12}", condition)    ; M -> Escape
        
        Conditional.Hotkey("$,", (k) => SendInput("{Blind}!{Left}"), condition)
        Conditional.Hotkey("$.", (k) => SendInput("{Blind}!{Right}"), condition)

        Conditional.Hotkey("$d", (k) => SendInput("{Blind}{Text}("), condition)
        Conditional.Hotkey("$f", (k) => SendInput("{Blind}{Text})"), condition)
        Conditional.Hotkey("$+e", (k) => SendInput("{Blind}{Text}<"), condition)
        Conditional.Hotkey("$+r", (k) => SendInput("{Blind}{Text}>"), condition)
        Conditional.Hotkey("$e", (k) => SendInput("{Blind}{Text}{"), condition)
        Conditional.Hotkey("$r", (k) => SendInput("{Blind}{Text}}"), condition)
        Conditional.Hotkey("$+d", (k) => SendInput("{Blind}{Text}["), condition)
        Conditional.Hotkey("$+f", (k) => SendInput("{Blind}{Text}]"), condition)
        
        Conditional.Hotkey("$q", (k) => SendInput("{Blind}{Text}:"), condition)
        Conditional.Hotkey("$s", (k) => SendInput("{Blind}{Text}+"), condition)
        Conditional.Hotkey("$w", (k) => SendInput("{Blind}{Text}="), condition)
        Conditional.Hotkey("$+w", (k) => SendInput("{Blind}{Text}-"), condition)
        
        Conditional.Hotkey("$a", (k) => SendInput("{Blind}{Text}!"), condition)
        Conditional.Hotkey("$+a", (k) => SendInput("{Blind}{Text}?"), condition)
        
        Conditional.Hotkey("$z", (k) => SendInput("^z"), condition)
        Conditional.Hotkey("$y", (k) => SendInput(JILK.selectLine "{Del}{Right}{End}{End}"), condition)          ; Y -> delete line
        Conditional.Hotkey("$x", (k) => SendInput(JILK.selectLine "^x"), condition)             ; X -> cut line
        Conditional.Hotkey("$c", (k) => SendInput(JILK.selectLine "^c" "{Right}"), condition)   ; C -> copy line
        Conditional.Hotkey("$v", (k) => SendInput("^v"), condition)                             ; V -> paste

        Conditional.Hotkey("$+v", (k) => SendInput("{CtrlDown}c{ShiftDown}v{ShiftUp}{CtrlUp}2"), condition)  ; swap clipboard in visual studio
    }
}