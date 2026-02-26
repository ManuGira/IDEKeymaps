#Requires AutoHotkey v2.0

#Include Assert.ahk

TestBooleans() {
    Assert.True(true, "True should be true")
    Assert.False(false, "False should be false")
    Assert.True(!false, "Negation of false should be true")
    Assert.False(!true, "Negation of true should be false")
    Assert.False(not true, "Negation of true should be false")
    Assert.True(not false, "Negation of false should be true")
    
    if !true {
        Assert.Fail("Negation of true should be false")
    }
    
    if false {
        Assert.Fail("False should be falsy")
    }
}
TestBooleans()

TestEmptyString() {
    Assert.Equal("", "")
    Assert.False("", "Empty string should be falsy")
    Assert.True(!"", "Negation of empty string should be true")

    Assert.True("a", "Non-empty string should be truthy")
    
    s := ""
    if s {
        Assert.Fail("Empty string should be falsy")
    }
    
}
TestEmptyString()

TestLambda() {
    myLamb := (x) => x * 2
    Assert.Equal(myLamb(3), 6, "Lambda should return double the input")
    
    myLamb := (x, y) => x + y
    Assert.Equal(myLamb(2, 3), 5, "Lambda should return the sum of inputs")

    x := 10
    myLamb := (y) => x + y
    Assert.Equal(myLamb(5), 15, "Lambda should capture external variable")
    x := 20
    Assert.Equal(myLamb(5), 25, "Lambda should reflect updated external variable")

    c := 1
    MyFunc(a, b){
        return a + b + c
    }
    Assert.Equal(MyFunc(100, 10), 111, "Function should return the sum of inputs and captured variable")
    c := 2
    Assert.Equal(MyFunc(100, 10), 112, "Function should reflect updated captured variable")
    b := 20
    myLamb := (a) => MyFunc(a, b)
    Assert.Equal(myLamb(100), 122, "Lambda should capture updated variable from function")
    b := 30
    c := 3
    Assert.Equal(myLamb(100), 133, "Lambda should capture updated variable from function")
}
TestLambda()
