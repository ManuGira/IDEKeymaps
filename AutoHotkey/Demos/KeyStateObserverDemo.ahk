#Requires AutoHotkey v2.0

#Include ../Utils/KeyStateObserver.ahk


KeyStateObserver.Add("Numpad1")
KeyStateObserver.Add("~$Numpad2")  ; with ~$ they key is not discarded

counter := 0
MyCallback(key, state){
    global
    counter++
    ToolTip(counter " KeyStateObserver: " key " (" state ")", , , 1)
    SetTimer(ToolTip, -500)
}
KeyStateObserver.Subscribe(MyCallback)

#HotIf KeyStateObserver.Get("Numpad1")
q::a
w::z
e::e
r::r
t::t
z::y
#HotIf 