#Requires AutoHotkey v2.0
#Include INode.ahk

class ToggleNode extends INode {

    /**
     * toggle its state when source node trigger "true"
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
        if not state
            return ; no change
        this.state := not this.state
        
        this.NotifySubscribers()
    }
}


