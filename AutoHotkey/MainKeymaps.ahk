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
    numLockBackUp := GetKeyState("NumLock", "T")
    BlinkScrollLock(){
        if not jilkNode.GetState(){
            ; restore and stop the blinking
            SetNumLockState(numLockBackUp)
            return
        }
        ; switch numlock
        SetNumLockState(!GetKeyState("NumLock", "T"))
        SetTimer(() => BlinkScrollLock(), -200)
    }
    BlinkScrollLock()
    TempToolTip("JILK " (state ? "Enabled" : "Disabled"), 1000)
}

+CapsLock::CapsLock
capsHoldNode := DummyNode(  ; Dummy node only trigger if new state is different from the previous one
    KeyStateNode("Capslock", , false)
)

capsTHitNode := ToggleNode(HitNode(capsHoldNode), , 50)

global jilkNode :=  DummyNode(OrNode([capsTHitNode, capsHoldNode]))
jilkNode.Subscribe((s) => OnJILK(s))
jilkCondition := (k) => jilkNode.GetState()
JILK.Init(jilkCondition) 

; --------------- SPACE AS SHIFT ---------------------
#Include Mappings/SpaceAsShift.ahk
SpaceAsShift.Init() 

; --------------- WIN CONTROLLER ---------------------
#Include ThirdParty/WinController.ahk
; Alt + Left Button  : Drag to move a window.
; Alt + Right Button : Drag to resize a window.
; Double-Alt + Left Button   : Maximize/Restore a window.
; Double-Alt + Right Button  : Minimize a window.

!LButton::
{
    doubleClick := (A_PriorHotkey = A_ThisHotkey and A_TimeSincePriorHotkey < DllCall("GetDoubleClickTime"))
    ; Sleep 0

    if doubleClick {
        WinController.ToggleMaximize()
        return
    }
    WinController.Move()
}

!RButton::
{
    doubleClick := (A_PriorHotkey = A_ThisHotkey and A_TimeSincePriorHotkey < DllCall("GetDoubleClickTime"))
    ; Sleep 0

    if doubleClick {
        WinController.Minimize()
        return
    }
    WinController.Resize()
}