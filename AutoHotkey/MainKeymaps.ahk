#Requires AutoHotkey v2.0
#SingleInstance Force

#Include Nodes/include.ahk
#Include Layers/JILK.ahk
#Include Layers/J4K5.ahk
#Include Layers/MouseController.ahk
#Include Layers/FXX.ahk

#Include Utils/FullKeyboardObserver.ahk

FullKeyboardObserver.Init()

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


; Return true if another key was pressed between the time the mod key was pressed and released.
; This function works only for mod keys registered by KeyStateObserver (and KeyStateNode) 
; Mod Keys must be created with the "passthrough" parameter set to false so that 
; KeyStateObserver registers keys starting with ~*$
CheckIfCombo(character){
    ; If it's not a combo (i.e mod key alone), the A_PriorHotkey must start with "~*$"
    if not RegExMatch(A_PriorHotkey, "^\~\*\$"){
        ; we already know A_PriorHotkey is not the same as A_ThisHotkey, 
        ; because A_ThisHotkey is a mod key and mod keys start with "~*$" 
        ; because they are registered by KeyStateObserver (or KeyStateNode) 
        ; with the "passthrough" parameter set to false
        return true
    }
    
    ; remove the leading "~*$" from A_PriorHotkey
    priorHotkey := SubStr(A_PriorHotkey, 4, StrLen(A_PriorHotkey))

    ; TODO: isCombo could be asked to KeyStateObserver if we set an observer for all keys
    if not RegExMatch(A_ThisHotkey, "^\*")
        throw "A_ThisHotkey must start with '*' : " A_ThisHotkey

    if not RegExMatch(A_ThisHotkey, " Up$")
        throw "A_ThisHotkey must end with ' Up' : " A_ThisHotkey

    ; remove the leading "*" and the ending " Up" from A_ThisHotkey (keep from char 2 to char -4)
    thisHotkey := SubStr(A_ThisHotkey, 2, StrLen(A_ThisHotkey) - 4)

    isCombo := (thisHotkey != priorHotkey)  
    ;ToolTip("(" A_ThisHotkey "," A_PriorHotkey ") -> (" thisHotkey "=?" priorHotkey ") -> " (isCombo ? "different" : "same"))
    return isCombo
}

; Send a character if the key has been pressed and released with no other keys pressed in the mean time. 
; This means the character must be sent, and the key is not considered as a mod key
SendCharIfNoCombo(character, state){
    isRelease := state = 0
    if not isRelease
        return
    
    isCombo := CheckIfCombo(character)
    if (not isCombo){    
        if character == "CapsLock" {
            SetCapsLockState(1 - GetKeyState("CapsLock", "T"))  ; invert capslock state
            return
        }

        modifier := ""
        modifier := modifier (GetKeyState("Shift", "P") ? "+" : "")
        modifier := modifier (GetKeyState("Alt", "P") ? "!" : "")
        modifier := modifier (GetKeyState("Ctrl", "P") ? "^" : "")
        modifier := modifier (GetKeyState("LWin", "P") ? "#" : "")
        SendInput(modifier character)
    }
}

winHold := DummyNode(KeyStateNode("LWin", , true))
altHold := DummyNode(KeyStateNode("LAlt", , true))
;ctrlHold := DummyNode(KeyStateNode("LCtrl", , true))
;shiftHold := DummyNode(KeyStateNode("LShift", , true))

rshiftHold := DummyNode(KeyStateNode("RShift", , false))

capsHold := DummyNode(KeyStateNode("Capslock", , false))
;capsHold.Subscribe((s) => SendCharIfNoCombo("CapsLock", s))

agraveHold := DummyNode(KeyStateNode("à", , false))
agraveHold.Subscribe((s) => SendCharIfNoCombo("à", s))

egraveHold := DummyNode(KeyStateNode("è", , false))
egraveHold.Subscribe((s) => SendCharIfNoCombo("è", s))

smallerThanHold := DummyNode(KeyStateNode("<", , false))
smallerThanHold.Subscribe((s) => SendCharIfNoCombo("<", s))

spaceHold := DummyNode()
;spaceHold.Subscribe((s) => SendCharIfNoCombo("{Space}", s))


; --------------- JILK DIRECTION LAYER ------------------------
jilkLayerNode := capsHold
jilkLayerNode.Subscribe((s) => ShowState("JILK", jilkLayerNode, s))
jilkCondition := (k) => jilkLayerNode.GetState()
JILK.Init(jilkCondition, spaceHold)

; --------------- J4K5 NUMPAD LAYER ------------------------
j4k5LayerNode := OrNode([rshiftHold, smallerThanHold])
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
IsScrollLockEnabled := (s) => GetKeyState("ScrollLock", "T")
NumpadAwan.Init(IsScrollLockEnabled)

; ---------------- FXX LAYER ------------------------
ffxLayerNode := agraveHold
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
*Left::return
*Up::return
*Right::return
*Down::return
*Home::return
*End::return
