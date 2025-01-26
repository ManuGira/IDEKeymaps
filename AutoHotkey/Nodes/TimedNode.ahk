#Requires AutoHotkey v2.0
#Include INode.ahk
#Include ../Utils/TimeStamp.ahk

class TimedNode extends INode {

    /**
     * toggle its state when source node trigger "true"
     * @param inputNode {INode}
     * @param callback {(Func<bool>)}
     * @param durationMs {(int)}
     */
    __New(inputNode := unset, callback := unset, durationMs := 1000){
        this.durationMs := durationMs
        this.counter := 0
        this.downSchedule := TimeStamp(0, 0)

        if IsSet(inputNode)
            this.SetInputNode(inputNode)
        if IsSet(callback)
            this.Subscribe(callback)
    }

    TimeOut(count){
        if count != this.counter
            return ; the counter has changed. Meaning the timeout has been postponed

        this.state := false
        this.NotifySubscribers()
    }

    ComputeRemainingTimeMs(){
        return this.downSchedule.Sub(TimeStamp.Now()).ValueMs()
    }

    Update(state){
        if not state
            return ; no change
        this.downSchedule := TimeStamp.Now().Add(TimeStamp(0, this.durationMs))
        
        this.counter++
        SetTimer(() => this.TimeOut(this.counter+0), -this.durationMs)
        
        if not this.state
            this.state := true
            this.NotifySubscribers()
    }
}
