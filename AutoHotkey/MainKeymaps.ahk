#Requires AutoHotkey v2.0
#SingleInstance Force

#Include Nodes/include.ahk
#Include Layers/JILK.ahk
#Include Layers/J4K5.ahk
#Include Layers/MouseController.ahk

winHold := DummyNode(KeyStateNode("LWin", , true))
altHold := DummyNode(KeyStateNode("LAlt", , true))
;ctrlHold := DummyNode(KeyStateNode("LCtrl", , true))
;shiftHold := DummyNode(KeyStateNode("LShift", , true))

capsHold := DummyNode(KeyStateNode("Capslock", , false))
agraveHold := DummyNode(KeyStateNode("à", , false))
egraveHold := DummyNode(KeyStateNode("è", , false))

; --------------- JILK DIRECTION LAYER ------------------------
OnJILK(state){
    global agraveHold
    ShowMessage(){
        if not agraveHold.GetState(){
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

SendAgraveIfNoCombo(state){
    isRelease := state = 0
    if not isRelease
        return
    ; remove " Up" from A_ThisHotkey
    thisHotkey := SubStr(A_ThisHotkey, 1, StrLen(A_ThisHotkey) - 3)  ; TODO: isCombo should be asked to KeyStateObserver
    isCombo := (A_PriorHotkey != thisHotkey) ;  or capsHold.GetState()
    if (isRelease and not isCombo){
        modifier := ""
        modifier := modifier (GetKeyState("Shift", "P") ? "+" : "")
        modifier := modifier (GetKeyState("Alt", "P") ? "!" : "")
        modifier := modifier (GetKeyState("Ctrl", "P") ? "^" : "")
        modifier := modifier (GetKeyState("LWin", "P") ? "#" : "")
        SendInput(modifier "à")
    }
}

agraveHold.Subscribe((s) => OnJILK(s))
agraveHold.Subscribe((s) => SendAgraveIfNoCombo(s))
jilkCondition := (k) => agraveHold.GetState()
JILK.Init(jilkCondition)


; --------------- J4K5 NUMPAD LAYER ------------------------
OnJ4K5(state){
    global capsHold
    ShowMessage(){
        if not capsHold.GetState()
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

capsHold.Subscribe((s) => OnJ4K5(s))
capsHold.Subscribe((s) => SendCapsLockIfNoCombo(s))
j4k5Condition := (k) => capsHold.GetState()
J4K5.Init(j4k5Condition)

; ---------------- MOUSE CONTROLLER LAYER ----------------
OnMouseController(state){
    global egraveHold
    ShowMessage(){
        if not egraveHold.GetState(){
            return
        }
        SetTimer(() => ShowMessage(), -200)
        ToolTip("MouseController Enabled")
    }
    ShowMessage()
    if not state {
        ToolTip("MouseController Disabled")
        SetTimer(() => ToolTip(), -1000)
    }
}

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

egraveHold.Subscribe((s) => OnMouseController(s))
egraveHold.Subscribe((s) => SendEgraveIfNoCombo(s))
mouseControllerCondition := (k) => egraveHold.GetState()
MouseController.Init(mouseControllerCondition)


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
