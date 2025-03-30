#Requires AutoHotkey v2.0
#SingleInstance Force

#Include Nodes/include.ahk
TempToolTip(msg, durationMS){
    ToolTip(msg)
    SetTimer(() => ToolTip(), -durationMS)
}
#Include Layers/JILK.ahk
#Include Layers/J4K5.ahk

winHold := DummyNode(KeyStateNode("LWin", , true))
altHold := DummyNode(KeyStateNode("LAlt", , true))
;ctrlHold := DummyNode(KeyStateNode("LCtrl", , true))
;shiftHold := DummyNode(KeyStateNode("LShift", , true))

; --------------- JILK DIRECTION LAYER ------------------------
OnJILK(state){
    global jilkNode
    ShowMessage(){
        if not jilkNode.GetState(){
            return
        }
        SetTimer(() => ShowMessage(), -200)
        ToolTip("JILK Enabled")
    }
    ShowMessage()
    if not state {
        ToolTip("JILK Disabled")
        SetTimer(() => ToolTip(), -1000)
    }
}

capsHold := DummyNode(KeyStateNode("Capslock", , false))
agraveHold := DummyNode(KeyStateNode("à", , false))

global jilkNode := DummyNode(OrNode([
    ToggleNode(AndNode([
        capsHold,
        agraveHold,
    ])),
    capsHold,
    agraveHold,
]))

jilkNode.Subscribe((s) => OnJILK(s))
jilkCondition := (k) => jilkNode.GetState()
JILK.Init(jilkCondition) 

; Use Win+à to insert à
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
capsHold.Subscribe((s) => SendCapsLockIfNoCombo(s))

; Use Win+à to insert à
SendAgraveIfNoCombo(state){
    isRelease := state = 0
    if not isRelease
        return
    ; remove " Up" from A_ThisHotkey
    thisHotkey := SubStr(A_ThisHotkey, 1, StrLen(A_ThisHotkey) - 3)  ; TODO: isCombo should be asked to KeyStateObserver
    isCombo := (A_PriorHotkey != thisHotkey) or capsHold.GetState()
    if (isRelease and not isCombo){
        modifier := ""
        modifier := modifier (GetKeyState("Shift", "P") ? "+" : "")
        modifier := modifier (GetKeyState("Alt", "P") ? "!" : "")
        modifier := modifier (GetKeyState("Ctrl", "P") ? "^" : "")
        modifier := modifier (GetKeyState("LWin", "P") ? "#" : "")
        SendInput(modifier "à")
    }
}
agraveHold.Subscribe((s) => SendAgraveIfNoCombo(s))


; --------------- J4K5 NUMPAD LAYER ------------------------
OnJ4K5(state){
    global j4k5Node
    ShowMessage(){
        if not j4k5Node.GetState()
            return
        SetTimer(() => ShowMessage(), -200)
        ToolTip("J4K5 Enabled")
    }
    ShowMessage()
    if state = 0 {
        ToolTip("J4K5 Disabled")
        SetTimer(() => ToolTip(), -1000)
    }
}
egraveHold := DummyNode(KeyStateNode("è", , false))
global j4k5Node := DummyNode(egraveHold)
j4k5Node.Subscribe((s) => OnJ4K5(s))
j4k5Condition := (k) => j4k5Node.GetState()
J4K5.Init(j4k5Condition)

SendEgraveIfNoCombo(state){
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
        SendInput(modifier "è")
    }
}
egraveHold.Subscribe((s) => SendEgraveIfNoCombo(s))


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
#Include Layers/SpaceAsShift.ahk
SpaceAsShift.Init() 

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
