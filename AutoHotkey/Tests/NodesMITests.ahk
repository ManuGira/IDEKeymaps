#Requires AutoHotkey v2.0

#Include Assert.ahk
#Include ../Nodes/include.ahk

TestAndNode() {
    dummy0 := DummyNode(,,false)
    dummy1 := DummyNode(,,false)
    node := AndNode([dummy0, dummy1])
    TestNodeInterface(node)

    Assert.False(node.GetState()) ; 0^0=0

    dummy0.Update(true)
    Assert.False(node.GetState()) ; 1^0=0
    
    dummy0.Update(true)
    Assert.False(node.GetState()) ; 1^0=0

    dummy1.Update(true)
    Assert.True(node.GetState())  ; 1^1=1
    
    dummy1.Update(false)
    Assert.False(node.GetState()) ; 1^0=0

    dummy1.Update(true)
    Assert.True(node.GetState())  ; 1^1=1

    dummy0.Update(false)
    Assert.False(node.GetState()) ; 0^1=0
}
TestAndNode()

TestOrderedAndNode() {
    count := 0
    Callback(state){
        count += 1
    }

    dummy0 := DummyNode(,,false)
    dummy1 := DummyNode(,,false)
    node := OrderedAndNode([dummy0, dummy1])
    TestNodeInterface(node)

    node.Subscribe(Callback)

    ; (0, 0): stage 0/2 -> 0
    Assert.Equal(count, 0)
    Assert.Equal(node.stage, 0)
    Assert.False(node.GetState())

    dummy0.Update(true) ; (1, 0): stage 1/2 -> 0
    Assert.Equal(count, 0)
    Assert.Equal(node.stage, 1)
    Assert.False(node.GetState())
    
    dummy0.Update(true) ; (1, 0): stage 1/2 -> 0
    Assert.Equal(count, 0)
    Assert.Equal(node.stage, 1)
    Assert.False(node.GetState())

    dummy1.Update(true) ; (1, 1): stage 2/2 -> 1
    Assert.Equal(count, 1)
    Assert.Equal(node.stage, 2)
    Assert.True(node.GetState())
    
    dummy1.Update(false) ; (1, 0): stage 1/2 -> 0
    Assert.Equal(count, 2)
    Assert.Equal(node.stage, 1)
    Assert.False(node.GetState())

    dummy1.Update(true) ; (1, 1): stage 2/2 -> 1
    Assert.Equal(count, 3)
    Assert.Equal(node.stage, 2)
    Assert.True(node.GetState())

    dummy0.Update(false) ; (0, 1): stage 0/2 -> 0
    Assert.Equal(count, 4)
    Assert.Equal(node.stage, 0)
    Assert.False(node.GetState())

    dummy0.Update(true) ; (1, 1): stage 1/2 -> 0
    Assert.Equal(count, 4)
    Assert.Equal(node.stage, 1)
    Assert.False(node.GetState())

    dummy1.Update(false) ; (1, 0): stage 1/2 -> 0
    Assert.Equal(count, 4)
    Assert.Equal(node.stage, 1)
    Assert.False(node.GetState())

    dummy1.Update(true) ; (1, 1): stage 2/2 -> 1
    Assert.Equal(count, 5)
    Assert.Equal(node.stage, 2)
    Assert.True(node.GetState())

    dummy1.Update(false) ; (1, 0): stage 1/2 -> 0
    Assert.Equal(count, 6)
    Assert.Equal(node.stage, 1)
    Assert.False(node.GetState())

    dummy1.Update(true) ; (1, 1): stage 2/2 -> 1
    Assert.Equal(count, 7)
    Assert.Equal(node.stage, 2)
    Assert.True(node.GetState())
}
TestOrderedAndNode()

TestOrNode() {
    dummy0 := DummyNode(,,false)
    dummy1 := DummyNode(,,false)
    node := OrNode([dummy0, dummy1])
    TestNodeInterface(node)

    Assert.False(node.GetState()) ; 0+0=0

    dummy0.Update(true)
    Assert.True(node.GetState()) ; 1+0=1
    
    dummy0.Update(true)
    Assert.True(node.GetState()) ; 1+0=1

    dummy1.Update(true)
    Assert.True(node.GetState())  ; 1+1=1
    
    dummy1.Update(false)
    Assert.True(node.GetState()) ; 1+0=1

    dummy1.Update(true)
    Assert.True(node.GetState())  ; 1+1=1

    dummy0.Update(false)
    Assert.True(node.GetState()) ; 0+1=1
}
TestOrNode()
