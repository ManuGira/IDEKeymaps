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

    static Get(scanCode, shift:=false, altGr:=false) {
        rowcol := ScanCodes.GetRowCol(scanCode)
        row := rowcol[1]
        col := rowcol[2]

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

        return char
    }
}