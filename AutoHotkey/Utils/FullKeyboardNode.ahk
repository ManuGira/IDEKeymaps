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

        UpdateAllModKeyNodes() {
            for k in modKeys {
                state := GetKeyState(k, "P")
                this.modKeyNodes[k].Update(state)
            }
        }
        
        for k in modKeys {
            ; We use two chained ChangeNodes per modifier key instead of one, to work around a Windows lockscreen bug:
            ;
            ; Problem: When locking the PC with Win+L, AHK is suspended while the screen is locked, so it never
            ; sees the LWin/RWin key-release event. When the user unlocks the PC, our stored Win key state is stuck
            ; as "pressed", corrupting all modifier state logic until Win is physically pressed and released again.
            ;
            ; Solution: The first ChangeNode wraps a KeyStateNode and fires a callback whenever ANY modifier key
            ; changes state. That callback (UpdateAllModKeyNodes) re-reads the physical state of ALL modifier keys
            ; directly from Windows via GetKeyState(..., "P"), then pushes those values into the second ChangeNodes.
            ; The second ChangeNode is what callers subscribe to; it only holds the Windows-authoritative state,
            ; not the raw AHK hotkey stream. This way, re-synchronisation happens automatically on the next
            ; modifier keystroke after an unlock, regardless of which key events AHK may have missed.
            ChangeNode(KeyStateNode(k, , false), (s) => UpdateAllModKeyNodes(), )
            this.modKeyNodes[k] := ChangeNode()  ; Updated by UpdateAllModKeyNodes on every modifier event
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
        this.winNode := OrNode([this.modKeyNodes["LWin"], this.modKeyNodes["RWin"]], (s) => SendModInput(s, "LWin"))
        
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
