#Requires AutoHotkey v2.0

try {
    #Include Tests/AHKTests.ahk
    
    #Include Tests/DictTests.ahk
    #Include Tests/TimeStampTests.ahk
    #Include Tests/NodesTests.ahk
    #Include Tests/PathConverterTests.ahk
    #Include Tests/CaseConverterTests.ahk
    
    #Include Tests/ScanCodesTests.ahk
    #Include Tests/QWERTZTest.ahk

    ExitApp 0
} catch Error as e {
    ExitApp 1
}
