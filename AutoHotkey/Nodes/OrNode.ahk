#Requires AutoHotkey v2.0
#Include INode.ahk

class OrNode extends INode {

    /**
     * 
     * @param inputNodeList {(Array<INode>)}
     * @param callback {(Func<bool>)}
     */
    __New(inputNodeList?, callback?){
        if IsSet(inputNodeList)
            this.SetInputNodeList(inputNodeList)
        if IsSet(callback)
            this.Subscribe(callback)
    }

    Update(state){
        state := false
        for inputNode in this.inputNodeList{
            if inputNode.GetState(){
                state := true
                break
            }
        }
        
        if this.state == state
            return ; no state change

        ; on change
        this.state := state
        this.NotifySubscribers()
    }
}

