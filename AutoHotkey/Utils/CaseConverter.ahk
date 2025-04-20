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

}
