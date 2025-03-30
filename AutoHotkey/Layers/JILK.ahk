#Requires AutoHotkey v2.0
#Include ../Utils/Conditional.ahk




class JILK {
    static AllModHotKey(key, keyToSend, condition) {
        Conditional.Hotkey("$" key, (k) => SendInput(keyToSend), condition)
        Conditional.Hotkey("$+" key, (k) => SendInput("+" keyToSend), condition)
        Conditional.Hotkey("$!" key, (k) => SendInput("!" keyToSend), condition)
        Conditional.Hotkey("$^" key, (k) => SendInput("^" keyToSend), condition)
        Conditional.Hotkey("$+!" key, (k) => SendInput("+!" keyToSend), condition)
        Conditional.Hotkey("$+^" key, (k) => SendInput("+^" keyToSend), condition)
        Conditional.Hotkey("$!^" key, (k) => SendInput("!^" keyToSend), condition)
    }

    ;static selectLine := "{Home}{Home}{ShiftDown}{End}{Right}{ShiftUp}"
    static selectLine := "{End}{End}{ShiftDown}{Home}{Home}{Left}{ShiftUp}"

    static Init(condition) {
        ; Assignation des lettres aux directions444
        JILK.AllModHotKey("j", "{Left}", condition)      ; J -> Left
        JILK.AllModHotKey("i", "{Up}", condition)        ; I -> Up
        JILK.AllModHotKey("l", "{Right}", condition)     ; L -> Right
        JILK.AllModHotKey("k", "{Down}", condition)      ; K -> Down
        JILK.AllModHotKey("u", "{Home}", condition)      ; U -> Home
        JILK.AllModHotKey("o", "{End}", condition)       ; O -> End
        JILK.AllModHotKey("h", "{Backspace}", condition) ; H -> Backspace
        JILK.AllModHotKey("é", "{Delete}", condition)    ; é -> Delete
        JILK.AllModHotKey("n", "{Enter}", condition)     ; N -> Enter
        JILK.AllModHotKey("m", "{Escape}", condition)    ; M -> Escape
        JILK.AllModHotKey("p", "{F12}", condition)    ; M -> Escape
        
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