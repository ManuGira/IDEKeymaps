#Requires AutoHotkey v2.0

#Include Assert.ahk
#Include ../Layouts/QWERTZ.ahk

; Test row lengths
Assert.Equal(StrLen(QWERTZ.Std[1]), 13)
Assert.Equal(StrLen(QWERTZ.Std[2]), 12)
Assert.Equal(StrLen(QWERTZ.Std[3]), 12)
Assert.Equal(StrLen(QWERTZ.Std[4]), 11)

shift := true
altGr := true
notShift := false
notAltGr := false

; Test that the qwertz layout is correctly mapped
Assert.Equal(QWERTZ.Get("SC029", notShift, notAltGr), "§")
Assert.Equal(QWERTZ.Get("SC002", notShift, notAltGr), "1")
Assert.Equal(QWERTZ.Get("SC012", notShift, notAltGr), "e")
Assert.Equal(QWERTZ.Get("SC01E", notShift, notAltGr), "a")

; Shift
Assert.Equal(QWERTZ.Get("SC029", shift, notAltGr), "°")
Assert.Equal(QWERTZ.Get("SC002", shift, notAltGr), "+")
Assert.Equal(QWERTZ.Get("SC012", shift, notAltGr), "E")
Assert.Equal(QWERTZ.Get("SC01E", shift, notAltGr), "A")


; AltGr
shift := false
altGr := true
Assert.Equal(QWERTZ.Get("SC029", notShift, altGr), "")
Assert.Equal(QWERTZ.Get("SC002", notShift, altGr), "¦")
Assert.Equal(QWERTZ.Get("SC012", notShift, altGr), "€")
Assert.Equal(QWERTZ.Get("SC01E", notShift, altGr), "")

; Shift + AltGr (should return empty string as it's not defined)
shift := true
altGr := true
Assert.Equal(QWERTZ.Get("SC029", shift, altGr), "")
Assert.Equal(QWERTZ.Get("SC012", shift, altGr), "")
Assert.Equal(QWERTZ.Get("SC01E", shift, altGr), "")



; Test top row of characters
for i, char in ["q", "w", "e", "r", "t", "z", "u", "i", "o", "p", "è", "¨"]{
    scanCode := ScanCodes.KeyMatrix[2][i]
    Assert.Equal(QWERTZ.Get(scanCode, notShift, notAltGr), char)
}
