#Requires AutoHotkey v2.0
#Include INode.ahk
#Include ../Utils/TimeStamp.ahk

class HitNode extends INode{

    /**
     * Fires a true state if the input node goes from false to true and then back to false within a certain time interval (default: 200ms). Useful for tap actions.
     * @param inputNode {(INode)}
     * @param callback {(Func<bool>)}
     * @param intervalThresholdMs
     */
    __New(inputNode := unset, callback := unset, intervalThresholdMs := 200){
        this.timeStampDown := TimeStamp(0, 0)
        this.intervalThresholdMs := intervalThresholdMs

        if IsSet(inputNode)
            this.SetInputNode(inputNode)
        if IsSet(callback)
            this.Subscribe(callback)
    }

    onFalse(){ 
        interval := TimeStamp.Now().Sub(this.timeStampDown).ValueMs()
        if interval < this.intervalThresholdMs {
            ; send true then false
            this.state := true
            this.NotifySubscribers()

            this.state := false
            this.NotifySubscribers()
        }
    }

    onTrue(){        
        this.timeStampDown := TimeStamp.Now()
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

