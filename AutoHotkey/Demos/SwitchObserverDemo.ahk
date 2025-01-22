#Requires AutoHotkey v2.0

#Include ../Utils/SwitchObserver.ahk


SwitchObserver.Add("MyCombo", ["Numpad1", "Numpad2"])

counter := 0
MyCallback(name, state){
    global
    counter++
    ToolTip(counter " SwitchObserver: " name "(" state ")", , , 1)
    SetTimer(ToolTip, -500)
}
SwitchObserver.Subscribe(MyCallback)

#HotIf SwitchObserver.Get("MyCombo")
q::a
w::z
e::e
r::r
t::t
z::y
#HotIf
