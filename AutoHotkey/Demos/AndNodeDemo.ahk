#Requires AutoHotkey v2.0

#Include ../Nodes/KeyStateNode.ahk
#Include ../Nodes/AndNode.ahk

ToolTip("state: 0")

myCombo := AndNode([
        KeyStateNode("LAlt"), 
        KeyStateNode("RAlt")
    ],
    (state) => ToolTip("state: " state)
)
; detects when LAlt and RAlt are down simultaneously
