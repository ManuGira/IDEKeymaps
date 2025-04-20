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

TestUnixToWindows() {
    Assert.Equal(PathConverter.UnixToWindows("/c/Users/Moi/test"), "C:\Users\Moi\test")
    Assert.Equal(PathConverter.UnixToWindows("/c/Users/Moi\ et\ toi/test"), "C:\Users\Moi et toi\test")
    Assert.Equal(PathConverter.UnixToWindows("/Users/Moi/test"), "\Users\Moi\test")
    Assert.Equal(PathConverter.UnixToWindows("Users/Moi/test"), "Users\Moi\test")
    Assert.Equal(PathConverter.UnixToWindows("./Users/Moi/test"), ".\Users\Moi\test")
}
TestUnixToWindows()

TestWindowsToUnix() {
    Assert.Equal(PathConverter.WindowsToUnix("C:\Users\Moi\test"), "/c/Users/Moi/test")
    Assert.Equal(PathConverter.WindowsToUnix("C:\Users\Moi et toi\test"), "/c/Users/Moi\ et\ toi/test")
    Assert.Equal(PathConverter.WindowsToUnix("\Users\Moi\test"), "/Users/Moi/test")
    Assert.Equal(PathConverter.WindowsToUnix("Users\Moi\test"), "Users/Moi/test")
    Assert.Equal(PathConverter.WindowsToUnix(".\Users\Moi\test"), "./Users/Moi/test")
}
TestWindowsToUnix()
