#Requires AutoHotkey v2.0

#Include ..\ThirdParty\_JXON.ahk
#Include ScanCodes.ahk

class KeyboardLayout {
    ; Map from scan code (e.g. "SC012") to value array (e.g. ["e", "E", "€"])
    ; Index 1 = normal, 2 = shift, 3 = altgr, 4 = shift+altgr
    KeyMap := Map()
    DeadKeyDict := Map()

    __New(jsonFilePath) {
        jsonStr := FileRead(jsonFilePath, "UTF-8")
        data := Jxon_Load(&jsonStr)

        ; Build KeyMap: scan code -> value array
        for qwertyName, values in data["keymap"] {
            scanCode := ScanCodes.QWERTYReverseMap[qwertyName]
            if scanCode{
                this.KeyMap[scanCode] := values
            }
        }

        for deadKey, combinations in data["deadkeys"] {
            this.DeadKeyDict[deadKey] := Map()
            this.DeadKeyDict[deadKey].Default := "" ; If we get a combination that is not defined, we return a void ""
            for baseChar, combinedChar in combinations {
                this.DeadKeyDict[deadKey][baseChar] := combinedChar
            }
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

        ind := 1 + (shift ? 1 : 0) + (altGr ? 2 : 0)
        if ind > values.Length
            return ""

        return values[ind]
    }
}
