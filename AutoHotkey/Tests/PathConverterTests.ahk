#Requires AutoHotkey v2.0

#Include Assert.ahk
#Include ../Utils/PathConverter.ahk

TestGuessPathType() {
    windows := "Windows"
    unix := "Unix"
    unknown := "Unknown"

    Assert.Equal(PathConverter.GuessPathType("C:\Users\Moi\test"), windows)
    Assert.Equal(PathConverter.GuessPathType("C:/Users/Moi/test"), windows)
    Assert.Equal(PathConverter.GuessPathType("C:\Users\Moi\ et\ toi/test"), windows)
    Assert.Equal(PathConverter.GuessPathType("Users\Moi\test"), windows)
    Assert.Equal(PathConverter.GuessPathType(".\Users\Moi\test"), windows)
    
    Assert.Equal(PathConverter.GuessPathType("/c/Users/Moi/test"), unix)
    Assert.Equal(PathConverter.GuessPathType("/c/Users/Moi\ et\ toi/test"), unix)
    Assert.Equal(PathConverter.GuessPathType("/Users/Moi/test"), unix)
    Assert.Equal(PathConverter.GuessPathType("Users/Moi/test"), unix)
    Assert.Equal(PathConverter.GuessPathType("./Users/Moi/test"), unix)

    Assert.Equal(PathConverter.GuessPathType("test"), unknown)
}
TestGuessPathType()