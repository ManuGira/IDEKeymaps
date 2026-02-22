#Requires AutoHotkey v2.0
#SingleInstance Force

#Include Utils/Utils.ahk
#Include Utils/FullKeyboardObserver.ahk

#Include Nodes/include.ahk
#Include Layers/JKIL.ahk
#Include Layers/J4K5.ahk
#Include Layers/MouseController.ahk
#Include Layers/FXX.ahk

FullKeyboardObserver.Init()

; Deactivate CapsLock at initialisation
SetCapsLockState(0)

;winHold := ChangeNode(KeyStateNode("LWin", , true))
;altHold := ChangeNode(KeyStateNode("LAlt", , true))
;ctrlHold := ChangeNode(KeyStateNode("LCtrl", , true))
;shiftHold := ChangeNode(KeyStateNode("LShift", , true))

rshiftHold := ChangeNode(KeyStateNode("RShift", , false))

capsHold := ChangeNode(KeyStateNode("Capslock", , false))
;capsHold.Subscribe((s) => SendCharIfNoCombo("CapsLock", s))

agraveHold := ChangeNode(KeyStateNode("à", , false))
agraveHold.Subscribe((s) => SendCharIfNoCombo("à", s))

egraveHold := ChangeNode(KeyStateNode("è", , false))
egraveHold.Subscribe((s) => SendCharIfNoCombo("è", s))

smallerThanHold := ChangeNode(KeyStateNode("<", , false))
smallerThanHold.Subscribe((s) => SendCharIfNoCombo("<", s))

spaceHold := ChangeNode(KeyStateNode("Space", , false))
spaceHold.Subscribe((s) => SendCharIfNoCombo("{Space}", s))

; --------------- JKIL DIRECTION LAYER ------------------------
jkilLayerNode := capsHold
jkilLayerNode.Subscribe((s) => ShowState("JKIL", jkilLayerNode, s))
jkilCondition := (k) => jkilLayerNode.GetState()
JKIL.Init(jkilCondition, spaceHold)

; --------------- J4K5 NUMPAD LAYER ------------------------
j4k5LayerNode := OrNode([smallerThanHold])
j4k5LayerNode.Subscribe((s) => ShowState("J4K5", j4k5LayerNode, s))
j4k5Condition := (k) => j4k5LayerNode.GetState()
J4K5.Init(j4k5Condition)

; ---------------- MOUSE CONTROLLER LAYER ----------------
mouseLayerNode := egraveHold
mouseLayerNode.Subscribe((s) => ShowState("Mouse", mouseLayerNode, s))
MouseController.Init(mouseLayerNode, spaceHold)

; --------------- SPACE AS SHIFT ---------------------
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

; --------------- NUMPADAWAN LAYER ------------------------
#Include Layers/NumpadAwan.ahk
numpadAwanCondition := (k) => GetKeyState("NumLock", "T")
NumpadAwan.Init(numpadAwanCondition)

; ---------------- FXX LAYER ------------------------
ffxLayerNode := OrNode([agraveHold, rshiftHold])
ffxLayerNode.Subscribe((s) => ShowState("FXX", ffxLayerNode, s))
ffxCondition := (k) => ffxLayerNode.GetState()
FXX.Init(ffxCondition)

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
; Must not be observed by FullKeyboardObserver, otherwise they won't be deactivated
*Left::return
*Up::return
*Right::return
*Down::return
*Home::return
*End::return
