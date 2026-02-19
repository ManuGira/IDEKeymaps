#Requires AutoHotkey v2.0
#Include ../Utils/Conditional.ahk

#Include ../Utils/EditTextSelection.ahk
#Include ../Utils/PathConverter.ahk
#Include ../Utils/CaseConverter.ahk
#Include ../Nodes/include.ahk

class CodeBlockUtils {
    __New(character) {
        this.character := character
        
        this.dummy := DummyNode( , (s) => (s) ? this.SimpleChar() : "", false)
        hold := HoldNode(this.dummy, , 400)
        spam2 := SpamCountNode(this.dummy, , 200, 2)
        spam3 := SpamCountNode(this.dummy, , 200, 3)
        notSpam3 := InverseNode(spam3, , true)
        AndNode([hold, notSpam3, spam2], (s) => this.SendInlineCode(s)) ; hit-hold key -> send inline code
        AndNode([hold, spam3], (s) => this.SendCodeBlock(s)) ; hit-hit-hold key -> send code block
    }

    Update(state) {
        this.dummy.Update(state)
    }

    IsClipboardText() {
        return ClipWait(0.1) && !!StrLen(A_Clipboard)
    }

    LineReturn(){
        SendInput("{ShiftDown}{Enter}{ShiftUp}{Home}")
    }

    SimpleChar(){
        SendInput("{Blind}{Text}" this.character)
    }

    TripleChar(){
        SendInput("{Blind}{Text}" this.character this.character this.character)
    }

    Paste(){
        SendInput("^v")
        Sleep(100) ; Attendre un peu pour s'assurer que le collage est terminé
    }

    SendCodeBlock(s) {
        if (!s)
            return
        
        SendInput("{Backspace}{Backspace}{Backspace}")
        this.LineReturn()
        this.TripleChar()
        this.LineReturn()
        if this.IsClipboardText(){
            this.Paste()
            this.LineReturn()
            this.TripleChar()
            this.LineReturn()
        } else {
            this.LineReturn()
            this.TripleChar()
            SendInput("{Up}")
        }
    }

    SendInlineCode(s) {
        if (!s)
            return

        if this.IsClipboardText(){
            SendInput("{Left}")
            this.Paste()
            SendInput("{Right}")
        } else {
            this.SimpleChar()
            SendInput("{Left}")
        }
    }
}

class JILK {
    static getMods(shiftModNode){
        mods := ""
        if (GetKeyState("Ctrl", "P"))
            mods := mods "^"

        if (GetKeyState("Alt", "P"))
            mods := mods "!"


        if (GetKeyState("Shift", "P"))
            mods := mods "+"

        ; if (GetKeyState("LWin", "P") || GetKeyState("RWin", "P"))
        ;     mods := mods "#"

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

    static AddCtrlMod(key, condition){
        Conditional.Hotkey("$" key, (k) => SendInput("^" key), condition)
        Conditional.Hotkey("$+" key, (k) => SendInput("^+" key), condition)
        Conditional.Hotkey("$!" key, (k) => SendInput("^!" key), condition)
        Conditional.Hotkey("$+!" key, (k) => SendInput("^+!" key), condition)
        Conditional.Hotkey("$+^" key, (k) => SendInput("^+^" key), condition)
        Conditional.Hotkey("$!^" key, (k) => SendInput("^^!" key), condition)
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

        
        backTickBlock := CodeBlockUtils("``")  ; back tick is the escape character. It escaped itself
        Conditional.Hotkey("$g", (k) => backTickBlock.Update(1), condition)
        Conditional.Hotkey("$g Up", (k) => backTickBlock.Update(0), condition) 

        doubleQuoteBlock := CodeBlockUtils('"')
        Conditional.Hotkey("$t", (k) => doubleQuoteBlock.Update(1), condition)
        Conditional.Hotkey("$t Up", (k) => doubleQuoteBlock.Update(0), condition)

        quoteBlock := CodeBlockUtils("'")
        Conditional.Hotkey("$b", (k) => quoteBlock.Update(1), condition)
        Conditional.Hotkey("$b Up", (k) => quoteBlock.Update(0), condition)
                

        Conditional.HotKey("$s", (key) => EditTextSelection.Apply(PathConverter.SwapPathTypeFunc), condition)
        Conditional.HotKey("$w", (key) => EditTextSelection.Apply(CaseConverter.SwapAllCaseFunc), condition)
        Conditional.HotKey("$p", (k) => AppShortcuts.SendShortcutByApp(AppShortcuts.CommentMap), condition)
        Conditional.HotKey("$^p", (k) => AppShortcuts.SendShortcutByApp(AppShortcuts.UncommentMap), condition)

        Conditional.Hotkey("$a", (k) => SendInput("{Blind}{Text}!"), condition)
        Conditional.Hotkey("$q", (k) => SendInput("{Blind}{Text}?"), condition)
        
        Conditional.Hotkey("$z", (k) => SendInput("^z"), condition)
        Conditional.Hotkey("$y", (k) => SendInput(JILK.selectLine "{Del}{Right}{End}{End}"), condition) ; Y -> delete line
        Conditional.Hotkey("$x", (k) => SendInput(JILK.selectLine "^x"), condition)                ; X -> cut line
        Conditional.Hotkey("$c", (k) => SendInput(JILK.selectLine "^c" "{Right}"), condition)      ; C -> copy line
        Conditional.Hotkey("$v", (k) => EditTextSelection.SwapClipboardWithSelection(), condition) ; V -> swap clipboard with selection
        
        
        ; iterate over numbers 1 to 4 to create hotkeys for ctrl+number and ctrl+shift+number
        Loop Parse, 1234567890 {
            num := A_LoopField
            JILK.AddCtrlMod(num, condition)
        }
    }
}