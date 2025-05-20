#Requires AutoHotkey v2.0
#Include ../Utils/Conditional.ahk

#Include ../Utils/EditTextSelection.ahk
#Include ../Utils/PathConverter.ahk
#Include ../Utils/CaseConverter.ahk
#Include ../Nodes/include.ahk

class CodeBlockUtils {
    static IsClipboardText() {
        return ClipWait(0.1) && !!StrLen(A_Clipboard)
    }

    static LineReturn(){
        SendInput("{ShiftDown}{Enter}{ShiftUp}")
    }
    static SimpleBackTick(){
        SendInput("{Blind}{Text}``")
    }
    static TripleBackTick(){
        SendInput("{Blind}{Text}``````")
    }

    static Paste(){
        SendInput("^v")
        Sleep(100) ; Attendre un peu pour s'assurer que le collage est terminé
    }
    static SendCodeBlock(s) {
        if (!s)
            return
        
        SendInput("{Backspace}{Backspace}{Backspace}")
        this.LineReturn()
        this.TripleBackTick()
        this.LineReturn()
        if this.IsClipboardText(){
            this.Paste()
            this.LineReturn()
            this.TripleBackTick()
            this.LineReturn()
        } else {
            this.LineReturn()
            this.TripleBackTick()
            SendInput("{Up}")
        }
    }

    static SendInlineCode(s) {
        if (!s)
            return

        if CodeBlockUtils.IsClipboardText(){
            this.Paste()
            this.SimpleBackTick()
        } else {
            this.SimpleBackTick()
            SendInput("{Left}")
        }
    }
}

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

        BackTickCB(s) {
            if (s){
                CodeBlockUtils.SimpleBackTick()
            }
        }
        
        dummy := DummyNode( , BackTickCB, false)
        hold := HoldNode(dummy, , 400)
        spam3 := SpamCountNode(dummy, , 200, 3)
        notSpam3 := InverseNode(spam3, , true)
        AndNode([hold, notSpam3], (s) => CodeBlockUtils.SendInlineCode(s))
        AndNode([hold, spam3], (s) => CodeBlockUtils.SendCodeBlock(s))
        ;(s) => CodeBlockUtils.SendCodeBlock(s)

        
        Conditional.Hotkey("$g", (k) => dummy.Update(1), condition)  ; back tick is the escape character. It escaped itself       
        Conditional.Hotkey("$g Up", (k) => dummy.Update(0), condition)  ; back tick is the escape character. It escaped itself       

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