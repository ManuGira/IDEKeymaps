#Requires AutoHotkey v2.0

#Include Assert.ahk
#Include ../Layouts/KeyboardLayout.ahk

TestKeyboardLayout_Load() {
    sut := KeyboardLayout("Layouts/azerty.json")

    ; KeyMap should be populated
    Assert.True(sut.KeyMap.Count > 0, "KeyMap should not be empty after loading")
}
TestKeyboardLayout_Load()

TestKeyboardLayout_Get() {
    sut := KeyboardLayout("Layouts/azerty.json")

    ; KeyE -> ["e", "E", "€"]  (SC012)
    Assert.Equal(sut.Get("SC012", false, false), "e",  "KeyE normal should be 'e'")
    Assert.Equal(sut.Get("SC012", true,  false), "E",  "KeyE shift should be 'E'")
    Assert.Equal(sut.Get("SC012", false, true),  "€",  "KeyE altgr should be '€'")

    ; Digit1 -> ["&", "1"]  (SC002)
    Assert.Equal(sut.Get("SC002", false, false), "&", "Digit1 normal should be '&'")
    Assert.Equal(sut.Get("SC002", true,  false), "1", "Digit1 shift should be '1'")

    ; Digit2 -> ["é", "2", "~"]  (SC003)
    Assert.Equal(sut.Get("SC003", false, false), "é", "Digit2 normal should be 'é'")
    Assert.Equal(sut.Get("SC003", true,  false), "2", "Digit2 shift should be '2'")
    Assert.Equal(sut.Get("SC003", false, true),  "~", "Digit2 altgr should be '~'")

    ; Unknown scan code
    Assert.Equal(sut.Get("SC999", false, false), "", "Unknown scan code should return ''")

    ; Shift+AltGr on a key with only 2 values falls back to shift  (SC002: ["&","1"])
    Assert.Equal(sut.Get("SC002", true, true), "1", "Shift+AltGr fallback should return shift value")
}
TestKeyboardLayout_Get()

TestKeyboardLayout_DeadKey() {
    sut := KeyboardLayout("Layouts/azerty.json")

    ; BracketLeft -> ["*^", "*¨"]  (SC01A)
    Assert.Equal(sut.Get("SC01A", false, false), "*^", "BracketLeft normal should be dead key '*^'")
    Assert.Equal(sut.Get("SC01A", true,  false), "*¨", "BracketLeft shift should be dead key '*¨'")
}
TestKeyboardLayout_DeadKey()
