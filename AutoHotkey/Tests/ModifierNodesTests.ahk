#Requires AutoHotkey v2.0

#Include Assert.ahk
#Include ../Nodes/include.ahk
#Include ../Utils/Utils.ahk
#Include ../Utils/ModifierNodes.ahk

; ─── ModifierNodes ────────────────────────────────────────────────────────────

TestModifierNodesAfterReset() {
    ctrlNode := PassNode()
    altNode := PassNode()
    shiftNode := PassNode()
    winNode := PassNode()

    sut := ModifierNodes(ctrlNode, altNode, shiftNode, winNode)
    sut.Reset()

    Assert.True(sut.std.GetState(),             "std should be true after Reset")
    Assert.False(sut.shift.GetState(),          "shift should be false after Reset")
    Assert.False(sut.ctrl.GetState(),           "ctrl should be false after Reset")
    Assert.False(sut.win.GetState(),            "win should be false after Reset")
    Assert.False(sut.alt.GetState(),            "alt should be false after Reset")
    Assert.False(sut.ctrl_alt.GetState(),       "ctrl_alt should be false after Reset")
    Assert.False(sut.alt_shift.GetState(),      "alt_shift should be false after Reset")
    Assert.False(sut.ctrl_shift.GetState(),     "ctrl_shift should be false after Reset")
    Assert.False(sut.ctrl_alt_shift.GetState(), "ctrl_alt_shift should be false after Reset")
}
TestModifierNodesAfterReset()

TestModifierNodesShiftOnly() {
    ctrlNode := PassNode()
    altNode := PassNode()
    shiftNode := PassNode()
    winNode := PassNode()

    sut := ModifierNodes(ctrlNode, altNode, shiftNode, winNode)
    sut.Reset()
    shiftNode.Update(true)

    Assert.False(sut.std.GetState(),            "std should be false when shift pressed")
    Assert.True(sut.shift.GetState(),           "shift should be true when only shift pressed")
    Assert.False(sut.ctrl.GetState(),           "ctrl should be false")
    Assert.False(sut.win.GetState(),            "win should be false")
    Assert.False(sut.alt.GetState(),            "alt should be false")
    Assert.False(sut.ctrl_alt.GetState(),       "ctrl_alt should be false")
    Assert.False(sut.alt_shift.GetState(),      "alt_shift should be false")
    Assert.False(sut.ctrl_shift.GetState(),     "ctrl_shift should be false")
    Assert.False(sut.ctrl_alt_shift.GetState(), "ctrl_alt_shift should be false")
}
TestModifierNodesShiftOnly()

TestModifierNodesCtrlOnly() {
    ctrlNode := PassNode()
    altNode := PassNode()
    shiftNode := PassNode()
    winNode := PassNode()

    sut := ModifierNodes(ctrlNode, altNode, shiftNode, winNode)
    sut.Reset()
    ctrlNode.Update(true)

    Assert.False(sut.std.GetState(),            "std should be false when ctrl pressed")
    Assert.False(sut.shift.GetState(),          "shift should be false")
    Assert.True(sut.ctrl.GetState(),            "ctrl should be true when only ctrl pressed")
    Assert.False(sut.win.GetState(),            "win should be false")
    Assert.False(sut.alt.GetState(),            "alt should be false")
    Assert.False(sut.ctrl_alt.GetState(),       "ctrl_alt should be false")
    Assert.False(sut.alt_shift.GetState(),      "alt_shift should be false")
    Assert.False(sut.ctrl_shift.GetState(),     "ctrl_shift should be false")
    Assert.False(sut.ctrl_alt_shift.GetState(), "ctrl_alt_shift should be false")
}
TestModifierNodesCtrlOnly()

TestModifierNodesAltOnly() {
    ctrlNode := PassNode()
    altNode := PassNode()
    shiftNode := PassNode()
    winNode := PassNode()

    sut := ModifierNodes(ctrlNode, altNode, shiftNode, winNode)
    sut.Reset()
    altNode.Update(true)

    Assert.False(sut.std.GetState(),            "std should be false when alt pressed")
    Assert.False(sut.shift.GetState(),          "shift should be false")
    Assert.False(sut.ctrl.GetState(),           "ctrl should be false")
    Assert.False(sut.win.GetState(),            "win should be false")
    Assert.True(sut.alt.GetState(),             "alt should be true when only alt pressed")
    Assert.False(sut.ctrl_alt.GetState(),       "ctrl_alt should be false")
    Assert.False(sut.alt_shift.GetState(),      "alt_shift should be false")
    Assert.False(sut.ctrl_shift.GetState(),     "ctrl_shift should be false")
    Assert.False(sut.ctrl_alt_shift.GetState(), "ctrl_alt_shift should be false")
}
TestModifierNodesAltOnly()

TestModifierNodesWinOnly() {
    ctrlNode := PassNode()
    altNode := PassNode()
    shiftNode := PassNode()
    winNode := PassNode()

    sut := ModifierNodes(ctrlNode, altNode, shiftNode, winNode)
    sut.Reset()
    winNode.Update(true)

    Assert.False(sut.std.GetState(),            "std should be false when win pressed")
    Assert.False(sut.shift.GetState(),          "shift should be false")
    Assert.False(sut.ctrl.GetState(),           "ctrl should be false")
    Assert.True(sut.win.GetState(),             "win should be true when only win pressed")
    Assert.False(sut.alt.GetState(),            "alt should be false")
    Assert.False(sut.ctrl_alt.GetState(),       "ctrl_alt should be false")
    Assert.False(sut.alt_shift.GetState(),      "alt_shift should be false")
    Assert.False(sut.ctrl_shift.GetState(),     "ctrl_shift should be false")
    Assert.False(sut.ctrl_alt_shift.GetState(), "ctrl_alt_shift should be false")
}
TestModifierNodesWinOnly()

TestModifierNodesCtrlAlt() {
    ctrlNode := PassNode()
    altNode := PassNode()
    shiftNode := PassNode()
    winNode := PassNode()

    sut := ModifierNodes(ctrlNode, altNode, shiftNode, winNode)
    sut.Reset()
    ctrlNode.Update(true)
    altNode.Update(true)

    Assert.False(sut.std.GetState(),            "std should be false")
    Assert.False(sut.shift.GetState(),          "shift should be false")
    Assert.False(sut.ctrl.GetState(),           "ctrl should be false")
    Assert.False(sut.win.GetState(),            "win should be false")
    Assert.False(sut.alt.GetState(),            "alt should be false")
    Assert.True(sut.ctrl_alt.GetState(),        "ctrl_alt should be true when ctrl and alt pressed")
    Assert.False(sut.alt_shift.GetState(),      "alt_shift should be false")
    Assert.False(sut.ctrl_shift.GetState(),     "ctrl_shift should be false")
    Assert.False(sut.ctrl_alt_shift.GetState(), "ctrl_alt_shift should be false")
}
TestModifierNodesCtrlAlt()

TestModifierNodesAltShift() {
    ctrlNode := PassNode()
    altNode := PassNode()
    shiftNode := PassNode()
    winNode := PassNode()

    sut := ModifierNodes(ctrlNode, altNode, shiftNode, winNode)
    sut.Reset()
    altNode.Update(true)
    shiftNode.Update(true)

    Assert.False(sut.std.GetState(),            "std should be false")
    Assert.False(sut.shift.GetState(),          "shift should be false")
    Assert.False(sut.ctrl.GetState(),           "ctrl should be false")
    Assert.False(sut.win.GetState(),            "win should be false")
    Assert.False(sut.alt.GetState(),            "alt should be false")
    Assert.False(sut.ctrl_alt.GetState(),       "ctrl_alt should be false")
    Assert.True(sut.alt_shift.GetState(),       "alt_shift should be true when alt and shift pressed")
    Assert.False(sut.ctrl_shift.GetState(),     "ctrl_shift should be false")
    Assert.False(sut.ctrl_alt_shift.GetState(), "ctrl_alt_shift should be false")
}
TestModifierNodesAltShift()

TestModifierNodesCtrlShift() {
    ctrlNode := PassNode()
    altNode := PassNode()
    shiftNode := PassNode()
    winNode := PassNode()

    sut := ModifierNodes(ctrlNode, altNode, shiftNode, winNode)
    sut.Reset()
    ctrlNode.Update(true)
    shiftNode.Update(true)

    Assert.False(sut.std.GetState(),            "std should be false")
    Assert.False(sut.shift.GetState(),          "shift should be false")
    Assert.False(sut.ctrl.GetState(),           "ctrl should be false")
    Assert.False(sut.win.GetState(),            "win should be false")
    Assert.False(sut.alt.GetState(),            "alt should be false")
    Assert.False(sut.ctrl_alt.GetState(),       "ctrl_alt should be false")
    Assert.False(sut.alt_shift.GetState(),      "alt_shift should be false")
    Assert.True(sut.ctrl_shift.GetState(),      "ctrl_shift should be true when ctrl and shift pressed")
    Assert.False(sut.ctrl_alt_shift.GetState(), "ctrl_alt_shift should be false")
}
TestModifierNodesCtrlShift()

TestModifierNodesCtrlAltShift() {
    ctrlNode := PassNode()
    altNode := PassNode()
    shiftNode := PassNode()
    winNode := PassNode()

    sut := ModifierNodes(ctrlNode, altNode, shiftNode, winNode)
    sut.Reset()
    ctrlNode.Update(true)
    altNode.Update(true)
    shiftNode.Update(true)

    Assert.False(sut.std.GetState(),            "std should be false")
    Assert.False(sut.shift.GetState(),          "shift should be false")
    Assert.False(sut.ctrl.GetState(),           "ctrl should be false")
    Assert.False(sut.win.GetState(),            "win should be false")
    Assert.False(sut.alt.GetState(),            "alt should be false")
    Assert.False(sut.ctrl_alt.GetState(),       "ctrl_alt should be false")
    Assert.False(sut.alt_shift.GetState(),      "alt_shift should be false")
    Assert.False(sut.ctrl_shift.GetState(),     "ctrl_shift should be false")
    Assert.True(sut.ctrl_alt_shift.GetState(),  "ctrl_alt_shift should be true when ctrl, alt and shift pressed")
}
TestModifierNodesCtrlAltShift()

TestModifierNodesReset() {
    ctrlNode := PassNode()
    altNode := PassNode()
    shiftNode := PassNode()
    winNode := PassNode()

    sut := ModifierNodes(ctrlNode, altNode, shiftNode, winNode)
    ctrlNode.Update(true)
    altNode.Update(true)

    ; Contract: source nodes must be reset before calling Reset() — same as production (fkn.Reset() then modNodes.Reset())
    ctrlNode.Update(false)
    altNode.Update(false)
    sut.Reset()

    Assert.True(sut.std.GetState(),       "std should be true after Reset")
    Assert.False(sut.ctrl.GetState(),     "ctrl should be false after Reset")
    Assert.False(sut.alt.GetState(),      "alt should be false after Reset")
    Assert.False(sut.ctrl_alt.GetState(), "ctrl_alt should be false after Reset")
}
TestModifierNodesReset()

TestModifierNodesEnableShowStateOnChange() {
    ; Smoke test: registering callbacks must not throw
    ctrlNode := PassNode()
    altNode := PassNode()
    shiftNode := PassNode()
    winNode := PassNode()

    sut := ModifierNodes(ctrlNode, altNode, shiftNode, winNode)
    sut.EnableShowStateOnChange()
}
TestModifierNodesEnableShowStateOnChange()

; ─── GatedModifierNodes ───────────────────────────────────────────────────────

TestGatedModifierNodesGetState() {
    ctrlNode := PassNode()
    altNode := PassNode()
    shiftNode := PassNode()
    winNode := PassNode()
    controllerNode := PassNode()

    ; Create gated nodes BEFORE Reset so state propagates through the gate
    baseNodes := ModifierNodes(ctrlNode, altNode, shiftNode, winNode)
    sut := GatedModifierNodes(controllerNode, baseNodes)
    baseNodes.Reset()

    Assert.True(sut.std.GetState(),   "std should reflect underlying state (true)")
    Assert.False(sut.shift.GetState(), "shift should reflect underlying state (false)")

    ; GetState() tracks underlying even with gate closed
    shiftNode.Update(true)
    Assert.False(sut.std.GetState(),  "std should reflect underlying change (false)")
    Assert.True(sut.shift.GetState(), "shift should reflect underlying change (true)")
}
TestGatedModifierNodesGetState()

TestGatedModifierNodesSubscriberNotNotifiedWhenClosed() {
    ctrlNode := PassNode()
    altNode := PassNode()
    shiftNode := PassNode()
    winNode := PassNode()
    controllerNode := PassNode()

    baseNodes := ModifierNodes(ctrlNode, altNode, shiftNode, winNode)
    sut := GatedModifierNodes(controllerNode, baseNodes)
    baseNodes.Reset()

    counter := 0
    OnStdChange(s) {
        counter++
    }
    sut.std.Subscribe((s) => OnStdChange(s))

    ; Gate closed: underlying change must not notify subscriber
    shiftNode.Update(true)
    Assert.Equal(counter, 0, "Subscriber must not be notified when gate is closed")
}
TestGatedModifierNodesSubscriberNotNotifiedWhenClosed()

TestGatedModifierNodesSubscriberNotifiedWhenOpen() {
    ctrlNode := PassNode()
    altNode := PassNode()
    shiftNode := PassNode()
    winNode := PassNode()
    controllerNode := PassNode()

    baseNodes := ModifierNodes(ctrlNode, altNode, shiftNode, winNode)
    sut := GatedModifierNodes(controllerNode, baseNodes)
    baseNodes.Reset()

    counter := 0
    OnStdChange(s) {
        counter++
    }
    sut.std.Subscribe((s) => OnStdChange(s))

    shiftNode.Update(true)   ; gate closed, no notification
    controllerNode.Update(true) ; open gate
    shiftNode.Update(false)  ; gate open, std becomes true → subscriber fires
    Assert.Equal(counter, 1, "Subscriber must be notified when gate is open")
}
TestGatedModifierNodesSubscriberNotifiedWhenOpen()

TestGatedModifierNodesReset() {
    ctrlNode := PassNode()
    altNode := PassNode()
    shiftNode := PassNode()
    winNode := PassNode()
    controllerNode := PassNode()

    baseNodes := ModifierNodes(ctrlNode, altNode, shiftNode, winNode)
    sut := GatedModifierNodes(controllerNode, baseNodes)
    baseNodes.Reset()
    ctrlNode.Update(true)

    sut.Reset()

    Assert.True(sut.std.GetState(),   "std should be true after gated Reset")
    Assert.False(sut.ctrl.GetState(), "ctrl should be false after gated Reset")
}
TestGatedModifierNodesReset()
