#Requires AutoHotkey v2.0
#Include INode.ahk
#Include KeyStateNode.ahk
#Include ../Utils/TimeStamp.ahk

class SpamCountNode extends INode{

    /**
     * Becomes true when input is true consecutively in a short period of time
     * @param inputNode {(INode)}
     * @param callback {(Func<bool>)}
     * @param intervalThresholdMs
     * @param counts: number of true-false. Use 2 to detect double click.
     */
    __New(inputNode := unset, callback := unset, intervalThresholdMs := 200, counts := 2){

        this.timeStampList := Array()
        this.intervalThresholdMs := intervalThresholdMs
        this.counts := counts
        this.reset()

        
        if IsSet(inputNode)
            this.SetInputNode(inputNode)
        if IsSet(callback)
            this.Subscribe(callback)
    }

    reset(){
        this.timeStampList := Array()
        n := this.counts
        Loop(n) {
            this.timeStampList.Push(TimeStamp(0, 0))
        }
    }

    onFalse(){ 
        if this.state {
            this.state := false
            this.NotifySubscribers()
        }
    }

    onTrue(){        
        this.timeStampList.RemoveAt(1)
        this.timeStampList.Push(TimeStamp.Now())
        
        if (this.timeStampList.Length != this.counts)
            throw "SpamAndHold: timeStampList.Length != this.counts: " this.timeStampList.Length "!=" this.counts

        interval := this.timeStampList[this.counts].Sub(this.timeStampList[1]).ValueMs()
        if interval < this.intervalThresholdMs*this.counts {
            ; send true then false
            this.state := true
            this.NotifySubscribers()
            this.reset()
        }
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

