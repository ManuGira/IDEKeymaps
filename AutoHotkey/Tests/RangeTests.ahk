#Requires AutoHotkey v2.0

#Include Assert.ahk
#Include ../Utils/Range.ahk

TestRangeBasic() {
    ; Test basic range iteration: Range(1, 5, 1) should yield [1, 2, 3, 4]
    result := []
    for x in Range(1, 5, 1) {
        result.Push(x)
    }   
    Assert.EqualArray(result, [1, 2, 3, 4], "Range(1, 5, 1) should yield [1, 2, 3, 4]")
}
TestRangeBasic()

TestRangeWithStep() {
    ; Test range with step 2: Range(0, 10, 2) should yield [0, 2, 4, 6, 8]
    result := []
    for x in Range(0, 10, 2) {
        result.Push(x)
    }
    Assert.EqualArray(result, [0, 2, 4, 6, 8], "Range(0, 10, 2) should yield [0, 2, 4, 6, 8]")
}
TestRangeWithStep()

TestRangeWithStep3() {
    ; Test range with step 3: Range(1, 10, 3) should yield [1, 4, 7]
    result := []
    for x in Range(1, 10, 3) {
        result.Push(x)
    }
    Assert.EqualArray(result, [1, 4, 7], "Range(1, 10, 3) should yield [1, 4, 7]")
}
TestRangeWithStep3()

TestRangeNegativeStep() {
    ; Test range with negative step: Range(10, 0, -2) should yield [10, 8, 6, 4, 2]
    result := []
    for x in Range(10, 0, -2) {
        result.Push(x)
    }
    Assert.EqualArray(result, [10, 8, 6, 4, 2], "Range(10, 0, -2) should yield [10, 8, 6, 4, 2]")
}
TestRangeNegativeStep()

TestRangeEmpty() {
    ; Test range that produces no values: Range(1, 1, 1) should yield []
    result := []
    for x in Range(1, 1, 1) {
        result.Push(x)
    }
    Assert.EqualArray(result, [], "Range(1, 1, 1) should yield []")
}
TestRangeEmpty()

TestRangeEmptyNegative() {
    ; Test range with negative step but start < end: Range(1, 5, -1) should yield []
    result := []
    for x in Range(1, 5, -1) {
        result.Push(x)
    }
    Assert.EqualArray(result, [], "Range(1, 5, -1) should yield []")
}
TestRangeEmptyNegative()

TestRangeSingleElement() {
    ; Test range with single element: Range(5, 6, 1) should yield [5]
    result := []
    for x in Range(5, 6, 1) {
        result.Push(x)
    }
    Assert.EqualArray(result, [5], "Range(5, 6, 1) should yield [5]")
}
TestRangeSingleElement()

TestRangeNegativeNumbers() {
    ; Test range with negative numbers: Range(-5, -1, 1) should yield [-5, -4, -3, -2]
    result := []
    for x in Range(-5, -1, 1) {
        result.Push(x)
    }
    Assert.EqualArray(result, [-5, -4, -3, -2], "Range(-5, -1, 1) should yield [-5, -4, -3, -2]")
}
TestRangeNegativeNumbers()

TestRangeZeroStart() {
    ; Test range starting at zero: Range(0, 5, 1) should yield [0, 1, 2, 3, 4]
    result := []
    for x in Range(0, 5, 1) {
        result.Push(x)
    }
    Assert.EqualArray(result, [0, 1, 2, 3, 4], "Range(0, 5, 1) should yield [0, 1, 2, 3, 4]")
}
TestRangeZeroStart()

TestRangeSingleParam() {
    ; Test range with single parameter: Range(5) should yield [0, 1, 2, 3, 4]
    result := []
    for x in Range(5) {
        result.Push(x)
    }
    Assert.EqualArray(result, [0, 1, 2, 3, 4], "Range(5) should yield [0, 1, 2, 3, 4]")
}
TestRangeSingleParam()

TestRangeTwoParams() {
    ; Test range with two parameters: Range(2, 6) should yield [2, 3, 4, 5]
    result := []
    for x in Range(2, 6) {
        result.Push(x)
    }
    Assert.EqualArray(result, [2, 3, 4, 5], "Range(2, 6) should yield [2, 3, 4, 5]")
}
TestRangeTwoParams()

TestRangeTwoParamsNegative() {
    ; Test range with two parameters starting negative: Range(-3, 2) should yield [-3, -2, -1, 0, 1]
    result := []
    for x in Range(-3, 2) {
        result.Push(x)
    }
    Assert.EqualArray(result, [-3, -2, -1, 0, 1], "Range(-3, 2) should yield [-3, -2, -1, 0, 1]")
}
TestRangeTwoParamsNegative()

