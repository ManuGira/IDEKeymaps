#Requires AutoHotkey v2.0
#Include INode.ahk


class AndNode extends INode {

    /**
     * 
     * @param inputNodeList {(Array<INode>)}
     * @param callback {(Func<bool>)}
     */
    __New(inputNodeList?, callback?, initialState := false){
        if IsSet(inputNodeList)
            this.SetInputNodeList(inputNodeList)
        if IsSet(callback)
            this.Subscribe(callback)

        this.state := initialState
    }

    Update(state){
        for inputNode in this.inputNodeList
            state := state and inputNode.GetState()
        
        if this.state == state
            return ; no state change

        ; on change
        this.state := state
        this.NotifySubscribers()
    }
}

