#Requires AutoHotkey v2.0

#Include Utils/KeyboardState.ahk
#Include Utils/FullKeyboardNode.ahk
#Include Utils/ModifierNodes.ahk
#Include Layouts/KeyboardLayout.ahk

MinimalModifierBug() {
    fkn := {
        ctrlNode: KeyStateNode("1", , false),
        altNode: KeyStateNode("2", , false),
        shiftNode: KeyStateNode("3", , false),
        winNode: KeyStateNode("4", , false),
    }


    mainModNodes := ModifierNodes(fkn.ctrlNode, fkn.altNode, fkn.shiftNode, fkn.winNode)
    extendedModNodes := ModifierNodes(fkn.ctrlNode, fkn.altNode, fkn.shiftNode, fkn.winNode)
    
    SendModInput(state, key) {
        if state {
            SendInput("{Blind}{" key " Down}")
        } else {
            SendInput("{Blind}{" key " Up}")
        }
    }

    capsNode := KeyLockStateNode(CapsLockStr, false)
    notCapsNode := NotNode(capsNode)

    ; Create GateNodes for modifier keys to send modifier input when they change state
    for name, node in mainModNodes.inputNodes {
        ; TODO: simplify this monster
        GateNode(notCapsNode, node, ((n) => (s) => this.SendModInput(s, n))(name))
    }

    for name, node in extendedModNodes.inputNodes {
        ; TODO: simplify this monster
        GateNode(capsNode, node, ((n) => (s) => this.SendModInput(s, n))(name))
    }

    

    gatedKeyNode := GateNode(layerNode, this.kbd.charKeyNodes[scanCode])


    Reset() {
        fkn.Reset()
        ; forces capslock to false
        SetCapsLockState("On")
        SetCapsLockState("Off")

        ; Set toggle extended layer to true-false to force update of all nodes depending on it
        extendedLayerNode.Update(true)
        extendedLayerNode.Update(false)
    }

    ; Reset all key states when the Windows session is unlocked, to avoid stuck keys caused by AHK being suspended while the screen was locked.
    WinSessionStateNode((s) => Reset())

    ShowState() {
        stateStr := ""
        stateStr .= "OS Modifiers: " . "`n"
        stateStr .= "  Shift:---.." . GetKeyState("Shift", "P") . " " 
        stateStr .= mainModNodes.inputNodes[ModifierNodes.KeyNames.SHIFT].GetState() . " " 
        stateStr .= extendedModNodes.inputNodes[ModifierNodes.KeyNames.SHIFT].GetState() . "`n" 
        stateStr .= "  LShift:--.." . GetKeyState("LShift", "P") . "`n" 
        stateStr .= "  RShift:--.." . GetKeyState("RShift", "P") . "`n" 
        
        stateStr .= "  Control:-" . GetKeyState("Control", "P") . " " . mainModNodes.inputNodes[ModifierNodes.KeyNames.CTRL].GetState() . " " . extendedModNodes.inputNodes[ModifierNodes.KeyNames.CTRL].GetState() . "`n"
        stateStr .= "  LCtrl:-----.." . GetKeyState("LCtrl", "P") . "`n"
        stateStr .= "  RCtrl:-----.." . GetKeyState("RCtrl", "P") . "`n"
        
        stateStr .= "  Alt:-----.." . GetKeyState("Alt", "P") . " " . mainModNodes.inputNodes[ModifierNodes.KeyNames.ALT].GetState() . " " . extendedModNodes.inputNodes[ModifierNodes.KeyNames.ALT].GetState() . "`n"
        stateStr .= "  LAlt:----" . GetKeyState("LAlt", "P") . "`n" 
        stateStr .= "  RAlt:----" . GetKeyState("RAlt", "P") . "`n" 

        stateStr .= "  LWin:----" . GetKeyState("LWin", "P") . " " . mainModNodes.inputNodes[ModifierNodes.KeyNames.WIN].GetState() . " " . extendedModNodes.inputNodes[ModifierNodes.KeyNames.WIN].GetState() . "`n"
        stateStr .= "  RWin:----" . GetKeyState("RWin", "P") . "`n"
        
        stateStr .= "`n"
        stateStr .= "Layer Enabled:    " . mainLayerNode.GetState() . " " . extendedLayerNode.GetState() . "`n"
        stateStr .= "Layer Modifiers: " . "`n"
        stateStr .= "  std:------------" . mainModNodes.GetState({ctrl:false, alt:false, shift:false, win:false}) . " " . extendedModNodes.GetState({ctrl:false, alt:false, shift:false, win:false}) . "`n"
        stateStr .= "  shift:----------" . mainModNodes.GetState({ctrl:false, alt:false, shift:true, win:false}) . " " . extendedModNodes.GetState({ctrl:false, alt:false, shift:true, win:false}) . "`n"
        stateStr .= "  ctrl:-----------" . mainModNodes.GetState({ctrl:true, alt:false, shift:false, win:false}) . " " . extendedModNodes.GetState({ctrl:true, alt:false, shift:false, win:false}) . "`n"
        stateStr .= "  win:-----------" . mainModNodes.GetState({ctrl:false, alt:false, shift:false, win:true}) . " " . extendedModNodes.GetState({ctrl:false, alt:false, shift:false, win:true}) . "`n"
        stateStr .= "  alt:------------" . mainModNodes.GetState({ctrl:false, alt:true, shift:false, win:false}) . " " . extendedModNodes.GetState({ctrl:false, alt:true, shift:false, win:false}) . "`n"
        stateStr .= "  ctrl_alt:-------" . mainModNodes.GetState({ctrl:true, alt:true, shift:false, win:false}) . " " . extendedModNodes.GetState({ctrl:true, alt:true, shift:false, win:false}) . "`n"
        stateStr .= "  alt_shift:------" . mainModNodes.GetState({ctrl:false, alt:true, shift:true, win:false}) . " " . extendedModNodes.GetState({ctrl:false, alt:true, shift:true, win:false}) . "`n"
        stateStr .= "  ctrl_shift:-----" . mainModNodes.GetState({ctrl:true, alt:false, shift:true, win:false}) . " " . extendedModNodes.GetState({ctrl:true, alt:false, shift:true, win:false}) . "`n"
        stateStr .= "  ctrl_alt_shift:-" . mainModNodes.GetState({ctrl:true, alt:true, shift:true, win:false}) . " " . extendedModNodes.GetState({ctrl:true, alt:true, shift:true, win:false}) . "`n"
        
        Utils.TempToolTip(stateStr, 5000)    
    }
    fkn.lockKeyNodes["CapsLock"].Subscribe((s) => ShowState())

    Reset()
}

MinimalModifierBug()