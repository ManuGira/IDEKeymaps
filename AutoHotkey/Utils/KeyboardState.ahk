#Requires AutoHotkey v2.0

#Include FullKeyboardNode.ahk
#Include ModifierNodes.ahk
#Include Dict.ahk
#Include ../Layouts/ScanCodes.ahk
#Include ../Layouts/KeyboardLayout.ahk

/**
 * Wires together a FullKeyboardNode, a ModifierNodes, and two KeyboardLayouts to produce
 * the full typing behaviour of a keyboard layer.
 *
 * For every physical key, it creates GateNodes that fire SendInput when the correct
 * modifier combination is active, handling:
 *   - Normal characters (std / shift, with CapsLock inversion)
 *   - AltGr characters (ctrl+alt / ctrl+alt+shift)
 *   - Shortcut keys (ctrl, alt, win, alt+shift, ctrl+shift) passed through as raw key names
 *   - Dead-key composition (see ComputeMsg)
 */
class KeyboardState {

    /**
     * @param enableNode {Node} if this node is false, the KeyboardState will not send any input (but will still track state and update nodes)
     * @param keyboardNodes {FullKeyboardNode} node graph for every physical key and lock key
     * @param modNodes {ModifierNodes} pre-built modifier-combination nodes
     * @param capsLockNode {Node} node of which state tells if CapsLock is enabled or not
     * @param typingLayout {KeyboardLayout} layout used for character output (e.g. bépo)
     * @param shortCutLayout {KeyboardLayout} layout used to resolve shortcut key names (e.g. qwertz)
     */
    __New(enableNode, keyboardNodes, modNodes, capsLockNode, typingLayout, shortCutLayout) {
        this.enableNode := enableNode
        this.kbd := keyboardNodes
        this.modNodes := modNodes
        this.typingLayout := typingLayout
        this.shortCutLayout := shortCutLayout
        this.capsLockNode := capsLockNode
        this.notCapsLockNode := NotNode(this.capsLockNode)
        this.currentDeadKey := ""

        
        modStdNode := OrNode([
            AndNode([this.modNodes.std, this.notCapsLockNode]),
            AndNode([this.modNodes.shift, this.capsLockNode])
        ])
        modShiftNode := OrNode([
            AndNode([this.modNodes.std, this.capsLockNode]),
            AndNode([this.modNodes.shift, this.notCapsLockNode])
        ])

        for rowIndex, row in ScanCodes.Matrix {
            for colIndex, scanCode in row {
                gatedKeyNode := GateNode(this.enableNode, this.kbd.charKeyNodes[scanCode])

                this.CreateGateForLayout(modStdNode, gatedKeyNode, this.typingLayout.Get(scanCode))
                this.CreateGateForLayout(modShiftNode, gatedKeyNode, this.typingLayout.Get(scanCode, true, false))
                this.CreateGateForLayout(this.modNodes.ctrl_alt, gatedKeyNode, this.typingLayout.Get(scanCode, false, true))
                this.CreateGateForLayout(this.modNodes.ctrl_alt_shift, gatedKeyNode, this.typingLayout.Get(scanCode, true, true))

                shortCutChar := this.shortCutLayout.Get(scanCode)
                this.CreateGate(this.modNodes.ctrl, gatedKeyNode, shortCutChar)
                this.CreateGate(this.modNodes.win, gatedKeyNode, shortCutChar)
                this.CreateGate(this.modNodes.alt, gatedKeyNode, shortCutChar)
                this.CreateGate(this.modNodes.alt_shift, gatedKeyNode, shortCutChar)
                this.CreateGate(this.modNodes.ctrl_shift, gatedKeyNode, shortCutChar)
            }
        }
    }
   
    /**
     * Resolves a raw character string through the dead-key state machine and returns
     * the string that should actually be sent, or "" if nothing should be sent yet.
     *
     * Dead-key rules (stored in typingLayout.DeadKeyDict):
     *   - If keyStr is a dead key and no dead key is pending  → store it, return ""
     *   - If a dead key is pending and keyStr combines with it → return the composed character
     *   - If a dead key is pending but no combination exists  → return deadKey . keyStr
     *     (strips a leading "*" from the stored dead key before flushing it)
     */
    ComputeMsg(keyStr){
        if StrLen(keyStr) == 0
            return ""

        deadKeyDict := this.typingLayout.DeadKeyDict

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

    /**
     * Called by a GateNode when a character key changes state under a typing-layer modifier.
     * On key-down (state = true) it resolves keyStr through the dead-key machine and
     * sends the result via SendInput "{Blind}{Text}".
     */
    GateCallback(state, keyStr){
        if state {
            char := this.ComputeMsg(keyStr)
            if StrLen(char) > 0 {
                SendInput("{Blind}{Text}" char)
            }
        }
    }

    /**
     * Creates a GateNode that routes typing-layer characters through the dead-key machine.
     * Use this for std, shift, AltGr, and AltGr+shift layers.
     */
    CreateGateForLayout(modNode, gatedKeyNode, keyStr){
        GateNode(modNode, gatedKeyNode, (state) => this.GateCallback(state, keyStr))
    }

    /**
     * Creates a GateNode that sends keyStr as a raw key name via SendInput "{Blind}".
     * Use this for shortcut layers (ctrl, alt, win, …) where the host application
     * must see the original key name rather than a Unicode character.
     */
    CreateGate(modNode, gatedKeyNode, keyStr){
        GateNode(modNode, gatedKeyNode, (s) => s ? SendInput("{Blind}" keyStr) : "")
    }
}