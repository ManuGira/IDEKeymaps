#Requires AutoHotkey v2.0

class CaseConverter {
    static upper := "UPPER"
    static lower := "lower"
    static mixed := "Mixed"

    static GuessCaseType(text){
        if (StrUpper(text) == text) 
            return "UPPER"
        
        if (StrLower(text) == text) 
            return "Lower"

        return "Mixed"
    }

    static SwapEachCase(text) {
        swappedText := ""
        Loop Parse, text {
            char := A_LoopField
            if (char == StrUpper(char) && char != StrLower(char)) {
                swappedText .= StrLower(char)
            } else if (char == StrLower(char) && char != StrUpper(char)) {
                swappedText .= StrUpper(char)
            } else {
                swappedText .= char
            }
        }
        return swappedText
    }
}
