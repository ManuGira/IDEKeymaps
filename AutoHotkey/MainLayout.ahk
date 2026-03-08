#Requires AutoHotkey v2.0

#Include Utils/FullKeyboardNode.ahk
#Include Utils/ModifierNodes.ahk
#Include Utils/Dict.ahk
#Include Layouts/ScanCodes.ahk
#Include Layouts/KeyboardLayout.ahk

class KeyBoardState {
    __New(TypingLayout, ShortCutLayout) {
        this.TypingLayout := TypingLayout
        this.ShortCutLayout := ShortCutLayout
        this.currentDeadKey := ""

        this.kbd := FullKeyboardNode()
        this.kbd.Reset() ; Ensure all keys start in the unpressed state
      
        this.modNodes := ModifierNodes(this.kbd.ctrlNode, this.kbd.altNode, this.kbd.shiftNode, this.kbd.winNode)
        ; this.modNodes.EnableShowStateOnChange()

        modStdNode := OrNode([
            AndNode([this.modNodes.std, NotNode(this.kbd.lockKeyNodes["CapsLock"])]),
            AndNode([this.modNodes.shift, this.kbd.lockKeyNodes["CapsLock"]])
        ])
        modShiftNode := OrNode([
            AndNode([this.modNodes.std, this.kbd.lockKeyNodes["CapsLock"]]),
            AndNode([this.modNodes.shift, NotNode(this.kbd.lockKeyNodes["CapsLock"])])
        ])

        for rowIndex, row in ScanCodes.Matrix {
            for colIndex, scanCode in row {
                this.CreateGateForLayout(modStdNode, scanCode, this.TypingLayout.Get(scanCode))
                this.CreateGateForLayout(modShiftNode, scanCode, this.TypingLayout.Get(scanCode, true, false))
                this.CreateGateForLayout(this.modNodes.ctrl_alt, scanCode, this.TypingLayout.Get(scanCode, false, true))
                this.CreateGateForLayout(this.modNodes.ctrl_alt_shift, scanCode, this.TypingLayout.Get(scanCode, true, true))

                shortCutChar := this.ShortCutLayout.Get(scanCode)
                this.CreateGate(this.modNodes.ctrl, scanCode, shortCutChar)
                this.CreateGate(this.modNodes.win, scanCode, shortCutChar)
                this.CreateGate(this.modNodes.alt, scanCode, shortCutChar)
                this.CreateGate(this.modNodes.alt_shift, scanCode, shortCutChar)
                this.CreateGate(this.modNodes.ctrl_shift, scanCode, shortCutChar)
            }
        }

        this.kbd.Reset() ; Ensure all keys start in the unpressed state
        this.modNodes.Reset() ; Ensure all modifier nodes start in the unpressed state
        
        ; Reset all key states when the Windows session is unlocked, to avoid stuck keys caused by AHK being suspended while the screen was locked.
        WinSessionStateNode((s) => this.kbd.Reset()) 
    }
   
    ComputeMsg(keyStr){
        if StrLen(keyStr) == 0
            return ""

        deadKeyDict := this.TypingLayout.DeadKeyDict

        if StrLen(this.currentDeadKey) == 0 {
            ; no current deadKey

            if deadKeyDict.Has(keyStr){
                ; the keyStr is a deadKey. We dont send it yet, and store it for next key
                this.currentDeadKey := keyStr
                return "" ; Don't send anything yet, wait for the next key
            }

            ; the keyStr is a normal key, send it directly
            return keyStr
        }
        
        ; we have a deadKey stored, we need to check if the current keyStr can be combined with it
        combinedKey := deadKeyDict[this.currentDeadKey][keyStr]
        if StrLen(combinedKey) > 0 {
            ; we have a valid combination, send the combined character and clear the current dead key
            this.currentDeadKey := "" ; Clear the current dead key after use
            return combinedKey
        }
        ; no combination found, send the deadKey followed by the current keyStr. 
        ; remove leading * from deadKey if present, as it is used to indicate that the dead key should be sent if no combination is found
        if StrLen(this.currentDeadKey) > 1 && SubStr(this.currentDeadKey, 1, 1) = "*" {
            this.currentDeadKey := SubStr(this.currentDeadKey, 2)
        }
        
        result := this.currentDeadKey . keyStr
        this.currentDeadKey := "" ; Clear the current dead key after use
        return result
    }

    GateCallback(state, keyStr){
        if state {
            char := this.ComputeMsg(keyStr)
            if StrLen(char) > 0 {
                SendInput("{Blind}{Text}" char)
            }
        }
    }

    CreateGateForLayout(modNode, scanCode, keyStr){
        GateNode(modNode, this.kbd.charKeyNodes[scanCode], (state) => this.GateCallback(state, keyStr))
    }

    CreateGate(modNode, scanCode, keyStr){
        GateNode(modNode, this.kbd.charKeyNodes[scanCode], (s) => s ? SendInput("{Blind}" keyStr) : "")
    }
}

KeyBoardState(
    KeyboardLayout("Layouts/bepo.json"), 
    KeyboardLayout("Layouts/qwertz.json")
)