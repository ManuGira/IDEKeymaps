#Requires AutoHotkey v2.0
#SingleInstance Force

#Include Nodes/include.ahk
#Include Mappings/JILK.ahk

TempToolTip(msg, durationMS){
    ToolTip(msg)
    SetTimer(() => ToolTip(), -durationMS)
}


; --------------- JILK DIRECTION LAYER ------------------------
OnJILK(state){
    global jilkNode
    counter := 0
    scrollLockBackUp := GetKeyState("ScrollLock", "T")
    BlinkScrollLock(){
        if not jilkNode.GetState(){
            ; restore and stop the blinking
            SetScrollLockState(scrollLockBackUp)
            return
        }
        ; switch scrolllock
        SetScrollLockState(!GetKeyState("ScrollLock", "T"))
        SetTimer(() => BlinkScrollLock(), -200)

        ToolTip("JILK Enabled (" counter ")")
        counter++
    }
    BlinkScrollLock()
    TempToolTip("JILK " (state ? "Enabled" : "Disabled"), 1000)
}

capsHold := DummyNode(KeyStateNode("Capslock", , false))
agraveHold := DummyNode(KeyStateNode("à", , false))
winHold := DummyNode(KeyStateNode("LWin", , true))
altHold := DummyNode(KeyStateNode("LAlt", , true))

global jilkNode := DummyNode(OrNode([
    ; ToggleNode(AndNode([
    ;     OrNode([
    ;         capsHold,
    ;         agraveHold,
    ;     ]),
    ;     altHold,
    ; ])),
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
    if (isRelease and not isCombo)
        SendInput("à")
}
agraveHold.Subscribe((s) => SendAgraveIfNoCombo(s))


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
#Include Mappings/SpaceAsShift.ahk
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
