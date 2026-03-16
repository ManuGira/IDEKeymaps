#Requires AutoHotkey v2.0
#Include Utils.ahk
#Include ../Nodes/include.ahk
#Include ../Layouts/ScanCodes.ahk

class FullKeyboardNode {
    static modKeyLabels := ["LShift", "RShift", "LControl", "RControl", "LAlt", "RAlt", "LWin", "RWin"]
    static lockKeys := ["CapsLock", "ScrollLock", "NumLock"]

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

        this.lockKeyNodes := Map()
        for k in FullKeyboardNode.lockKeys {
            this.lockKeyNodes[k] := KeyLockStateNode(k  , )  
        }

        SendAndTips(msg) {
            SendInput(msg)
            Utils.TempToolTip(msg, 1000)
        }

        this.shiftNode := OrNode([this.modKeyNodes["LShift"], this.modKeyNodes["RShift"]])
        this.altNode := OrNode([this.modKeyNodes["LAlt"], this.modKeyNodes["RAlt"]])
        this.ctrlNode := OrNode([this.modKeyNodes["LControl"], this.modKeyNodes["RControl"], this.modKeyNodes["RAlt"]])
        this.winNode := OrNode([this.modKeyNodes["LWin"], this.modKeyNodes["RWin"]])
        
        this.ModNodes := [
            this.shiftNode,
            this.altNode,
            this.ctrlNode,
            this.winNode,
        ]
    }

    Reset() {
        for key, node in this.modKeyNodes {
            node.Update(false)
        }

        for modNode in this.ModNodes {
            modNode.Update(false)
        }
    }
}
