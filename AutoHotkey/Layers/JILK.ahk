#Requires AutoHotkey v2.0
#Include ../Utils/Conditional.ahk

#Include ../Utils/EditTextSelection.ahk
#Include ../Utils/PathConverter.ahk
#Include ../Utils/CaseConverter.ahk

class JILK {
    static getMods(shiftModNode){
        mods := ""
        if (shiftModNode.GetState())
            mods := mods "+"

        if (GetKeyState("Alt", "P"))
            mods := mods "!"

        if (GetKeyState("Shift", "P")) ; maps shift key to ctrl
            mods := mods "^"

        ToolTip(mods)
        return mods
    }

    static AllModHotKey(key, keyToSend, condition, shiftModNode) {
        Conditional.Hotkey("$" key, (k) => SendInput(JILK.getMods(shiftModNode) keyToSend), condition)
        Conditional.Hotkey("$+" key, (k) => SendInput(JILK.getMods(shiftModNode) keyToSend), condition)
        Conditional.Hotkey("$!" key, (k) => SendInput(JILK.getMods(shiftModNode) keyToSend), condition)
        Conditional.Hotkey("$^" key, (k) => SendInput(JILK.getMods(shiftModNode) keyToSend), condition)
        Conditional.Hotkey("$+!" key, (k) => SendInput(JILK.getMods(shiftModNode) keyToSend), condition)
        Conditional.Hotkey("$+^" key, (k) => SendInput(JILK.getMods(shiftModNode) keyToSend), condition)
        Conditional.Hotkey("$!^" key, (k) => SendInput(JILK.getMods(shiftModNode) keyToSend), condition)
    }
    static selectLine := "{End}{End}{ShiftDown}{Home}{Home}{Left}{ShiftUp}"

    /**
     * 
     * @param condition {(Func<bool>)}
     * @param shitModNode {KeyStateNode}
     */
    static Init(condition, shiftmodnode) {
        ; Assignation des lettres aux directions
        JILK.AllModHotKey("j", "{Left}", condition, shiftModNode)      ; J -> Left
        JILK.AllModHotKey("i", "{Up}", condition, shiftModNode)        ; I -> Up
        JILK.AllModHotKey("l", "{Right}", condition, shiftModNode)     ; L -> Right
        JILK.AllModHotKey("k", "{Down}", condition, shiftModNode)      ; K -> Down
        JILK.AllModHotKey("u", "{Home}", condition, shiftModNode)      ; U -> Home
        JILK.AllModHotKey("o", "{End}", condition, shiftModNode)       ; O -> End
        JILK.AllModHotKey("h", "{Backspace}", condition, shiftModNode) ; H -> Backspace
        JILK.AllModHotKey("é", "{Delete}", condition, shiftModNode)    ; é -> Delete
        JILK.AllModHotKey("n", "{Enter}", condition, shiftModNode)     ; N -> Enter
        JILK.AllModHotKey("m", "{Escape}", condition, shiftModNode)    ; M -> Escape        
        
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

        Conditional.Hotkey("$g", (k) => SendInput("{Blind}{Text}``"), condition)  ; back tick is the escape character. It escaped itself
        Conditional.Hotkey("$+g", (k) => SendInput("{Blind}{Text}`""), condition)  ; back tick is the escape character. It escaped itself
        Conditional.Hotkey("$t", (k) => SendInput("{Blind}{Text}`""), condition)  ; back tick is the escape character. It escapes the double quotes
        Conditional.Hotkey("$b", (k) => SendInput("{Blind}{Text}'"), condition)
                
        Conditional.HotKey("$s", (key) => EditTextSelection.Apply(PathConverter.SwapPathTypeFunc), condition)
        Conditional.HotKey("$w", (key) => EditTextSelection.Apply(CaseConverter.SwapAllCaseFunc), condition)

        Conditional.Hotkey("$a", (k) => SendInput("{Blind}{Text}!"), condition)
        Conditional.Hotkey("$q", (k) => SendInput("{Blind}{Text}?"), condition)
        
        Conditional.Hotkey("$z", (k) => SendInput("^z"), condition)
        Conditional.Hotkey("$y", (k) => SendInput(JILK.selectLine "{Del}{Right}{End}{End}"), condition) ; Y -> delete line
        Conditional.Hotkey("$x", (k) => SendInput(JILK.selectLine "^x"), condition)                ; X -> cut line
        Conditional.Hotkey("$c", (k) => SendInput(JILK.selectLine "^c" "{Right}"), condition)      ; C -> copy line
        Conditional.Hotkey("$v", (k) => EditTextSelection.SwapClipboardWithSelection(), condition) ; V -> swap clipboard with selection
    }
}