#Requires AutoHotkey v2.0

; Dict extends Map to add Keys() and Values() helper methods,
; mirroring the common dict interface found in other languages.
class Dict extends Map {

    ; Returns an Array containing all keys in insertion order.
    Keys() {
        result := []
        for k, _ in this
            result.Push(k)
        return result
    }

    ; Returns an Array containing all values in insertion order.
    Values() {
        result := []
        for _, v in this
            result.Push(v)
        return result
    }
}
