#Requires AutoHotkey v2.0

#Include Assert.ahk
#Include ../Nodes/include.ahk

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
