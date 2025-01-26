#Requires AutoHotkey v2.0

#Include ../Utils/Conditional.ahk

#Include ../Nodes/KeyStateNode.ahk
#Include ../Nodes/ToggleNode.ahk

; Create an instance of ToggleNode. Its state will toggle when "Left" key is pressed
myToggle := ToggleNode(KeyStateNode("Left"), ,true)

counter := 0
MySwitchCallback(state){
    global
    counter++
    ToolTip(counter " ToggleNode: " state, , , 1)
    SetTimer(ToolTip, -500)
}
myToggle.Subscribe(MySwitchCallback)  ; optional callback. It's also possible to subscribe when creating the ToggleNode object

; Use the GetState() method of ToggleNode to get the current state of the switch
condFunc := (k) => myToggle.GetState()
Conditional.Remap("a", "q", condFunc)
Conditional.Remap("q", "a", condFunc)
Conditional.Remap("w", "z", condFunc)
Conditional.Remap("e", "e", condFunc)
Conditional.Remap("r", "r", condFunc)
Conditional.Remap("t", "t", condFunc)
Conditional.Remap("z", "y", condFunc)
