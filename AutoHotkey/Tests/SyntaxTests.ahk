#Requires AutoHotkey v2.0

#Include Assert.ahk


myVar  := unset
Assert.False(IsSet(myVar), "myVar must be unset")
myVar := 1
Assert.True(IsSet(myVar), "myVar must be set")

