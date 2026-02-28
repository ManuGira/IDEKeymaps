#Requires AutoHotkey v2.0

#Include Assert.ahk
#Include ../Layouts/ScanCodes.ahk

; Test row lengths for ISO layout
Assert.Equal(ScanCodes.KeyMatrix[1].Length, 13)
Assert.Equal(ScanCodes.KeyMatrix[2].Length, 12)
Assert.Equal(ScanCodes.KeyMatrix[3].Length, 12)
Assert.Equal(ScanCodes.KeyMatrix[4].Length, 11)

; Test row, col to scan code mapping
Assert.Equal(ScanCodes.KeyMatrix[1][1], "SC029") ; §
Assert.Equal(ScanCodes.KeyMatrix[1][2], "SC002") ; 1
Assert.Equal(ScanCodes.KeyMatrix[1][3], "SC003") ; 2
Assert.Equal(ScanCodes.KeyMatrix[2][1], "SC010") ; Q
Assert.Equal(ScanCodes.KeyMatrix[3][1], "SC01E") ; A
Assert.Equal(ScanCodes.KeyMatrix[4][1], "SC056") ; <
Assert.Equal(ScanCodes.KeyMatrix[4][2], "SC02C") ; Y

; Test GetRowCol function
Assert.EqualArray(ScanCodes.GetRowCol("SC029"), [1, 1])  ; §
Assert.EqualArray(ScanCodes.GetRowCol("SC002"), [1, 2])  ; 1
Assert.EqualArray(ScanCodes.GetRowCol("SC003"), [1, 3])  ; 2
Assert.EqualArray(ScanCodes.GetRowCol("SC010"), [2, 1])  ; Q
Assert.EqualArray(ScanCodes.GetRowCol("SC01E"), [3, 1])  ; A
Assert.EqualArray(ScanCodes.GetRowCol("SC056"), [4, 1])  ; <
Assert.EqualArray(ScanCodes.GetRowCol("SC02C"), [4, 2])  ; Y

; Test ScanCode to QWERTY mapping
Assert.Equal(ScanCodes.QWERTYMap["SC029"], "Backquote")  ; §
Assert.Equal(ScanCodes.QWERTYMap["SC002"], "Digit1")     ; 1
Assert.Equal(ScanCodes.QWERTYMap["SC003"], "Digit2")     ; 2

