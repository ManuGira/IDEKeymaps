#Requires AutoHotkey v2.0
#Include INode.ahk

class GateNode extends INode {
    /**
     * Pass input to output if gate is open. If the gate node is closed, the subscribers will not be notified of changes to the input node. The gate node can be controlled by another node, allowing for dynamic control of the flow of information.
     * @param controllerNode {INode} Node that controls whether the gate is open or closed. If the controller node is true, the gate is open and subscribers will be notified of changes to the input node. If the controller node is false, the gate is closed and subscribers will not be notified of changes to the input node.
     * @param inputNode {INode} Node that provides the input state. Subscribers will be notified of changes to this node only if the gate is open.
     * @param callback {(Func<bool>)} Optional callback function that will be called when the state of the gate node changes. The callback will receive the new state of the gate node as an argument.
     * @param initialState {(bool)} Optional initial state of the gate node.
     */
    __New(controllerNode?, inputNode?, callback?, initialState := false){
        this.state := initialState

        if IsSet(inputNode)
            this.SetInputNode(inputNode)
        if IsSet(controllerNode)
            controllerNode.Subscribe((s) => this.Open(s))
        if IsSet(callback)
            this.Subscribe(callback)
        this.isOpen := false
    }

    Open(isOpen){
        ; Open or close the gate based on the state of the gate node
        ; This does not trigger a notification to subscribers
        this.isOpen := isOpen
    }

    Update(state){
        this.state := state

        ; Only notify if gate is open
        if this.isOpen
            this.NotifySubscribers()
    }
}

