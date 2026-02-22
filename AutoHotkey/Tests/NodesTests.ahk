#Requires AutoHotkey v2.0

#Include Assert.ahk
#Include ../Nodes/include.ahk

TestNodeInterface(NodeInstance) {
    Assert.True(IsObject(NodeInstance.GetState), "Node must implement GetState() function")
    Assert.True(IsObject(NodeInstance.Subscribe), "Node must implement Subscribe() function")
}

TestPassNode() {
    ; Test constructor
    sut := PassNode(,,)
    TestNodeInterface(sut)
    Assert.False(sut.GetState())
    sut := PassNode(,,false)
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
    sut := ChangeNode(,,)
    TestNodeInterface(sut)
    Assert.False(sut.GetState())
    sut := ChangeNode(,,false)
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
    ; Test constructor
    sut := NotNode(,,)
    TestNodeInterface(sut)
    Assert.True(sut.GetState())
    sut := NotNode(,,false)
    Assert.False(sut.GetState())
    sut := NotNode(,,true)
    Assert.True(sut.GetState())

    ; Test use case
    sut := NotNode(,,false)
    Assert.False(sut.GetState()) ; 0 -> 1

    sut.Update(true)
    Assert.False(sut.GetState()) ; 1 -> 0

    sut.Update(false)
    Assert.True(sut.GetState()) ; 0 -> 1
}

TestAndNode() {
    ; Test constructor
    sut := AndNode(,,)
    TestNodeInterface(sut)
    Assert.False(sut.GetState())
    sut := AndNode(,,false)
    Assert.False(sut.GetState())
    sut := AndNode(,,true)
    Assert.True(sut.GetState())

    ; Test use case
    pass0 := PassNode(,,false)
    pass1 := PassNode(,,false)
    sut := AndNode([pass0, pass1])

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
    ; Test constructor
    sut := OrNode(,,)
    TestNodeInterface(sut)
    Assert.False(sut.GetState())
    sut := OrNode(,,false)
    Assert.False(sut.GetState())
    sut := OrNode(,,true)
    Assert.True(sut.GetState())

    pass0 := PassNode(,,false)
    pass1 := PassNode(,,false)
    sut := OrNode([pass0, pass1])

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
    ; Test constructor
    sut := XOrNode(,,)
    TestNodeInterface(sut)
    Assert.False(sut.GetState())
    sut := XOrNode(,,false)
    Assert.False(sut.GetState())
    sut := XOrNode(,,true)
    Assert.True(sut.GetState())


    ; Test use case
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

TestGateNode() {
    ; Test constructor
    sut := GateNode(,,,)
    TestNodeInterface(sut)
    Assert.False(sut.GetState())
    sut := GateNode(,,,false)
    Assert.False(sut.GetState())
    sut := GateNode(,,,true)
    Assert.True(sut.GetState())

    
    ; Test use case
    inputNode := PassNode(,,false)
    controllerNode := PassNode(,,false)
    counter := 0
    IncrementCounter(state){
        counter++
    }

    sut := GateNode(inputNode, controllerNode, (s) => IncrementCounter(s),false)

    ResetTest(state := false, isOpen := false){
        inputNode.Update(state)
        controllerNode.Update(isOpen)
        counter := 0
        Assert.Equal(sut.isOpen, isOpen, "ResetTest: gate must be closed")
        Assert.Equal(sut.GetState(), state, "ResetTest: gate state must be false")
        Assert.Equal(counter, 0, "ResetTest: callback must not be triggered")
    }

    ; input is blocked by closed gate, callback not triggered
    ResetTest()
    inputNode.Update(true)
    Assert.False(sut.isOpen)
    Assert.True(sut.GetState())
    Assert.Equal(counter, 0)
    
    ; Opening-Closing gate does not trigger the callback
    ResetTest()
    sut.Open(true)
    Assert.True(sut.isOpen)
    sut.Open(false)
    Assert.False(sut.isOpen)
    controllerNode.Update(true)
    Assert.True(sut.isOpen)
    controllerNode.Update(false)
    Assert.False(sut.isOpen)
    Assert.Equal(counter, 0, "Opening the gate must not trigger the callback")

    ; Triggering input update while gate is open must trigger the callback
    ResetTest(false, true)
    inputNode.Update(true)
    Assert.Equal(counter, 1, "Updating input while gate is open must trigger the callback")

    ; Triggering same input twice does trigger the callback twice
    ResetTest(false, true)
    Assert.Equal(counter, 0, "Updating input while gate is open must trigger the callback")
    inputNode.Update(true)
    Assert.Equal(counter, 1, "Updating input while gate is open must trigger the callback")
    inputNode.Update(true)
    Assert.Equal(counter, 2, "Updating input while gate is open must trigger the callback")

    ; Triggering input to false does trigger the callback
    ResetTest(false, true)
    inputNode.Update(false)
    Assert.Equal(counter, 1, "Updating input while gate is open must trigger the callback")

    ResetTest(false, false)
    controllerNode.Update(false)
    Assert.Equal(counter, 0, "Updating controller node must not trigger the callback")

    ResetTest(true, false)
    controllerNode.Update(false)
    Assert.Equal(counter, 0, "Updating controller node must not trigger the callback")

    ResetTest(false, false)
    controllerNode.Update(true)
    Assert.Equal(counter, 0, "Updating controller node must not trigger the callback")

    ResetTest(true, false)
    controllerNode.Update(true)
    Assert.Equal(counter, 0, "Updating controller node must not trigger the callback")

    ResetTest(false, false)
    inputNode.Update(true)
    Assert.True(sut.GetState(), "Input node must update the state of the gate node even if the gate is closed")
    Assert.Equal(counter, 0, "Updating input while gate is closed must not trigger the callback")

    ResetTest(true, false)
    inputNode.Update(false)
    Assert.False(sut.GetState(), "Input node must update the state of the gate node even if the gate is closed")
    Assert.Equal(counter, 0, "Updating input while gate is closed must not trigger the callback")
}
TestGateNode()

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
