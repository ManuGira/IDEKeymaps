#Requires AutoHotkey v2.0

#Include ../Utils/Dict.ahk

class QWERTZ {
    static Std := [
        "§1234567890'^", ; Row 1
         "qwertzuiopè¨", ; Row 2
         "asdfghjkléà$", ; Row 3
        "<yxcvbnm,.-"    ; Row 4
    ]

    static Shift := [
        "°+`"*ç%&/()=?``", ; Row 1 (backtick is the escape character)
         "QWERTZUIOPÈ¨",   ; Row 2
         "ASDFGHJKLÉÀ$",   ; Row 3
        ">YXCVBNM;:_",     ; Row 4
    ]
    
    static AltGr := [
        " ¦@#°§¬|¢  ´~", ; Row 1
         "  €       []", ; Row 2
         "          {}", ; Row 3
        "\          "    ; Row 4
    ]
    
    static DeadKeyDict := Dict(
        "^",  Dict("a", "â", "e", "ê", "i", "î", "o", "ô", "u", "û", 
                   "A", "Â", "E", "Ê", "I", "Î", "O", "Ô", "U", "Û"),
        "¨",  Dict("a", "ä", "e", "ë", "i", "ï", "o", "ö", "u", "ü", 
                   "A", "Ä", "E", "Ë", "I", "Ï", "O", "Ö", "U", "Ü"),
        "``", Dict("a", "à", "e", "è", "i", "ì", "o", "ò", "u", "ù", 
                   "A", "À", "E", "È", "I", "Ì", "O", "Ò", "U", "Ù"),
        "~",  Dict("a", "ã", "n", "ñ", "o", "õ", 
                   "A", "Ã", "N", "Ñ", "O", "Õ"),
    )

    static Get(row, col, shift:=false, altGr:=false, deadKey:="") {
        if (not shift && not altGr)
            char := SubStr(QWERTZ.Std[row], col, 1)
        else if (shift && not altGr)
            char := SubStr(QWERTZ.Shift[row], col, 1)
        else if (altGr && not shift)
            char := SubStr(QWERTZ.AltGr[row], col, 1)
        else
            return "" ; No defined character for Shift+AltGr in this layout

        if char = " " ; No character defined for this key
            return ""

        
        if (deadKey && QWERTZ.DeadKeyDict.Has(deadKey)) {
            if (QWERTZ.DeadKeyDict[deadKey].Has(char))
                return QWERTZ.DeadKeyDict[deadKey][char]
            else
                return deadKey . char
        }

        return char
    }

    static FindKey(char) {
        for rowIndex, row in QWERTZ.Std {
            colIndex := InStr(row, char)
            if (colIndex > 0)
                return {row: rowIndex, col: colIndex, shift: false, altGr: false}
        }
        for rowIndex, row in QWERTZ.Shift {
            colIndex := InStr(row, char)
            if (colIndex > 0)
                return {row: rowIndex, col: colIndex, shift: false, altGr: true}
        }
        for rowIndex, row in QWERTZ.AltGr {
            colIndex := InStr(row, char)
            if (colIndex > 0)
                return {row: rowIndex, col: colIndex, shift: true, altGr: false}
        }
        throw "Character '" . char . "' not found in QWERTZ layout."
    }
}