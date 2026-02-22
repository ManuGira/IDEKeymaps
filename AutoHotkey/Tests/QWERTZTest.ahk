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
Assert.Equal(QWERTZ.Get(1, 1, notShift, notAltGr, ""), "§")
Assert.Equal(QWERTZ.Get(1, 2, notShift, notAltGr, ""), "1")
Assert.Equal(QWERTZ.Get(2, 3, notShift, notAltGr, ""), "e")
Assert.Equal(QWERTZ.Get(3, 1, notShift, notAltGr, ""), "a")

; Shift
Assert.Equal(QWERTZ.Get(1, 1, shift, notAltGr, ""), "°")
Assert.Equal(QWERTZ.Get(1, 2, shift, notAltGr, ""), "+")
Assert.Equal(QWERTZ.Get(2, 3, shift, notAltGr, ""), "E")
Assert.Equal(QWERTZ.Get(3, 1, shift, notAltGr, ""), "A")


; AltGr
shift := false
altGr := true
Assert.Equal(QWERTZ.Get(1, 1, notShift, altGr, ""), "")
Assert.Equal(QWERTZ.Get(1, 2, notShift, altGr, ""), "¦")
Assert.Equal(QWERTZ.Get(2, 3, notShift, altGr, ""), "€")
Assert.Equal(QWERTZ.Get(3, 1, notShift, altGr, ""), "")

; Shift + AltGr (should return empty string as it's not defined)
shift := true
altGr := true
Assert.Equal(QWERTZ.Get(1, 1, shift, altGr, ""), "")
Assert.Equal(QWERTZ.Get(2, 3, shift, altGr, ""), "")
Assert.Equal(QWERTZ.Get(3, 1, shift, altGr, ""), "")

; Dead key 
Assert.Equal(QWERTZ.Get(2, 3, notShift, notAltGr, "^"), "ê")
Assert.Equal(QWERTZ.Get(3, 1, notShift, notAltGr, "^"), "â")
Assert.Equal(QWERTZ.Get(2, 3, shift, notAltGr, "^"), "Ê")
Assert.Equal(QWERTZ.Get(2, 3, notShift, altGr, "^"), "^€")
Assert.Equal(QWERTZ.Get(3, 1, notShift, altGr, "^"), "")
Assert.Equal(QWERTZ.Get(1, 13, notShift, notAltGr, "^"), "^^")

; Test top row of characters
for i, char in ["q", "w", "e", "r", "t", "z", "u", "i", "o", "p", "è", "¨"]
    Assert.Equal(QWERTZ.Get(2, i, notShift, notAltGr, ""), char)

