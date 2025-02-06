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

    Update(state){
        if not state
            return ; ignore state=false, no change
        
        ; schedule the timeout. Increase the counter to invalidate existing timeouts
        this.counter++
        countcopy := this.counter
        SetTimer(() => this.TimeOut(countcopy), -this.durationMs)
        
        ; Notify only if this.state goes from false to true
        if not this.state
            this.state := true
            this.NotifySubscribers()
    }
}
