#Requires AutoHotkey v2.0

#Include Utils/KeyboardState.ahk
#Include Utils/FullKeyboardNode.ahk
#Include Utils/ModifierNodes.ahk
#Include Layouts/KeyboardLayout.ahk

fkn := FullKeyboardNode()

extendedLayerNode := fkn.lockKeyNodes["CapsLock"]
mainLayerNode := NotNode(extendedLayerNode)


mainModNodes := ModifierNodes(fkn.ctrlNode, fkn.altNode, fkn.shiftNode, fkn.winNode)
; extended layer has shift and ctrl swapped 
extendedModNodes := ModifierNodes(fkn.shiftNode, fkn.altNode, fkn.ctrlNode, fkn.winNode)

; mainModNodes := GatedModifierNodes(mainLayerNode, modNodes)
; extendedModNodes := GatedModifierNodes(extendedLayerNode, modNodes)

; mainModNodes.EnableShowStateOnChange()

capsLockNode := PassNode(,,false)
KeyboardState(
    mainLayerNode,
    fkn,
    mainModNodes,
    capsLockNode,
    KeyboardLayout("Layouts/bepo.json"), 
    KeyboardLayout("Layouts/azerty.json")
)

KeyboardState(
    extendedLayerNode,
    fkn,
    extendedModNodes,
    capsLockNode,
    KeyboardLayout("Layouts/azerty.json"), 
    KeyboardLayout("Layouts/qwertz.json")
)

Reset() {
    fkn.Reset()
    mainLayerNode.Update(false)
    extendedLayerNode.Update(false)
    mainModNodes.Reset()
    extendedModNodes.Reset()
}

; Reset all key states when the Windows session is unlocked, to avoid stuck keys caused by AHK being suspended while the screen was locked.
WinSessionStateNode((s) => Reset())


Reset()

ShowState() {
    stateStr := ""
    stateStr .= "Main Layer Enabled: " . mainLayerNode.GetState() . "`n"
    stateStr .= "Main Modifiers: " . "`n"
    stateStr .= "  std:  " . mainModNodes.std.GetState() . "`n"
    stateStr .= "  shift:  " . mainModNodes.shift.GetState() . "`n"
    stateStr .= "  ctrl:  " . mainModNodes.ctrl.GetState() . "`n"
    stateStr .= "  win:  " . mainModNodes.win.GetState() . "`n"
    stateStr .= "  alt:  " . mainModNodes.alt.GetState() . "`n"
    stateStr .= "  ctrl_alt:  " . mainModNodes.ctrl_alt.GetState() . "`n"
    stateStr .= "  alt_shift:  " . mainModNodes.alt_shift.GetState() . "`n"
    stateStr .= "  ctrl_shift:  " . mainModNodes.ctrl_shift.GetState() . "`n"
    stateStr .= "  ctrl_alt_shift:  " . mainModNodes.ctrl_alt_shift.GetState() . "`n"
    stateStr .= "`n"
    stateStr .= "Extended Layer Enabled: " . extendedLayerNode.GetState() . "`n"
    stateStr .= "Extended Modifiers: " . "`n"
    stateStr .= "  std:  " . extendedModNodes.std.GetState() . "`n"
    stateStr .= "  shift:  " . extendedModNodes.shift.GetState() . "`n"
    stateStr .= "  ctrl:  " . extendedModNodes.ctrl.GetState() . "`n"
    stateStr .= "  win:  " . extendedModNodes.win.GetState() . "`n"
    stateStr .= "  alt:  " . extendedModNodes.alt.GetState() . "`n"
    stateStr .= "  ctrl_alt:  " . extendedModNodes.ctrl_alt.GetState() . "`n"
    stateStr .= "  alt_shift:  " . extendedModNodes.alt_shift.GetState() . "`n"
    stateStr .= "  ctrl_shift:  " . extendedModNodes.ctrl_shift.GetState() . "`n"
    stateStr .= "  ctrl_alt_shift:  " . extendedModNodes.ctrl_alt_shift.GetState() . "`n"
    stateStr .= "`n"
    
    Utils.TempToolTip(stateStr, 5000)    
}
fkn.lockKeyNodes["CapsLock"].Subscribe((s) => ShowState())