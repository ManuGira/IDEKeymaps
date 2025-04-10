#Requires AutoHotkey v2.0
#SingleInstance Force

#Include Nodes/include.ahk
#Include Layers/JILK.ahk
#Include Layers/J4K5.ahk
#Include Layers/MouseController.ahk

; function to display a tooltip as long as the layer is enabled
ShowState(name, stateNode, state){
    ShowMessage(){
        if not stateNode.GetState()
            return
        SetTimer(() => ShowMessage(), -200)
        ToolTip(name " Enabled")
    }
    ShowMessage()
    if state = 0 {
        ToolTip(name " Disabled")
        SetTimer(() => ToolTip(), -1000)
    }
}

; send a character if the key has been pressed and released with no other keys pressed in the mean time. 
; This means the character must be sent, and the key is not considered as a mod key
SendCharIfNoCombo(character, state){
    isRelease := state = 0
    if not isRelease
        return
    ; remove " Up" from A_ThisHotkey
    thisHotkey := SubStr(A_ThisHotkey, 1, StrLen(A_ThisHotkey) - 3)  ; TODO: isCombo should be asked to KeyStateObserver
    isCombo := (A_PriorHotkey != thisHotkey)
    if (isRelease and not isCombo){
        modifier := ""
        modifier := modifier (GetKeyState("Shift", "P") ? "+" : "")
        modifier := modifier (GetKeyState("Alt", "P") ? "!" : "")
        modifier := modifier (GetKeyState("Ctrl", "P") ? "^" : "")
        modifier := modifier (GetKeyState("LWin", "P") ? "#" : "")
        SendInput(modifier character)
    }
}

SendCapsLockIfNoCombo(state){
    isRelease := state = 0
    if not isRelease
        return
    ; remove " Up" from A_ThisHotkey
    thisHotkey := SubStr(A_ThisHotkey, 1, StrLen(A_ThisHotkey) - 3)  ; TODO: isCombo should be asked to KeyStateObserver
    isCombo := (A_PriorHotkey != thisHotkey) or agraveHold.GetState()
    if (isRelease and not isCombo)
        SetCapsLockState(1 - GetKeyState("CapsLock", "T"))  ; invert capslock state
}

winHold := DummyNode(KeyStateNode("LWin", , true))
altHold := DummyNode(KeyStateNode("LAlt", , true))
;ctrlHold := DummyNode(KeyStateNode("LCtrl", , true))
;shiftHold := DummyNode(KeyStateNode("LShift", , true))

capsHold := DummyNode(KeyStateNode("Capslock", , false))
agraveHold := DummyNode(KeyStateNode("à", , false))
egraveHold := DummyNode(KeyStateNode("è", , false))
spaceHold := DummyNode(KeyStateNode("Space", , false))

capsHold.Subscribe((s) => SendCapsLockIfNoCombo(s))
egraveHold.Subscribe((s) => SendCharIfNoCombo("è", s))
spaceHold.Subscribe((s) => SendCharIfNoCombo("{Space}", s))
agraveHold.Subscribe((s) => SendCharIfNoCombo("à", s))

; --------------- JILK DIRECTION LAYER ------------------------
jilkLayerNode := capsHold
jilkLayerNode.Subscribe((s) => ShowState("JILK", jilkLayerNode, s))
jilkCondition := (k) => jilkLayerNode.GetState()
JILK.Init(jilkCondition, spaceHold)

; --------------- J4K5 NUMPAD LAYER ------------------------
j4k5LayerNode := egraveHold
j4k5LayerNode.Subscribe((s) => ShowState("J4K5", j4k5LayerNode, s))
j4k5Condition := (k) => j4k5LayerNode.GetState()
J4K5.Init(j4k5Condition)

; ---------------- MOUSE CONTROLLER LAYER ----------------
mouseLayerNode := agraveHold
mouseLayerNode.Subscribe((s) => ShowState("Mouse", mouseLayerNode, s))
MouseController.Init(mouseLayerNode, spaceHold)

; --------------- SPECIAL CHAR LAYER -----------------
;OnTab(state){
;    isRelease := state = 0
;    isCombo := A_PriorHotkey != A_ThisHotkey
;    if (isRelease and not isCombo)
;        SendInput("{Tab}")
;}   
;
;tabNode := altHold := DummyNode(KeyStateNode("LAlt", , false)).Subscribe((s) => OnTab(s))



; --------------- SPACE AS SHIFT ---------------------
;#Include Layers/SpaceAsShift.ahk
;spaceHoldCondition := (k) => not mouseLayerNode.GetState()
;SpaceAsShift.Init(spaceHoldCondition)

OnSpace(state, condition){
    if not condition("")
        return

    isDown := state = 1
    if isDown 
        SendInput("{Blind}{ShiftDown}")
    else
        SendInput("{ShiftUp}")
}

spaceHoldCondition := (k) => not mouseLayerNode.GetState()
spaceHold.Subscribe((s) => OnSpace(s, spaceHoldCondition))


; --------------- WIN CONTROLLER ---------------------
#Include ThirdParty/WinController.ahk
; Alt + Left Button  : Drag to move a window.
; Alt + Right Button : Drag to resize a window.
; Double-Alt + Left Button   : Maximize/Restore a window.
; Double-Alt + Right Button  : Minimize a window.

#LButton::
{
    doubleClick := (A_PriorHotkey = A_ThisHotkey and A_TimeSincePriorHotkey < DllCall("GetDoubleClickTime"))
    ; Sleep 0

    if doubleClick {
        WinController.ToggleMaximize()
        return
    }
    WinController.Move()
}

#RButton::
{
    doubleClick := (A_PriorHotkey = A_ThisHotkey and A_TimeSincePriorHotkey < DllCall("GetDoubleClickTime"))
    ; Sleep 0

    if doubleClick {
        WinController.Minimize()
        return
    }
    WinController.Resize()
}

#MButton::WinController.Close()

; ---------------- DEACTIVATE ORIGINAL KEYS (force learning) ----------------
*Left::return
*Up::return
*Right::return
*Down::return
*Home::return
*End::return
