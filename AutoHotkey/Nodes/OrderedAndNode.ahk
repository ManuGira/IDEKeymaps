#Requires AutoHotkey v2.0
#Include INode.ahk

; 1 1 0 0 0: stage = 2
; 1 1 0 1 0: stage = 2
; 1 1 1 1 0: stage = 3

class OrderedAndNode extends INodeMI {

    /**
     * @param inputNodeList {(Array<INode>)}
     * @param callback {(Func<bool>)}
     */
    __New(inputNodeList?, callback?){
        if IsSet(inputNodeList)
            this.SetInputNodeList(inputNodeList)
        if IsSet(callback)
            this.Subscribe(callback)

        this.state := false
        this.stage := 0
    }

    OnKeyDown(index){
        if index == this.stage + 1 {
            this.stage := index
            if this.stage == this.inputNodeList.Length {
                this.state := true
                this.NotifySubscribers()
            }
        }
    }

    OnKeyUp(index){
        if index <= this.stage {
            this.stage := index - 1
            if this.state {
                this.state := false
                this.NotifySubscribers()
            }
        }
    }

    Update(index, state){
        if state
            this.OnKeyDown(index)
        else
            this.OnKeyUp(index)
    }
}

