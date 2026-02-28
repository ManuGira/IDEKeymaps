#Requires AutoHotkey v2.0
#Include Utils.ahk
#Include ../Nodes/include.ahk
#Include ../Layouts/ScanCodes.ahk

class FullKeyboardNode {
    
    static CreateTooltipCallback(key) {
        return (s) => TempToolTip(key " " s, 500)
    }

    __New() {
        charKeyScanCodes := []
        
        ; Add all keys from the matrix
        for row in ScanCodes.KeyMatrix {
            for key in row {
                charKeyScanCodes.Push(key)
            }
        }

        ; Special keys (optional - uncomment if needed)
        ; keys.Push("Tab", "Enter", "Escape", "Backspace", "Space")
        ; keys.Push("Up", "Down", "Left", "Right")
        ; keys.Push("Home", "End", "PgUp", "PgDn")
        ; keys.Push("Insert", "Delete")
        ; keys.Push("CapsLock", "ScrollLock", "NumLock")
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
            ; this.charKeyNodes[k].Subscribe(FullKeyboardNode.CreateTooltipCallback(k))
        }

                ; Modifier keys
        modKeys := ["LShift", "RShift", "LControl", "RControl", "LAlt", "RAlt", "LWin", "RWin"]

        
        this.modKeyNodes := Map()
        for k in modKeys {
            this.modKeyNodes[k] := ChangeNode(KeyStateNode(k,, false),,)  
        }

        lockKeys := ["CapsLock", "ScrollLock", "NumLock"]
        this.lockKeyNodes := Map()
        for k in lockKeys {
            this.lockKeyNodes[k] := KeyLockStateNode(k, )  
        }

        SendAndTips(msg) {
            SendInput(msg)
            TempToolTip(msg, 1000)
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
        this.winNode := OrNode([this.modKeyNodes["LWin"], this.modKeyNodes["RWin"]], (s) => SendModInput(s, "Win"))
        
        this.shiftXCapsNode := XOrNode([this.shiftNode, this.lockKeyNodes["CapsLock"]])

        this.ModStdNode := PassNode(NotNode(OrNode([this.shiftXCapsNode, this.altNode, this.ctrlNode, this.winNode])))
        this.ModShiftNode := AndNode([this.shiftXCapsNode, NotNode(OrNode([this.altNode, this.ctrlNode, this.winNode]))])
        this.ModCtrlNode := AndNode([this.ctrlNode, NotNode(OrNode([this.shiftNode, this.altNode, this.winNode]))])
        this.ModWinNode := AndNode([this.winNode, NotNode(OrNode([this.shiftNode, this.altNode, this.ctrlNode]))])
        this.ModAltNode := AndNode([this.altNode, NotNode(OrNode([this.shiftNode, this.ctrlNode, this.winNode]))])

        this.ModCtrlAltNode := AndNode([this.ctrlNode, this.altNode, NotNode(OrNode([this.shiftNode, this.winNode]))])
        this.ModAltShiftNode := AndNode([this.altNode, this.shiftNode, NotNode(OrNode([this.ctrlNode, this.winNode]))])
        this.ModCtrlShiftNode := AndNode([this.ctrlNode, this.shiftNode, NotNode(OrNode([this.altNode, this.winNode]))])

        this.ModCtrlAltShiftNode := AndNode([this.ctrlNode, this.altNode, this.shiftNode, NotNode(this.winNode)])

        ; ShowState(){
        ;     stateStr := "Modifiers: " . "`n"
        ;     stateStr .= "  ModStdNode:  " . this.ModStdNode.GetState() . "`n"
        ;     stateStr .= "  ModShiftNode:  " . this.ModShiftNode.GetState() . "`n"
        ;     stateStr .= "  ModCtrlNode:  " . this.ModCtrlNode.GetState() . "`n"
        ;     stateStr .= "  ModWinNode:  " . this.ModWinNode.GetState() . "`n"
        ;     stateStr .= "  ModAltNode:  " . this.ModAltNode.GetState() . "`n"
        ;     stateStr .= "  ModCtrlAltNode:  " . this.ModCtrlAltNode.GetState() . "`n"
        ;     stateStr .= "  ModAltShiftNode:  " . this.ModAltShiftNode.GetState() . "`n"
        ;     stateStr .= "  ModCtrlShiftNode:  " . this.ModCtrlShiftNode.GetState() . "`n"
        ;     stateStr .= "  ModCtrlAltShiftNode:  " . this.ModCtrlAltShiftNode.GetState() . "`n"
        ;     TempToolTip(stateStr, 2000)
        ; }

        this.ModNodes := [
            this.shiftNode,
            this.altNode,
            this.ctrlNode,
            this.winNode,
            this.ModStdNode, 
            this.ModShiftNode, 
            this.ModCtrlNode, 
            this.ModWinNode, 
            this.ModAltNode,
            this.ModCtrlAltNode,
            this.ModAltShiftNode,
            this.ModCtrlShiftNode,
            this.ModCtrlAltShiftNode
        ]

        ; for modNode in this.ModNodes {
        ;     modNode.Subscribe((s) => ShowState())
        ; }
    }

    GetModNode(ctrl, alt, shift, win) {
        if (shift && alt && ctrl) {
            return this.ModCtrlAltShiftNode
        } else if (shift && alt) {
            return this.ModAltShiftNode
        } else if (shift && ctrl) {
            return this.ModCtrlShiftNode
        } else if (alt && ctrl) {
            return this.ModCtrlAltNode
        } else if (shift) {
            return this.ModShiftNode
        } else if (alt) {
            return this.ModAltNode
        } else if (ctrl) {
            return this.ModCtrlNode
        } else if (win) {
            return this.ModWinNode
        } else {
            return this.ModStdNode
        }
    }

    Reset() {
        for key, node in this.charKeyNodes {
            node.Update(false)
        }

        for key, node in this.modKeyNodes {
            node.Update(false)
        }

        for modNode in this.ModNodes {
            modNode.Update(false)
        }

        this.ModStdNode.Update(true)
    }
}
