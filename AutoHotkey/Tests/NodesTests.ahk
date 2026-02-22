#Requires AutoHotkey v2.0

#Include Assert.ahk
#Include ../Nodes/include.ahk

TestNodeInterface(NodeInstance) {
    Assert.True(IsObject(NodeInstance.GetState), "Node must implement GetState() function")
    Assert.True(IsObject(NodeInstance.Subscribe), "Node must implement Subscribe() function")
}

TestPassNode() {
    ; Test constructor
    sut := PassNode(,,false)
    TestNodeInterface(sut)
    Assert.False(sut.GetState())
    sut := PassNode(,,true)
    Assert.True(sut.GetState())

    ; Test that callback is triggered on every update even if state does not change
    counter := 0
    IncrementCounter(state){
        counter++
    }

    sut := PassNode(,(s) => IncrementCounter(s),false)

    Assert.False(sut.GetState())
    sut.Update(True)
    Assert.Equal(counter, 1, "PassNode must trigger the callback on every update")
    Assert.True(sut.GetState())

    sut.Update(True)
    Assert.Equal(counter, 2, "PassNode must trigger the callback on every update")
    Assert.True(sut.GetState())

    sut.Update(False)
    Assert.Equal(counter, 3, "PassNode must trigger the callback on every update")
    Assert.False(sut.GetState())

    sut.Update(False)
    Assert.Equal(counter, 4, "PassNode must trigger the callback on every update")
    Assert.False(sut.GetState())
}
TestPassNode()

TestChangeNode() {
    ; Test constructor
    sut := ChangeNode(,,false)
    TestNodeInterface(sut)
    Assert.False(sut.GetState())
    sut := ChangeNode(,,true)
    Assert.True(sut.GetState())

    ; Test that callback is triggered on every update even if state does not change
    counter := 0
    IncrementCounter(state){
        counter++
    }

    sut := ChangeNode(,(s) => IncrementCounter(s),false)

    Assert.False(sut.GetState())
    sut.Update(True)
    Assert.Equal(counter, 1, "ChangeNode must trigger the callback on every update")
    Assert.True(sut.GetState())

    sut.Update(True)
    Assert.Equal(counter, 1, "ChangeNode must trigger the callback on every update")
    Assert.True(sut.GetState())

    sut.Update(False)
    Assert.Equal(counter, 2, "ChangeNode must trigger the callback on every update")
    Assert.False(sut.GetState())

    sut.Update(False)
    Assert.Equal(counter, 2, "ChangeNode must trigger the callback on every update")
    Assert.False(sut.GetState())
}
TestChangeNode()

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
    pass0 := PassNode(,,false)
    pass1 := PassNode(,,false)
    sut := AndNode([pass0, pass1])
    TestNodeInterface(sut)

    Assert.False(sut.GetState()) ; 0^0=0

    pass0.Update(true)
    Assert.False(sut.GetState()) ; 1^0=0
    
    pass0.Update(true)
    Assert.False(sut.GetState()) ; 1^0=0

    pass1.Update(true)
    Assert.True(sut.GetState())  ; 1^1=1
    
    pass1.Update(false)
    Assert.False(sut.GetState()) ; 1^0=0

    pass1.Update(true)
    Assert.True(sut.GetState())  ; 1^1=1

    pass0.Update(false)
    Assert.False(sut.GetState()) ; 0^1=0
}
TestAndNode()

TestOrNode() {
    pass0 := PassNode(,,false)
    pass1 := PassNode(,,false)
    sut := OrNode([pass0, pass1])
    TestNodeInterface(sut)

    Assert.False(sut.GetState()) ; 0+0=0

    pass0.Update(true)
    Assert.True(sut.GetState()) ; 1+0=1
    
    pass0.Update(true)
    Assert.True(sut.GetState()) ; 1+0=1

    pass1.Update(true)
    Assert.True(sut.GetState())  ; 1+1=1
    
    pass1.Update(false)
    Assert.True(sut.GetState()) ; 1+0=1

    pass1.Update(true)
    Assert.True(sut.GetState())  ; 1+1=1

    pass0.Update(false)
    Assert.True(sut.GetState()) ; 0+1=1
}
TestOrNode()

TestXOrNode() {
    pass0 := PassNode(,,false)
    pass1 := PassNode(,,false)
    sut := XOrNode([pass0, pass1])
    TestNodeInterface(sut)

    Assert.False(sut.GetState()) ; 0^0=0

    pass0.Update(true)
    Assert.True(sut.GetState()) ; 1^0=1
    
    pass0.Update(true)
    Assert.True(sut.GetState()) ; 1^0=1

    pass1.Update(true)
    Assert.False(sut.GetState())  ; 1^1=0
    
    pass1.Update(false)
    Assert.True(sut.GetState()) ; 1^0=1

    pass1.Update(true)
    Assert.False(sut.GetState())  ; 1^1=0

    pass0.Update(false)
    Assert.True(sut.GetState()) ; 0^1=1
}
TestXOrNode()


TestHitNode(){
    counter := 0
    MyCallback(state){
        counter++
    }
    pass := PassNode(,,false)
    sut := HitNode(pass, (s) => MyCallback(s))
    TestNodeInterface(sut)

    ; run slow press-release 
    pass.Update(true)
    Assert.Equal(counter, 0)
    Sleep(300) ;  thresold if 200ms. Si 300 is too long to trigger the hitNode
    pass.Update(false)
    Assert.Equal(counter, 0)

    ; run a fast press-release 
    pass.Update(true)
    ts0 := TimeStamp.Now()
    Assert.Equal(counter, 0)
    Sleep(-1) 
    pass.Update(false) ; this must trigger the callback in the current thread
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
    pass := PassNode(,(s) => OutputDebug("TestHoldNode: change.Update(" s ")"),false)
    sut := HoldNode(pass, (s) => MyCallback(s), 200)  ; t=0
    TestNodeInterface(sut)

    ; 1st run fast press-release 
    pass.Update(true) ; t=0, 1st timer will wake up at t=200
    Assert.Equal(triggerCount, 0)
    Assert.False(sut.GetState())
    Assert.Equal(sut.counter, 0)

    OutputDebug("TestHoldNode: Sleep(100) => t=100")
    Sleep(100) ; t=100 ;  thresold is 200ms. t=100 is too short to trigger the HoldNode
    pass.Update(false)
    Assert.Equal(triggerCount, 0)
    Assert.False(sut.GetState())
    Assert.Equal(sut.counter, 1)

    ; again a fast press-release, inner 1st timer will wake up but must not trigger the callback
    OutputDebug("TestHoldNode: Sleep(50) => t=150")
    Sleep(50) ; t=150
    pass.Update(true) ; new timer scheduled for t=350
    Assert.Equal(triggerCount, 0)
    Assert.False(sut.GetState())
    Assert.Equal(sut.counter, 1)

    OutputDebug("TestHoldNode: Sleep(100) => t=250")
    Sleep(100) ; t=250, 1st timer has already waken up while key was down but it must not trigger.
    Assert.Equal(sut.counter, 1)
    Assert.False(sut.GetState())
    Assert.Equal(triggerCount, 0)

    OutputDebug("TestHoldNode: Sleep(150) => t=400")
    Sleep(150) ; t=400, 2nd timer must have trigger true
    Assert.Equal(triggerCount, 1)
    Assert.True(sut.GetState())

    pass.Update(false) ; this must trigger the callback in the current thread
    Assert.Equal(triggerCount, 2)
    Assert.False(sut.GetState())

    pass.Update(false) ; resending false must not trigger the callback
    Assert.Equal(triggerCount, 2)
    Assert.False(sut.GetState())
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
    pass1 := PassNode(,,)

    ; create naked node
    sut1 := ToggleNode(,,false)
    ToggleNodeReceivesUpdates(sut1)

    ; add callback to node
    sut1.Subscribe(MyCallback)
    ToggleNodeReceivesUpdates(sut1)
    Assert.Equal(counter, 2)

    ; add input node
    sut1.SetInputNode(pass1)
    Assert.False(sut1.GetState() or pass1.GetState())
    pass1.Update(true)  ; update change node must trigger
    Assert.True(sut1.GetState())

    ; can create node with input and callback
    counter := 0
    pass2 := PassNode()
    sut2 := ToggleNode(pass2, MyCallback, false)
    Assert.False(sut2.GetState())
    pass2.Update(true)
    Assert.True(sut2.GetState())

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
