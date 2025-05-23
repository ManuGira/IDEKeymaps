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
        spam3 := SpamCountNode(this.dummy, , 200, 3)
        notSpam3 := InverseNode(spam3, , true)
        AndNode([hold, notSpam3], (s) => this.SendInlineCode(s)) ; hold key -> send inline code
        AndNode([hold, spam3], (s) => this.SendCodeBlock(s)) ; hit-hit-hold key -> send code block
    }

    Update(state) {
        this.dummy.Update(state)
    }

    IsClipboardText() {
        return ClipWait(0.1) && !!StrLen(A_Clipboard)
    }

    LineReturn(){
        SendInput("{ShiftDown}{Enter}{ShiftUp}")
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
            this.Paste()
            this.SimpleChar()
        } else {
            this.SimpleChar()
            SendInput("{Left}")
        }
    }
}

class JILK {
    static shiftModNode := 0
    static ctrlModNode := 0
    static altModNode := 0
    
    static getMods(){
        mods := ""
        if IsObject(JILK.shiftModNode) and JILK.shiftModNode.GetState()
                mods := mods "+"
        else if (GetKeyState("Shift", "P"))
                mods := mods "+"

        if IsObject(JILK.altModNode) and JILK.altModNode.GetState()
                mods := mods "!"
        else if (GetKeyState("Alt", "P"))
                mods := mods "!"
        
        if IsObject(JILK.ctrlModNode) and JILK.ctrlModNode.GetState(){
            mods := mods "^"
        }
        else if GetKeyState("Ctrl", "P") {
            mods := mods "^"
        }

        return mods
    }

    static AllModHotKey(key, keyToSend, condition) {
        Conditional.Hotkey("$" key, (k) => SendInput(JILK.getMods() keyToSend), condition)
        Conditional.Hotkey("$+" key, (k) => SendInput(JILK.getMods() keyToSend), condition)
        Conditional.Hotkey("$!" key, (k) => SendInput(JILK.getMods() keyToSend), condition)
        Conditional.Hotkey("$^" key, (k) => SendInput(JILK.getMods() keyToSend), condition)
        Conditional.Hotkey("$+!" key, (k) => SendInput(JILK.getMods() keyToSend), condition)
        Conditional.Hotkey("$+^" key, (k) => SendInput(JILK.getMods() keyToSend), condition)
        Conditional.Hotkey("$!^" key, (k) => SendInput(JILK.getMods() keyToSend), condition)
    }
    static selectLine := "{End}{End}{ShiftDown}{Home}{Home}{Left}{ShiftUp}"

    /**
     * 
     * @param condition {(Func<bool>)}
     * @param shitModNode {KeyStateNode}
     */
    static Init(conditionNode, shiftModNode?, ctrlModNode?, altModNode?) {
        if IsSet(shiftmodnode)
            JILK.shiftModNode := shiftModNode
        if IsSet(ctrlModNode)
            JILK.ctrlModNode := ctrlModNode
        if IsSet(altModNode)
            JILK.altModNode := altModNode

        condition := (k) => conditionNode.GetState()
        ; Assignation des lettres aux directions
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

        Conditional.Hotkey("$a", (k) => SendInput("{Blind}{Text}!"), condition)
        Conditional.Hotkey("$q", (k) => SendInput("{Blind}{Text}?"), condition)
        
        Conditional.Hotkey("$z", (k) => SendInput("^z"), condition)
        Conditional.Hotkey("$y", (k) => SendInput(JILK.selectLine "{Del}{Right}{End}{End}"), condition) ; Y -> delete line
        Conditional.Hotkey("$x", (k) => SendInput(JILK.selectLine "^x"), condition)                ; X -> cut line
        Conditional.Hotkey("$c", (k) => SendInput(JILK.selectLine "^c" "{Right}"), condition)      ; C -> copy line
        Conditional.Hotkey("$v", (k) => EditTextSelection.SwapClipboardWithSelection(), condition) ; V -> swap clipboard with selection
    }
}