#Requires AutoHotkey v2.0

try {
    FileAppend "Running TimeStampTests`n", "*"
    #Include Tests/TimeStampTests.ahk
    FileAppend "Running NodesTests`n", "*"
    #Include Tests/NodesTests.ahk
    FileAppend "Running PathConverterTests`n", "*"
    #Include Tests/PathConverterTests.ahk
    FileAppend "Running CaseConverterTests`n", "*"
    #Include Tests/CaseConverterTests.ahk
    FileAppend "All tests passed`n", "*"
    ExitApp 0
} catch Error as e {
    FileAppend "Test failed: " . e.Message . "`n", "*"
    ExitApp 1
}