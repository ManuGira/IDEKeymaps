#Requires AutoHotkey v2.0
#Include Utils.ahk
#Include ../Nodes/include.ahk
#Include ../Layouts/ScanCodes.ahk

class FullKeyboardNode {
    static modKeyLabels := ["LShift", "RShift", "LControl", "RControl", "LAlt", "RAlt", "LWin", "RWin"]


    static CreateTooltipCallback(key) {
        return (s) => Utils.TempToolTip(key " " s, 500)
    }

    __New() {
        charKeyScanCodes := []
        
        ; Add all keys from the matrix
        for row in ScanCodes.Matrix {
            for key in row {
                charKeyScanCodes.Push(key)
            }
        }

        ; Special keys (optional - uncomment if needed)
        ; keys.Push("Tab", "Enter", "Escape", "Backspace", "Space")
        ; keys.Push("Up", "Down", "Left", "Right")
        ; keys.Push("Home", "End", "PgUp", "PgDn")
        ; keys.Push("Insert", "Delete")
        ; keys.Push("PrintScreen", "Pause", "AppsKey")

        ; F1 to F24 (optional)
        ; loop 24
        ;     keys.Push("F" . A_Index)

        ; Numpad (optional)
        ; loop 10
        ;     keys.Push("Numpad" . A_Index - 1)
        ; keys.Push("NumpadDot", "NumpadEnter", "NumpadAdd", "NumpadSub", "NumpadMult", "NumpadDiv")

        ; Register hotkeys

        this.charKeyNodes := Map()
        for k in charKeyScanCodes {
            this.charKeyNodes[k] := ChangeNode(KeyStateNode(k, , false))
        }

       ; Modifier keys
        this.modKeyNodes := Map()
        for k in FullKeyboardNode.modKeyLabels {
            this.modKeyNodes[k] := ChangeNode(KeyStateNode(k, , false))
        }

        lockKeys := ["CapsLock", "ScrollLock", "NumLock"]
        this.lockKeyNodes := Map()
        for k in lockKeys {
            this.lockKeyNodes[k] := KeyLockStateNode(k, )  
        }

        SendAndTips(msg) {
            SendInput(msg)
            Utils.TempToolTip(msg, 1000)
        }

        SendModInput(state, key) {
            if state {
                SendInput("{Blind}{" key " Down}")
            } else {
                SendInput("{Blind}{" key " Up}")
            }
        }

        this.shiftNode := OrNode([this.modKeyNodes["LShift"], this.modKeyNodes["RShift"]], (s) => SendModInput(s, "Shift"))
        this.altNode := OrNode([this.modKeyNodes["LAlt"], this.modKeyNodes["RAlt"]], (s) => SendModInput(s, "Alt"))
        this.ctrlNode := OrNode([this.modKeyNodes["LControl"], this.modKeyNodes["RControl"], this.modKeyNodes["RAlt"]], (s) => SendModInput(s, "Control"))
        this.winNode := OrNode([this.modKeyNodes["LWin"], this.modKeyNodes["RWin"]], (s) => SendModInput(s, "LWin"))
        
        this.ModNodes := [
            this.shiftNode,
            this.altNode,
            this.ctrlNode,
            this.winNode,
        ]
    }

    UpdateAllModKeyNodes() {
        for k in FullKeyboardNode.modKeyLabels {
            state := GetKeyState(k, "P")
            this.modKeyNodes[k].Update(state)
        }
    }

    Reset() {
        for key, node in this.modKeyNodes {
            node.Update(false)
        }

        this.UpdateAllModKeyNodes()

        for modNode in this.ModNodes {
            modNode.Update(false)
        }
    }
}
