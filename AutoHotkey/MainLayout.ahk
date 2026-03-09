#Requires AutoHotkey v2.0

#Include Utils/KeyboardState.ahk
#Include Utils/FullKeyboardNode.ahk
#Include Utils/ModifierNodes.ahk
#Include Layouts/KeyboardLayout.ahk


fkn := FullKeyboardNode()
mainModNodes := ModifierNodes(fkn.ctrlNode, fkn.altNode, fkn.shiftNode, fkn.winNode)
mainModNodes.EnableShowStateOnChange()

KeyboardState(
    fkn,
    mainModNodes,
    KeyboardLayout("Layouts/bepo.json"), 
    KeyboardLayout("Layouts/qwertz.json")
)


Reset() {
    fkn.Reset()
    mainModNodes.Reset()
}

; Reset all key states when the Windows session is unlocked, to avoid stuck keys caused by AHK being suspended while the screen was locked.
WinSessionStateNode((s) => Reset())

Reset()
