#Requires AutoHotkey v2.0
#Include INode.ahk

class DummyNode extends INode {
    /**
     * Pass input to output. Notifies only if state has changed. 
     * @param inputNode {INode}
     * @param callback {(Func<bool>)}
     * @param initialState {(bool)}
     */
    __New(inputNode?, callback?, initialState := false){
        this.state := initialState

        if IsSet(inputNode)
            this.SetInputNode(inputNode)
        if IsSet(callback)
            this.Subscribe(callback)
    }

    Update(state){
        if this.state == state
            return
        this.state := state
        this.NotifySubscribers()
    }
}

