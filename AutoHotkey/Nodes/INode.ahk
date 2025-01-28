#Requires AutoHotkey v2.0

#Include ../Tests/Assert.ahk

class INode {
    state := false
    hasInput := false
    inputNode := unset
    inputNodeList := Array()  ; only used by nodes needing multiple inputs like AndNode and OrNode
    userCallbackList := Array()

    __New(){
        throw "Must be overriden by child class"
    }

    NotifySubscribers(){
        for userCallback in this.userCallbackList
            userCallback(this.state)
    }

    SetInputNode(inputNode := unset){
        
        if not IsSet(inputNode)
            return

        Assert.False(this.hasInput, "An input node is already defined") ; not supported yet. That would require to implement unsubscribe

        this.inputNode := inputNode
        this.inputNode.Subscribe((state) => this.Update(state))
        this.hasInput := true
        return this
    }

    SetInputNodeList(inputNodeList := unset){
        if not IsSet(inputNodeList)
            return

        Assert.False(this.hasInput, "An input node is already defined") ; not supported yet. That would require to implement unsubscribe

        this.inputNodeList := inputNodeList
        for inputNode in inputNodeList
            inputNode.Subscribe((state) => this.Update(state))
        this.hasInput := true
        return this
    }

    Update(state){
        throw "Must be overriden by child class"
    }

    GetState(){
        return this.state
    }

    Subscribe(callback := unset) {
        if IsSet(callback)
            this.userCallbackList.Push(callback)
    }
}