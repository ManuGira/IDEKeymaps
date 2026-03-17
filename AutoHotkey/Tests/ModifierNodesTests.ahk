#Requires AutoHotkey v2.0

#Include Assert.ahk
#Include ../Nodes/include.ahk
#Include ../Utils/Utils.ahk
#Include ../Utils/ModifierNodes.ahk

; ─── ModifierNodes ────────────────────────────────────────────────────────────

TestModifierNodesAfterReset() {
    ctrlKey := PassNode()
    altKey := PassNode()
    shiftKey := PassNode()
    winKey := PassNode()

    sut := ModifierNodes(ctrlKey, altKey, shiftKey, winKey)
    sut.Reset()

    Assert.True(sut.GetState({ctrl:false, alt:false, shift:false, win:false}),  "std should be true after Reset")
    Assert.False(sut.GetState({ctrl:false, alt:false, shift:true,  win:false}), "shift should be false after Reset")
    Assert.False(sut.GetState({ctrl:true,  alt:false, shift:false, win:false}), "ctrl should be false after Reset")
    Assert.False(sut.GetState({ctrl:false, alt:false, shift:false, win:true}),  "win should be false after Reset")
    Assert.False(sut.GetState({ctrl:false, alt:true,  shift:false, win:false}), "alt should be false after Reset")
    Assert.False(sut.GetState({ctrl:true,  alt:true,  shift:false, win:false}), "ctrl_alt should be false after Reset")
    Assert.False(sut.GetState({ctrl:false, alt:true,  shift:true,  win:false}), "alt_shift should be false after Reset")
    Assert.False(sut.GetState({ctrl:true,  alt:false, shift:true,  win:false}), "ctrl_shift should be false after Reset")
    Assert.False(sut.GetState({ctrl:true,  alt:true,  shift:true,  win:false}), "ctrl_alt_shift should be false after Reset")
}
TestModifierNodesAfterReset()

TestModifierNodesShiftOnly() {
    ctrlKey := PassNode()
    altKey := PassNode()
    shiftKey := PassNode()
    winKey := PassNode()

    sut := ModifierNodes(ctrlKey, altKey, shiftKey, winKey)
    sut.Reset()
    shiftKey.Update(true)

    Assert.False(sut.GetState({ctrl:false, alt:false, shift:false, win:false}), "std should be false when shift pressed")
    Assert.True(sut.GetState({ctrl:false, alt:false, shift:true,  win:false}),  "shift should be true when only shift pressed")
    Assert.False(sut.GetState({ctrl:true,  alt:false, shift:false, win:false}), "ctrl should be false")
    Assert.False(sut.GetState({ctrl:false, alt:false, shift:false, win:true}),  "win should be false")
    Assert.False(sut.GetState({ctrl:false, alt:true,  shift:false, win:false}), "alt should be false")
    Assert.False(sut.GetState({ctrl:true,  alt:true,  shift:false, win:false}), "ctrl_alt should be false")
    Assert.False(sut.GetState({ctrl:false, alt:true,  shift:true,  win:false}), "alt_shift should be false")
    Assert.False(sut.GetState({ctrl:true,  alt:false, shift:true,  win:false}), "ctrl_shift should be false")
    Assert.False(sut.GetState({ctrl:true,  alt:true,  shift:true,  win:false}), "ctrl_alt_shift should be false")
}
TestModifierNodesShiftOnly()

TestModifierNodesCtrlOnly() {
    ctrlKey := PassNode()
    altKey := PassNode()
    shiftKey := PassNode()
    winKey := PassNode()

    sut := ModifierNodes(ctrlKey, altKey, shiftKey, winKey)
    sut.Reset()
    ctrlKey.Update(true)

    Assert.False(sut.GetState({ctrl:false, alt:false, shift:false, win:false}), "std should be false when ctrl pressed")
    Assert.False(sut.GetState({ctrl:false, alt:false, shift:true,  win:false}), "shift should be false")
    Assert.True(sut.GetState({ctrl:true,  alt:false, shift:false, win:false}),  "ctrl should be true when only ctrl pressed")
    Assert.False(sut.GetState({ctrl:false, alt:false, shift:false, win:true}),  "win should be false")
    Assert.False(sut.GetState({ctrl:false, alt:true,  shift:false, win:false}), "alt should be false")
    Assert.False(sut.GetState({ctrl:true,  alt:true,  shift:false, win:false}), "ctrl_alt should be false")
    Assert.False(sut.GetState({ctrl:false, alt:true,  shift:true,  win:false}), "alt_shift should be false")
    Assert.False(sut.GetState({ctrl:true,  alt:false, shift:true,  win:false}), "ctrl_shift should be false")
    Assert.False(sut.GetState({ctrl:true,  alt:true,  shift:true,  win:false}), "ctrl_alt_shift should be false")
}
TestModifierNodesCtrlOnly()

TestModifierNodesAltOnly() {
    ctrlKey := PassNode()
    altKey := PassNode()
    shiftKey := PassNode()
    winKey := PassNode()

    sut := ModifierNodes(ctrlKey, altKey, shiftKey, winKey)
    sut.Reset()
    altKey.Update(true)

    Assert.False(sut.GetState({ctrl:false, alt:false, shift:false, win:false}), "std should be false when alt pressed")
    Assert.False(sut.GetState({ctrl:false, alt:false, shift:true,  win:false}), "shift should be false")
    Assert.False(sut.GetState({ctrl:true,  alt:false, shift:false, win:false}), "ctrl should be false")
    Assert.False(sut.GetState({ctrl:false, alt:false, shift:false, win:true}),  "win should be false")
    Assert.True(sut.GetState({ctrl:false, alt:true,  shift:false, win:false}),  "alt should be true when only alt pressed")
    Assert.False(sut.GetState({ctrl:true,  alt:true,  shift:false, win:false}), "ctrl_alt should be false")
    Assert.False(sut.GetState({ctrl:false, alt:true,  shift:true,  win:false}), "alt_shift should be false")
    Assert.False(sut.GetState({ctrl:true,  alt:false, shift:true,  win:false}), "ctrl_shift should be false")
    Assert.False(sut.GetState({ctrl:true,  alt:true,  shift:true,  win:false}), "ctrl_alt_shift should be false")
}
TestModifierNodesAltOnly()

TestModifierNodesWinOnly() {
    ctrlKey := PassNode()
    altKey := PassNode()
    shiftKey := PassNode()
    winKey := PassNode()

    sut := ModifierNodes(ctrlKey, altKey, shiftKey, winKey)
    sut.Reset()
    winKey.Update(true)

    Assert.False(sut.GetState({ctrl:false, alt:false, shift:false, win:false}), "std should be false when win pressed")
    Assert.False(sut.GetState({ctrl:false, alt:false, shift:true,  win:false}), "shift should be false")
    Assert.False(sut.GetState({ctrl:true,  alt:false, shift:false, win:false}), "ctrl should be false")
    Assert.True(sut.GetState({ctrl:false, alt:false, shift:false, win:true}),   "win should be true when only win pressed")
    Assert.False(sut.GetState({ctrl:false, alt:true,  shift:false, win:false}), "alt should be false")
    Assert.False(sut.GetState({ctrl:true,  alt:true,  shift:false, win:false}), "ctrl_alt should be false")
    Assert.False(sut.GetState({ctrl:false, alt:true,  shift:true,  win:false}), "alt_shift should be false")
    Assert.False(sut.GetState({ctrl:true,  alt:false, shift:true,  win:false}), "ctrl_shift should be false")
    Assert.False(sut.GetState({ctrl:true,  alt:true,  shift:true,  win:false}), "ctrl_alt_shift should be false")
}
TestModifierNodesWinOnly()

TestModifierNodesCtrlAlt() {
    ctrlKey := PassNode()
    altKey := PassNode()
    shiftKey := PassNode()
    winKey := PassNode()

    sut := ModifierNodes(ctrlKey, altKey, shiftKey, winKey)
    sut.Reset()
    ctrlKey.Update(true)
    altKey.Update(true)

    Assert.False(sut.GetState({ctrl:false, alt:false, shift:false, win:false}), "std should be false")
    Assert.False(sut.GetState({ctrl:false, alt:false, shift:true,  win:false}), "shift should be false")
    Assert.False(sut.GetState({ctrl:true,  alt:false, shift:false, win:false}), "ctrl should be false")
    Assert.False(sut.GetState({ctrl:false, alt:false, shift:false, win:true}),  "win should be false")
    Assert.False(sut.GetState({ctrl:false, alt:true,  shift:false, win:false}), "alt should be false")
    Assert.True(sut.GetState({ctrl:true,  alt:true,  shift:false, win:false}),  "ctrl_alt should be true when ctrl and alt pressed")
    Assert.False(sut.GetState({ctrl:false, alt:true,  shift:true,  win:false}), "alt_shift should be false")
    Assert.False(sut.GetState({ctrl:true,  alt:false, shift:true,  win:false}), "ctrl_shift should be false")
    Assert.False(sut.GetState({ctrl:true,  alt:true,  shift:true,  win:false}), "ctrl_alt_shift should be false")
}
TestModifierNodesCtrlAlt()

TestModifierNodesAltShift() {
    ctrlKey := PassNode()
    altKey := PassNode()
    shiftKey := PassNode()
    winKey := PassNode()

    sut := ModifierNodes(ctrlKey, altKey, shiftKey, winKey)
    sut.Reset()
    altKey.Update(true)
    shiftKey.Update(true)

    Assert.False(sut.GetState({ctrl:false, alt:false, shift:false, win:false}), "std should be false")
    Assert.False(sut.GetState({ctrl:false, alt:false, shift:true,  win:false}), "shift should be false")
    Assert.False(sut.GetState({ctrl:true,  alt:false, shift:false, win:false}), "ctrl should be false")
    Assert.False(sut.GetState({ctrl:false, alt:false, shift:false, win:true}),  "win should be false")
    Assert.False(sut.GetState({ctrl:false, alt:true,  shift:false, win:false}), "alt should be false")
    Assert.False(sut.GetState({ctrl:true,  alt:true,  shift:false, win:false}), "ctrl_alt should be false")
    Assert.True(sut.GetState({ctrl:false, alt:true,  shift:true,  win:false}),  "alt_shift should be true when alt and shift pressed")
    Assert.False(sut.GetState({ctrl:true,  alt:false, shift:true,  win:false}), "ctrl_shift should be false")
    Assert.False(sut.GetState({ctrl:true,  alt:true,  shift:true,  win:false}), "ctrl_alt_shift should be false")
}
TestModifierNodesAltShift()

TestModifierNodesCtrlShift() {
    ctrlKey := PassNode()
    altKey := PassNode()
    shiftKey := PassNode()
    winKey := PassNode()

    sut := ModifierNodes(ctrlKey, altKey, shiftKey, winKey)
    sut.Reset()
    ctrlKey.Update(true)
    shiftKey.Update(true)

    Assert.False(sut.GetState({ctrl:false, alt:false, shift:false, win:false}), "std should be false")
    Assert.False(sut.GetState({ctrl:false, alt:false, shift:true,  win:false}), "shift should be false")
    Assert.False(sut.GetState({ctrl:true,  alt:false, shift:false, win:false}), "ctrl should be false")
    Assert.False(sut.GetState({ctrl:false, alt:false, shift:false, win:true}),  "win should be false")
    Assert.False(sut.GetState({ctrl:false, alt:true,  shift:false, win:false}), "alt should be false")
    Assert.False(sut.GetState({ctrl:true,  alt:true,  shift:false, win:false}), "ctrl_alt should be false")
    Assert.False(sut.GetState({ctrl:false, alt:true,  shift:true,  win:false}), "alt_shift should be false")
    Assert.True(sut.GetState({ctrl:true,  alt:false, shift:true,  win:false}),  "ctrl_shift should be true when ctrl and shift pressed")
    Assert.False(sut.GetState({ctrl:true,  alt:true,  shift:true,  win:false}), "ctrl_alt_shift should be false")
}
TestModifierNodesCtrlShift()

TestModifierNodesCtrlAltShift() {
    ctrlKey := PassNode()
    altKey := PassNode()
    shiftKey := PassNode()
    winKey := PassNode()

    sut := ModifierNodes(ctrlKey, altKey, shiftKey, winKey)
    sut.Reset()
    ctrlKey.Update(true)
    altKey.Update(true)
    shiftKey.Update(true)

    Assert.False(sut.GetState({ctrl:false, alt:false, shift:false, win:false}), "void modifier should be false")
    Assert.False(sut.GetState({ctrl:false, alt:false, shift:true,  win:false}), "shift modifier should be false")
    Assert.False(sut.GetState({ctrl:true,  alt:false, shift:false, win:false}), "ctrl modifier should be false")
    Assert.False(sut.GetState({ctrl:false, alt:false, shift:false, win:true }), "win modifier should be false")
    Assert.False(sut.GetState({ctrl:false, alt:true,  shift:false, win:false}), "alt modifier should be false")
    Assert.False(sut.GetState({ctrl:true,  alt:true,  shift:false, win:false}), "ctrl+alt modifier should be false")
    Assert.False(sut.GetState({ctrl:false, alt:true,  shift:true,  win:false}), "alt+shift modifier should be false")
    Assert.False(sut.GetState({ctrl:true,  alt:false, shift:true,  win:false}), "ctrl+shift modifier should be false")
    Assert.True(sut.GetState({ ctrl:true,  alt:true,  shift:true,  win:false}), "ctrl+alt+shift modifier should be true when ctrl, alt and shift pressed")
}
TestModifierNodesCtrlAltShift()

TestModifierNodesReset() {
    ctrlKey := PassNode()
    altKey := PassNode()
    shiftKey := PassNode()
    winKey := PassNode()

    sut := ModifierNodes(ctrlKey, altKey, shiftKey, winKey)
    ctrlKey.Update(true)
    altKey.Update(true)

    ; Contract: source nodes must be reset before calling Reset() — same as production (fkn.Reset() then modNodes.Reset())
    ctrlKey.Update(false)
    altKey.Update(false)
    sut.Reset()

    Assert.True(sut.GetState({ctrl:false, alt:false, shift:false, win:false}),  "void modifier should be true after Reset")
    Assert.False(sut.GetState({ctrl:true,  alt:false, shift:false, win:false}), "ctrl modifier should be false after Reset")
    Assert.False(sut.GetState({ctrl:false, alt:true,  shift:false, win:false}), "alt modifier should be false after Reset")
    Assert.False(sut.GetState({ctrl:true,  alt:true,  shift:false, win:false}), "ctrl+alt modifier should be false after Reset")
}
TestModifierNodesReset()
