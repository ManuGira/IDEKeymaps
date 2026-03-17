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
    stateStr .= "OS Modifiers: " . "`n"
    stateStr .= "  Shift:---.." . GetKeyState("Shift", "P") . " " . mainModNodes.shift_key.GetState() . " " . extendedModNodes.shift_key.GetState() . "`n" 
    stateStr .= "  LShift:--.." . GetKeyState("LShift", "P") . "`n" 
    stateStr .= "  RShift:--.." . GetKeyState("RShift", "P") . "`n" 
    
    stateStr .= "  Control:-" . GetKeyState("Control", "P") . " " . mainModNodes.ctrl_key.GetState() . " " . extendedModNodes.ctrl_key.GetState() . "`n"
    stateStr .= "  LCtrl:-----.." . GetKeyState("LCtrl", "P") . "`n"
    stateStr .= "  RCtrl:-----.." . GetKeyState("RCtrl", "P") . "`n"
    
    stateStr .= "  Alt:-----.." . GetKeyState("Alt", "P") . " " . mainModNodes.alt_key.GetState() . " " . extendedModNodes.alt_key.GetState() . "`n"
    stateStr .= "  LAlt:----" . GetKeyState("LAlt", "P") . "`n" 
    stateStr .= "  RAlt:----" . GetKeyState("RAlt", "P") . "`n" 

    stateStr .= "  LWin:----" . GetKeyState("LWin", "P") . " " . mainModNodes.win_key.GetState() . " " . extendedModNodes.win_key.GetState() . "`n"
    stateStr .= "  RWin:----" . GetKeyState("RWin", "P") . "`n"
    
    stateStr .= "`n"
    stateStr .= "Layer Enabled:    " . mainLayerNode.GetState() . " " . extendedLayerNode.GetState() . "`n"
    stateStr .= "Layer Modifiers: " . "`n"
    stateStr .= "  std:------------" . mainModNodes.std.GetState() . " " . extendedModNodes.std.GetState() . "`n"
    stateStr .= "  shift:----------" . mainModNodes.shift.GetState() . " " . extendedModNodes.shift.GetState() . "`n"
    stateStr .= "  ctrl:-----------" . mainModNodes.ctrl.GetState() . " " . extendedModNodes.ctrl.GetState() . "`n"
    stateStr .= "  win:-----------" . mainModNodes.win.GetState() . " " . extendedModNodes.win.GetState() . "`n"
    stateStr .= "  alt:------------" . mainModNodes.alt.GetState() . " " . extendedModNodes.alt.GetState() . "`n"
    stateStr .= "  ctrl_alt:-------" . mainModNodes.ctrl_alt.GetState() . " " . extendedModNodes.ctrl_alt.GetState() . "`n"
    stateStr .= "  alt_shift:------" . mainModNodes.alt_shift.GetState() . " " . extendedModNodes.alt_shift.GetState() . "`n"
    stateStr .= "  ctrl_shift:-----" . mainModNodes.ctrl_shift.GetState() . " " . extendedModNodes.ctrl_shift.GetState() . "`n"
    stateStr .= "  ctrl_alt_shift:-" . mainModNodes.ctrl_alt_shift.GetState() . " " . extendedModNodes.ctrl_alt_shift.GetState() . "`n"
    
    Utils.TempToolTip(stateStr, 5000)    
}
fkn.lockKeyNodes["CapsLock"].Subscribe((s) => ShowState())