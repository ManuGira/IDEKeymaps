#Requires AutoHotkey v2.0
#SingleInstance Force

#Include Nodes/include.ahk
#Include Mappings/JILK.ahk

TempToolTip(msg, durationMS){
    ToolTip(msg)
    SetTimer(() => ToolTip(), -durationMS)
}

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

        ToolTip("JILK Enabled" counter)
        counter++
    }
    BlinkScrollLock()
    TempToolTip("JILK " (state ? "Enabled" : "Disabled"), 1000)
}

capsHold := DummyNode(KeyStateNode("Capslock", , false))
shiftHold := DummyNode(KeyStateNode("LShift", , true))
altHold := DummyNode(KeyStateNode("LAlt", , true))

global jilkNode := DummyNode(OrNode([
    ToggleNode(AndNode([capsHold, altHold])),
    capsHold,
]))

jilkNode.Subscribe((s) => OnJILK(s))
jilkCondition := (k) => jilkNode.GetState()
JILK.Init(jilkCondition) 

; Use Shift+Capslock to toggle Capslock
capsToggleNode := ToggleNode(DummyNode(AndNode([capsHold, shiftHold])))
capsToggleNode.Subscribe((s) => SetCapsLockState(s))

; --------------- SPACE AS SHIFT ---------------------
#Include Mappings/SpaceAsShift.ahk
SpaceAsShift.Init() 

; --------------- WIN CONTROLLER ---------------------
; #Include ThirdParty/WinController.ahk
; ; Alt + Left Button  : Drag to move a window.
; ; Alt + Right Button : Drag to resize a window.
; ; Double-Alt + Left Button   : Maximize/Restore a window.
; ; Double-Alt + Right Button  : Minimize a window.
; 
; !LButton::
; {
;     doubleClick := (A_PriorHotkey = A_ThisHotkey and A_TimeSincePriorHotkey < DllCall("GetDoubleClickTime"))
;     ; Sleep 0
; 
;     if doubleClick {
;         WinController.ToggleMaximize()
;         return
;     }
;     WinController.Move()
; }
; 
; !RButton::
; {
;     doubleClick := (A_PriorHotkey = A_ThisHotkey and A_TimeSincePriorHotkey < DllCall("GetDoubleClickTime"))
;     ; Sleep 0
; 
;     if doubleClick {
;         WinController.Minimize()
;         return
;     }
;     WinController.Resize()
; }

; ---------------- DEACTIVATE ORIGINAL KEYS (force learning) ----------------
*Left::return
*Up::return
*Right::return
*Down::return
*Home::return
*End::return
