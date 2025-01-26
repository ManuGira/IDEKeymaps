#Requires AutoHotkey v2.0
#Include INode.ahk
#Include ../Utils/KeyStateObserver.ahk


/**
 * Non-static wrapper around KeyStateObserver
 */
class KeyStateNode extends INode {

    /**
     * 
     * @param key  {(String)}
     * @param passThrough {(bool)}
     * @param callback {(Func<bool>)}
     */
    __New(key, callback := unset, passThrough := true) {
        this.key := key

        if IsSet(callback)
            this.Subscribe(callback)

        KeyStateObserver.Add(key, passThrough)
        KeyStateObserver.Subscribe(key, (k, s) => this.Update(s))
    }

    Update(state){
        this.state := state
        this.NotifySubscribers()
    }
}

; usage:
; KeyStateNode.Add("Numpad1")
; #HotIf KeyStateNode.GetState("Numpad1")
; a::b
; #HotIf
