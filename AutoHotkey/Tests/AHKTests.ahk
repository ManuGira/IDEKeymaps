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

TestMap() {
    myMap := Map()
    Assert.Equal(myMap.Count, 0, "Newly created map should have count 0")
    Assert.True(IsObject(myMap), "Newly created map should be an object")
    Assert.True(IsSet(myMap), "Newly created map should be set")
    Assert.False(myMap.Has("a"), "Newly created map should not have key 'a'")

    myMap["a"] := 1
    myMap["b"] := 2
    Assert.Equal(myMap.Count, 2, "Map should have count 2 after adding two key-value pairs")
    Assert.True(myMap.Has("a"), "Map should return correct value for key 'a'")
    Assert.True(myMap.Has("b"), "Map should return correct value for key 'b'")
    Assert.Equal(myMap["a"], 1, "Map should return correct value for key 'a'")
    Assert.Equal(myMap["b"], 2, "Map should return correct value for key 'b'")
    
    myMap := Map("c", 3, "d", 4)
    Assert.Equal(myMap.Count, 2, "Map initialized with pairs should have correct count")
    Assert.True(myMap.Has("c"), "Map should have key 'c'")
    Assert.True(myMap.Has("d"), "Map should have key 'd'")
    Assert.Equal(myMap["c"], 3, "Map should return correct value for key 'c'")
    Assert.Equal(myMap["d"], 4, "Map should return correct value for key 'd'")

    keys := []
    values := []
    for k, v in myMap {
        keys.Push(k)
        values.Push(v)
    }
    Assert.EqualArray(keys, ["c", "d"], "Map should iterate keys in insertion order")
    Assert.EqualArray(values, [3, 4], "Map should iterate values in insertion order")
}
TestMap()

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
MsgBox("All AHK tests passed")