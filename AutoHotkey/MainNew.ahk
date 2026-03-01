#Requires AutoHotkey v2.0

#Include Utils/FullKeyboardNode.ahk
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
      
        for rowIndex, row in ScanCodes.Matrix {
            for colIndex, scanCode in row {
                this.CreateGateForLayout(this.kbd.ModStdNode, scanCode, this.TypingLayout.Get(scanCode))
                this.CreateGateForLayout(this.kbd.ModShiftNode, scanCode, this.TypingLayout.Get(scanCode, true, false))
                this.CreateGateForLayout(this.kbd.ModCtrlAltNode, scanCode, this.TypingLayout.Get(scanCode, false, true))

                shortCutChar := this.ShortCutLayout.Get(scanCode)
                this.CreateGate(this.kbd.ModCtrlNode, scanCode, shortCutChar)
                this.CreateGate(this.kbd.ModWinNode, scanCode, shortCutChar)
                this.CreateGate(this.kbd.ModAltNode, scanCode, shortCutChar)
                this.CreateGate(this.kbd.ModAltShiftNode, scanCode, shortCutChar)
                this.CreateGate(this.kbd.ModCtrlShiftNode, scanCode, shortCutChar)
                this.CreateGate(this.kbd.ModCtrlAltShiftNode, scanCode, shortCutChar)
            }
        }

        this.kbd.Reset() ; Ensure all keys start in the unpressed state
    }
   
    ComputeMsg(keyStr){
        if not keyStr
            return ""

        deadKeyDict := this.TypingLayout.DeadKeyDict

        if not this.currentDeadKey{
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
        if combinedKey {
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
            if char {
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
    KeyboardLayout("Layouts/azerty.json"), 
    KeyboardLayout("Layouts/qwertz.json")
)