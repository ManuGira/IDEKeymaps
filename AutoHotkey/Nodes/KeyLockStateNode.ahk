#Requires AutoHotkey v2.0
#Include INode.ahk
#Include ../Utils/Utils.ahk

CapsLockStr := "CapsLock"
NumLockStr := "NumLock"
ScrollLockStr := "ScrollLock"

/**
 * Non-static wrapper around KeyStateObserver
 */
class KeyLockStateNode extends INode {

    /**
     * 
     * @param key  {(String)} CapsLock, ScrollLock or NumLock
     * @param passThrough {(bool)}

     */
    __New(key, callback := unset) {
        ; Assert that key is one of "CapsLock", "NumLock" or "ScrollLock"
        if !(key = CapsLockStr || key = NumLockStr || key = ScrollLockStr)
            throw "KeyLockStateNode only works with CapsLock, NumLock or ScrollLock keys. Invalid key: " key

        this.key := key

        if IsSet(callback)
            this.Subscribe(callback)

        state0 := this.GetLockState()
        node := ChangeNode(KeyStateNode(key, , true), , state0)

        node.Subscribe((s) => this.Update(s))
    }

    GetLockState(){
        return GetKeyState(this.key, "T")
    }

    Update(state){
        if state {   
            this.state := this.GetLockState()
            this.NotifySubscribers()
        }
    }
}
