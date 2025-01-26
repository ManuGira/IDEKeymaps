#Requires AutoHotkey v2.0

#Include ../Nodes/KeyStateNode.ahk
#Include ../Nodes/DoublePressNode.ahk
#Include ../Nodes/ToggleNode.ahk

myToggle := ToggleNode(
                DoublePressNode(
                    KeyStateNode("LAlt")
                ),
                (state) => ToolTip("state: " state)
            )

; state is true when doing press-release-holdpress only if the 2 press are less than 500ms appart
#HotIf myToggle.GetState()
q::a
w::z
e::e
r::r
t::t
z::y
#HotIf
