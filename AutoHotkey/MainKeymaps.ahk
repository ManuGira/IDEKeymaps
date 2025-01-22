#Requires AutoHotkey v2.0

#Include Utils/KeyStateObserver.ahk
#Include Utils/SwitchObserver.ahk

KeyStateObserver.Add("Numpad1", false)
KeyStateObserver.Add("Numpad2", false)

SwitchObserver.Add("PanicButtonLR", ["Left", "Right"])

#HotIf not SwitchObserver.Get("PanicButton") and KeyStateObserver.Get("Numpad1")
#Include Mappings/LeftIsNumPad.ahk
#HotIf


#HotIf not SwitchObserver.Get("PanicButton")
#Include Mappings/SpecFlip.ahk
#Include Mappings/RightIsArrow.ahk
#HotIf


;CheckSwitches(){
;    if SwitchObserver.Get("PanicButtonLR")
;        ToolTip("PanicButtonLR", , , 1)
;    else
;        ToolTip(isKeyDown["Left"] " " isKeyDown["Right"])
;}
;
;SetTimer(CheckSwitches, 500)
