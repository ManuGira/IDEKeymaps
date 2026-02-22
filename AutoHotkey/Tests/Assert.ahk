#Requires AutoHotkey v2.0

class Assert {
    static True(actual, msg := ""){
        if not actual
            throw "Assertion Failed. " msg ": Expected true, got " actual
    }

    static False(actual, msg := ""){
        if actual
            throw "Assertion Failed. " msg ": Expected false, got " actual
    }

    static Equal(actual, expected, msg := ""){
        if actual != expected
            throw "Assertion Failed. " msg ": Expected " expected ", got " actual
    }

    static EqualArray(actual, expected, msg := ""){
        actualLength := actual.Length
        expectedLength := expected.Length
        if (actualLength != expectedLength)
            throw "Assertion Failed. " msg ": Expected array of length " expectedLength ", got length " actualLength
        for i, v in expected {
            if (actual[i] != v)
                throw "Assertion Failed. " msg ": At index " i ": Expected " v ", got " actual[i]
        }
    }
}