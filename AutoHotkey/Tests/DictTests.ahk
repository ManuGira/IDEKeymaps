#Requires AutoHotkey v2.0

#Include Assert.ahk
#Include ../Utils/Dict.ahk

TestDict() {
    myDict := Dict()
    Assert.Equal(myDict.Count, 0, "Newly created Dict should have count 0")
    Assert.True(IsObject(myDict), "Newly created Dict should be an object")

    myDict["a"] := 1
    myDict["b"] := 2
    Assert.Equal(myDict.Count, 2, "Dict should have count 2 after adding two key-value pairs")
    Assert.True(myDict.Has("a"), "Dict should have key 'a'")
    Assert.True(myDict.Has("b"), "Dict should have key 'b'")
    Assert.Equal(myDict["a"], 1, "Dict should return correct value for key 'a'")
    Assert.Equal(myDict["b"], 2, "Dict should return correct value for key 'b'")

    myDict := Dict("c", 3, "d", 4)
    Assert.Equal(myDict.Count, 2, "Dict initialized with pairs should have correct count")
    Assert.EqualArray(myDict.Keys(), ["c", "d"], "Dict should return correct keys")
    Assert.EqualArray(myDict.Values(), [3, 4], "Dict should return correct values")
}
TestDict()
