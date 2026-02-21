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

TestNotNode() {
    node := NotNode()
    TestNodeInterface(node)

    Assert.False(node.GetState()) ; 0 -> 1

    node.Update(true)
    Assert.False(node.GetState()) ; 1 -> 0

    node.Update(false)
    Assert.True(node.GetState()) ; 0 -> 1
}

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

TestXOrNode() {
    dummy0 := DummyNode(,,false)
    dummy1 := DummyNode(,,false)
    node := XOrNode([dummy0, dummy1])
    TestNodeInterface(node)

    Assert.False(node.GetState()) ; 0^0=0

    dummy0.Update(true)
    Assert.True(node.GetState()) ; 1^0=1
    
    dummy0.Update(true)
    Assert.True(node.GetState()) ; 1^0=1

    dummy1.Update(true)
    Assert.False(node.GetState())  ; 1^1=0
    
    dummy1.Update(false)
    Assert.True(node.GetState()) ; 1^0=1

    dummy1.Update(true)
    Assert.False(node.GetState())  ; 1^1=0

    dummy0.Update(false)
    Assert.True(node.GetState()) ; 0^1=1
}
TestXOrNode()

TestHitNode(){
    counter := 0
    MyCallback(state){
        counter++
    }
    dummy := DummyNode(,,false)
    hit := HitNode(dummy, (s) => MyCallback(s))
    TestNodeInterface(hit)

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

TestHoldNode(){
    OutputDebug "--- TestHoldNode ---"
    triggerCount := 0
    MyCallback(state){
        triggerCount++
        OutputDebug("TestHoldNode: MyCallback(" state ")")
    }
    dummy := DummyNode(,(s) => OutputDebug("TestHoldNode: dummy.Update(" s ")"),false)
    hold := HoldNode(dummy, (s) => MyCallback(s), 200)  ; t=0
    TestNodeInterface(hold)

    ; 1st run fast press-release 
    dummy.Update(true) ; t=0, 1st timer will wake up at t=200
    Assert.Equal(triggerCount, 0)
    Assert.False(hold.GetState())
    Assert.Equal(hold.counter, 0)

    OutputDebug("TestHoldNode: Sleep(100) => t=100")
    Sleep(100) ; t=100 ;  thresold is 200ms. t=100 is too short to trigger the HoldNode
    dummy.Update(false)
    Assert.Equal(triggerCount, 0)
    Assert.False(hold.GetState())
    Assert.Equal(hold.counter, 1)

    ; again a fast press-release, inner 1st timer will wake up but must not trigger the callback
    OutputDebug("TestHoldNode: Sleep(50) => t=150")
    Sleep(50) ; t=150
    dummy.Update(true) ; new timer scheduled for t=350
    Assert.Equal(triggerCount, 0)
    Assert.False(hold.GetState())
    Assert.Equal(hold.counter, 1)

    OutputDebug("TestHoldNode: Sleep(100) => t=250")
    Sleep(100) ; t=250, 1st timer has already waken up while key was down but it must not trigger.
    Assert.Equal(hold.counter, 1)
    Assert.False(hold.GetState())
    Assert.Equal(triggerCount, 0)

    OutputDebug("TestHoldNode: Sleep(150) => t=400")
    Sleep(150) ; t=400, 2nd timer must have trigger true
    Assert.Equal(triggerCount, 1)
    Assert.True(hold.GetState())

    dummy.Update(false) ; this must trigger the callback in the current thread
    Assert.Equal(triggerCount, 2)
    Assert.False(hold.GetState())

    dummy.Update(false) ; resending false must not trigger the callback
    Assert.Equal(triggerCount, 2)
    Assert.False(hold.GetState())
}
TestHoldNode()

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

TestTimedNode(){
    tnode := TimedNode(,,100)
    
    Assert.False(tnode.GetState())
    tnode.Update(true)
    Assert.True(tnode.GetState())
    Sleep(50)
    Assert.True(tnode.GetState())
    Sleep(100)
    Assert.False(tnode.GetState())
}
TestTimedNode()

TestTimedNode2(){
    tnode := TimedNode(,,200)
    
    Assert.False(tnode.GetState())
    tnode.Update(true)
    Assert.True(tnode.GetState())
    Sleep(150)
    Assert.True(tnode.GetState())
    Sleep(100)
    Assert.False(tnode.GetState())
}
TestTimedNode2()

TestTimedNode3(){
    tnode := TimedNode( , , 100)
    
    Assert.False(tnode.GetState())
    tnode.Update(true) ; state=true until t=100
    Assert.True(tnode.GetState()) ; t=0
    Sleep(60)
    tnode.Update(true) ; t=60, state=true until t=160
    Assert.True(tnode.GetState()) ; t=60
    Sleep(60)
    Assert.True(tnode.GetState()) ; t=120, state is still true
    Sleep(100)  ; state becomes false during this sleep
    Assert.False(tnode.GetState()) ; t=220
}
TestTimedNode3()