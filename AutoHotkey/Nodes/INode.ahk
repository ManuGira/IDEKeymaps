#Requires AutoHotkey v2.0

#Include ../Tests/Assert.ahk

class INode {
    state := false
    hasInput := false
    inputNode := unset
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

/**
 * Similar to Node but with multiple inputs
 */
class INodeMI extends INode{
    inputNodeList := Array()

    __New(){
        throw "Must be overriden by child class"
    }

    SetInputNode(inputNode := unset){
        throw "Not supported for INodeMI. Please use SetInputNodeList instead"
    }

    SetInputNodeList(inputNodeList := unset){
        if not IsSet(inputNodeList)
            return

        Assert.False(this.hasInput, "An input node is already defined") ; not supported yet. That would require to implement unsubscribe

        CallbackFunc(index, self) {
            return (state) => self.Update(index, state)
        }

        this.inputNodeList := inputNodeList
        index := 0
        for inputNode in inputNodeList{
            local capturedIndex := index + 1  ; Create a local copy
            index := capturedIndex
            inputNode.Subscribe(CallbackFunc(index, this))  ; can't use anonymous function here because index must be fixed
        }
            
        this.hasInput := true
        return this
    }

    Update(index, state){
        throw "Must be overriden by child class"
    }
}

/**
 * Similar to Node but with multiple outputs
 */
class INodeMO extends INode{
    userCallbackListMap := Map()

    __New(){
        throw "Must be overriden by child class"
    }

    SetInputNodeList(inputNodeList := unset){
        throw "Not supported for INodeMO. Please use SetInputNodeList instead"
    }

    Update(index, state){
        throw "Must be overriden by child class"
    }

    Subscribe(channel, callback := unset) {
        if not this.userCallbackListMap.Has(channel)
            this.userCallbackListMap[channel] := Array()

        if IsSet(callback)
            this.userCallbackListMap[channel].Push(callback)
    }

    NotifySubscribers(channel){
        for userCallback in this.userCallbackListMap[channel]
            userCallback(this.state)
    }
}


TestNodeInterface(NodeInstance) {
    Assert.True(IsObject(NodeInstance.GetState), "Node must implement GetState() function")
    Assert.True(IsObject(NodeInstance.Subscribe), "Node must implement Subscribe() function")
}