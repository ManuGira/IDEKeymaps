#Requires AutoHotkey v2.0

class ScanCodes{
    ; ISO Keyboard layout matrix (1-based indexing)
    ; Row 1: Number row, Row 2: QWERTY, Row 3: ASDF, Row 4: ZXCV
    static KeyMatrix := [
        ; Row 1 - §1234567890'^ Number row (13 keys)
        ["SC029", "SC002", "SC003", "SC004", "SC005", "SC006", "SC007", "SC008", "SC009", "SC00A", "SC00B", "SC00C", "SC00D"],
        ; Row 2 - QWERTY row (12 keys)
                 ["SC010", "SC011", "SC012", "SC013", "SC014", "SC015", "SC016", "SC017", "SC018", "SC019", "SC01A", "SC01B"],
        ; Row 3 - ASDF row (12 keys)
                 ["SC01E", "SC01F", "SC020", "SC021", "SC022", "SC023", "SC024", "SC025", "SC026", "SC027", "SC028", "SC02B"],
        ; Row 4 - <ZXCV row (11 keys)
        ["SC056", "SC02C", "SC02D", "SC02E", "SC02F", "SC030", "SC031", "SC032", "SC033", "SC034", "SC035"]
    ]

    static GetRowCol(scanCode) {
        for rowIndex, row in ScanCodes.KeyMatrix {
            for colIndex, code in row {
                if (code = scanCode) {
                    return [rowIndex, colIndex]
                }
            }
        }
        throw ValueError("Scan code not found: " scanCode)
    }
}