#Requires AutoHotkey v2.0
#Include INode.ahk

class NotNode extends INode {
    /**
     * State is the inverse of the input
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
        this.state := not state
        this.NotifySubscribers()
    }
}

