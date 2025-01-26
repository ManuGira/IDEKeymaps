#Requires AutoHotkey v2.0
#Include ../Utils/KeyStateObserver.ahk


KeyStateObserver.Add("Numpad1", false)  ; passThrough=false: will be blocked
KeyStateObserver.Add("Numpad2", true) ; passThrough=true: will still be send

counter := 0
MyKeyStateCallback(key, state){
    global
    counter++
    ToolTip(counter " KeyStateNode: " key " (" state ")", , , 1)
    SetTimer(ToolTip, -500)
}
KeyStateObserver.SubscribeAll(MyKeyStateCallback)

#HotIf KeyStateObserver.GetState("Numpad1")
q::a
w::z
e::e
r::r
t::t
z::y
#HotIf
