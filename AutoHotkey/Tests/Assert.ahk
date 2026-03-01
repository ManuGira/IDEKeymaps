#Requires AutoHotkey v2.0

class Assert {
    static Fail(msg := "Assertion Failed") {
        throw msg
    }

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

    static Throws(func, msg := ""){
        try {
            func()
        } catch Error as err {
            return ; Expected an error to be thrown, test passes
        }
        throw "Assertion Failed. " msg ": Expected an error to be thrown, but no error was thrown."
    }
}