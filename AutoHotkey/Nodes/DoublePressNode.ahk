#Requires AutoHotkey v2.0
#Include INode.ahk
#Include KeyStateNode.ahk
#Include ../Utils/TimeStamp.ahk

class DoublePressNode extends INode{

    /**
     * 
     * @param srcNode {(INode)}
     * @param callback {(Func<bool>)}
     */
    __New(inputNode?, callback?, intervalThresholdMs := 400){
        this.intervalThresholdMs := intervalThresholdMs
        this.timeStampDown := TimeStamp(0, 0)
        this.prevTimeStampDown := TimeStamp(0, 0)

        if IsSet(inputNode)
            this.SetInputNode(inputNode)
        if IsSet(callback)
            this.Subscribe(callback)
    }

    onKeyUp(){ 
        if not this.state
            return

        this.state := false
        this.NotifySubscribers()
    }

    onKeyDown(){
        this.prevTimeStampDown := this.timeStampDown
        this.timeStampDown := TimeStamp.Now()
        
        interval := TimeStamp.Sub(this.timeStampDown, this.prevTimeStampDown).ValueMs()
        if interval < this.intervalThresholdMs {
            this.state := true
            this.NotifySubscribers()
        }
    }

    Update(state){ 
        if state == 1 
            this.onKeyDown()
        else if state == 0
            this.onKeyUp()
        else
            throw "Unknown key state: " state
    }
}

