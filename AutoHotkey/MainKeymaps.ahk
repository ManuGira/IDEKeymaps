#Requires AutoHotkey v2.0

#Include Utils/KeyDownObserver.ahk
#Include Utils/SwitchObserver.ahk

ObserveKeyDown("Numpad1")
ObserveKeyDown("Numpad2")

SwitchObserver.Add("PanicButtonLR", ["Left", "Right"])

#HotIf not SwitchObserver.Get("PanicButton") and isKeyDown["Numpad1"]
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
