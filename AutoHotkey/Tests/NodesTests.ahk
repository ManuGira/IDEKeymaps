#Requires AutoHotkey v2.0

#Include Assert.ahk
#Include ../Nodes/include.ahk

TestNodeInterface(NodeInstance) {
    Assert.True(IsObject(NodeInstance.GetState), "Node must implement GetState() function")
    Assert.True(IsObject(NodeInstance.Subscribe), "Node must implement Subscribe() function")
}

TestDummyNode() {
    dummy := DummyNode(,,false)
    TestNodeInterface(dummy)


    Assert.False(dummy.GetState())
    dummy.Update(True)
    Assert.True(dummy.GetState())
    dummy.Update(False)
    Assert.False(dummy.GetState())

    dummy := DummyNode(,,true)
    Assert.True(dummy.GetState())
}
TestDummyNode()

TestNotNode(){
    nn := NotNode(,,false)
    TestNodeInterface(nn)


    Assert.False(nn.GetState())
    nn.Update(False)
    Assert.True(nn.GetState())
    nn.Update(True)
    Assert.False(nn.GetState())

    nn := NotNode(,,true)
    Assert.True(nn.GetState())
}
TestNotNode()

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

TestHitNode(){
    counter := 0
    MyCallback(state){
        counter++
    }
    
    dummy := DummyNode(,,false)
    hit := HitNode(dummy, (s) => MyCallback(s))

    ; run slow press-release 
    dummy.Update(true)
    Assert.Equal(counter, 0)
    Sleep(300) ;  thresold if 200ms. Si 300 is too long to trigger the hitNode
    dummy.Update(false)
    Assert.Equal(counter, 0)

    ; run a fast press-release 
    dummy.Update(true)
    ts0 := TimeStamp.Now()
    Assert.Equal(counter, 0)
    Sleep(-1) 
    dummy.Update(false) ; this must trigger the callback in the current thread
    interval := TimeStamp.Now().Sub(ts0).ValueMs()
    Assert.True(interval < 200, "TestHitNode: slept for too long. Test is not relevant")
    Assert.Equal(counter, 2, "TestHitNode: HitNode must trigger twice")
}
TestHitNode()

TestToggleNode(){
    ToggleNodeReceivesUpdates(tn){
        Assert.False(tn.GetState())

        tn.Update(true)
        Assert.True(tn.GetState())
        tn.Update(false)
        Assert.True(tn.GetState())

        tn.Update(true)
        Assert.False(tn.GetState())
        tn.Update(false)
        Assert.False(tn.GetState())
    }

    counter := 0
    MyCallback(state){
        counter++
    }
    dum := DummyNode()

    ; create naked node
    tog := ToggleNode(,,false)
    ToggleNodeReceivesUpdates(tog)

    ; add callback to node
    tog.Subscribe(MyCallback)
    ToggleNodeReceivesUpdates(tog)
    Assert.Equal(counter, 2)

    ; add input node
    tog.SetInputNode(dum)
    Assert.False(tog.GetState() or dum.GetState())
    dum.Update(true)  ; update dummy node must trigger
    Assert.True(tog.GetState())

    ; can create node with input and callback
    counter := 0
    dum2 := DummyNode()
    tog2 := ToggleNode(dum2, MyCallback, false)
    Assert.False(tog2.GetState())
    dum2.Update(true)
    Assert.True(tog2.GetState())

}
TestToggleNode()