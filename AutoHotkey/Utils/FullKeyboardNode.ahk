#Requires AutoHotkey v2.0
#Include Utils.ahk
#Include ../Nodes/include.ahk
#Include ../Layouts/ScanCodes.ahk

class FullKeyboardNode {
    static modKeyLabels := ["LShift", "RShift", "LControl", "RControl", "LAlt", "RAlt", "LWin", "RWin"]


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
        
        this.modKeyNodes := Map()
        for k in FullKeyboardNode.modKeyLabels {
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
            ChangeNode(KeyStateNode(k, , false), (s) => this.UpdateAllModKeyNodes(), )
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
        for key, node in this.charKeyNodes {
            node.Update(false)
        }

        this.UpdateAllModKeyNodes()

        for modNode in this.ModNodes {
            modNode.Update(false)
        }
    }
}
