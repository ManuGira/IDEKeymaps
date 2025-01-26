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
}