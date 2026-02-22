#Requires AutoHotkey v2.0
#Include INode.ahk

class XOrNode extends INode {

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
        state := false
        for inputNode in this.inputNodeList{
            state2 := inputNode.GetState()
            state := state != state2 ; XOR
        }
        
        if this.state == state
            return ; no state change

        ; on change
        this.state := state
        this.NotifySubscribers()
    }
}

