#Requires AutoHotkey v2.0
#Include INode.ahk

class HoldNode extends INode{

    /**
     * Fires true if the state remains true for the intervalThresholdMs. Then fires false when the state changes to false.
     * @param inputNode {(INode)}
     * @param callback {(Func<bool>)}
     * @param intervalThresholdMs
     */
    __New(inputNode := unset, callback := unset, intervalThresholdMs := 200){
        this.intervalThresholdMs := intervalThresholdMs

        this.counter := 0
        this.timerCounts := false

        this.state := false

        if IsSet(inputNode)
            this.SetInputNode(inputNode)
        if IsSet(callback)
            this.Subscribe(callback)
    }

    onTimerEnd(id){
        OutputDebug("HoldNode.onTimerEnd(id: " id "), counter: " this.counter ", timerCounts: " this.timerCounts " -> " this.timerCounts -1)
        this.timerCounts--

        if id != this.counter
            return

        this.state := true
        this.NotifySubscribers()
    }

    onFalse(){
        OutputDebug("HoldNode.onFalse(), counter: " this.counter " -> " this.counter + 1 ", state: " this.state " -> 0, timerCounts: " this.timerCounts)
        this.counter := this.counter + 1 

        if !this.state
            return

        this.state := false
        this.NotifySubscribers()
    }

    onTrue(){   
        OutputDebug("HoldNode.onTrue(), counter: " this.counter ", state: " this.state ", timerCounts: " this.timerCounts " -> " this.timerCounts +1)
        this.timerCounts++
        id := this.counter
        SetTimer(() => this.onTimerEnd(id), -this.intervalThresholdMs)
    }

    Update(state){ 
        if state == 1 
            this.onTrue()
        else if state == 0
            this.onFalse()
        else
            throw "Unknown key state: " state
    }
}

