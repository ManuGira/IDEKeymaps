#Requires AutoHotkey v2.0

#Include Utils/FullKeyboardNode.ahk
#Include Utils/Dict.ahk
#Include Layouts/ScanCodes.ahk
#Include Layouts/QWERTZ.ahk

class KeyBoardState {
    __New(Layout) {
        this.Layout := Layout
        this.currentDeadKey := ""

        this.kbd := FullKeyboardNode()
        this.kbd.Reset() ; Ensure all keys start in the unpressed state
      
        for rowIndex, row in ScanCodes.KeyMatrix {
            for colIndex, scanCode in row {
                this.CreateGateForLayout(scanCode, this.kbd.ModStdNode, this.Layout.Get(rowIndex, colIndex))
                this.CreateGateForLayout(scanCode, this.kbd.ModShiftNode, this.Layout.Get(rowIndex, colIndex, true, false))
                this.CreateGateForLayout(scanCode, this.kbd.ModCtrlAltNode, this.Layout.Get(rowIndex, colIndex, false, true))

                qwertzBaseChar := QWERTZ.Get(rowIndex, colIndex)
                this.CreateGate(scanCode, this.kbd.ModCtrlNode, qwertzBaseChar)
                this.CreateGate(scanCode, this.kbd.ModWinNode, qwertzBaseChar)
                this.CreateGate(scanCode, this.kbd.ModAltNode, qwertzBaseChar)
                this.CreateGate(scanCode, this.kbd.ModAltShiftNode, qwertzBaseChar)
                this.CreateGate(scanCode, this.kbd.ModCtrlShiftNode, qwertzBaseChar)
                this.CreateGate(scanCode, this.kbd.ModCtrlAltShiftNode, qwertzBaseChar)
            }
        }

        this.kbd.Reset() ; Ensure all keys start in the unpressed state
    }
   
    ComputeMsg(keyStr){
        deadKeyDict := this.Layout.DeadKeyDict

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
        if deadKeyDict.Has(this.currentDeadKey) && deadKeyDict[this.currentDeadKey].Has(keyStr) {
            ; we have a combination, we send the combined character and clear the current dead key
            specialKey := deadKeyDict[this.currentDeadKey][keyStr]
            if specialKey = " " {
                ; Result is a void " ". Don't send anything yet, wait for the next key
                return "" 
            }
            ; we have a valid combination, send the combined character and clear the current dead key
            this.currentDeadKey := "" ; Clear the current dead key after use
            return specialKey
        }
        ; no combination found, send the deadKey followed by the current keyStr
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

    CreateGateForLayout(scanCode, modNode, keyStr){
        GateNode(this.kbd.charKeyNodes[scanCode], modNode, (state) => this.GateCallback(state, keyStr))
    }

    CreateGate(scanCode, modNode, keyStr){
        GateNode(this.kbd.charKeyNodes[scanCode], modNode, (s) => s ? SendInput("{Blind}" keyStr) : "")
    }
}

KeyBoardState(QWERTZ)