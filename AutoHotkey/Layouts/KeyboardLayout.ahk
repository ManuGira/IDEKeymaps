#Requires AutoHotkey v2.0

#Include ..\ThirdParty\_JXON.ahk
#Include ScanCodes.ahk

class KeyboardLayout {
    ; Map from scan code (e.g. "SC012") to value array (e.g. ["e", "E", "€"])
    ; Index 1 = normal, 2 = shift, 3 = altgr, 4 = shift+altgr
    KeyMap := Map()

    __New(jsonFilePath) {
        jsonStr := FileRead(jsonFilePath, "UTF-8")
        data := Jxon_Load(&jsonStr)

        ; Build KeyMap: scan code -> value array
        for qwertyName, values in data["keymap"] {
            if ScanCodes.QWERTYReverseMap.Has(qwertyName)
                this.KeyMap[ScanCodes.QWERTYReverseMap[qwertyName]] := values
        }
    }

    ; Returns the symbol for the given scan code and modifier state.
    ; May return a dead key marker (e.g. "*^") if the key is a dead key.
    ; Returns "" if the scan code is not in the layout or the modifier
    ; combination has no mapping.
    Get(scanCode, shift:=false, altGr:=false) {
        if !this.KeyMap.Has(scanCode)
            return ""

        values := this.KeyMap[scanCode]

        if altGr && shift && values.Length >= 4
            return values[4]
        if altGr && values.Length >= 3
            return values[3]
        if shift && values.Length >= 2
            return values[2]
        return values[1]
    }
}
