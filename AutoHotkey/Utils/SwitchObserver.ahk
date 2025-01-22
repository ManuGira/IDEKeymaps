#Requires AutoHotkey v2.0
#Include KeyStateObserver.ahk

class SwitchObserver{
    static switches := Map()
    static switchKeys := Map()
    static UserCallbackList := Array()

    static Add(name, keys){
        SwitchObserver.switches[name] := false
        SwitchObserver.switchKeys[name] := keys
        for key in keys
            KeyStateObserver.Add(key, true)
    }

    static Get(name){
        if not SwitchObserver.switches.Has(name)
            throw "Switch named '" name "' does not exist"
        return SwitchObserver.switches[name]
    }

    static Subscribe(userCallback) {
        SwitchObserver.UserCallbackList.Push(userCallback)
    }
    
    static Contains(name, key){
        for k in SwitchObserver.switchKeys[name]
            if k == key
                return true
        return false
    }

    static Update(key, state){
        for switchName, keys in SwitchObserver.switchKeys {
            if not SwitchObserver.Contains(switchName, key)
                continue
                        
            switchState := true
            for k in keys
                switchState := switchState and KeyStateObserver.Get(k)          
            
            if not switchState
                continue

            SwitchObserver.switches[switchName] := not SwitchObserver.switches[switchName]
            
            for userCallback in SwitchObserver.UserCallbackList
                userCallback(switchName, switchState)
        }
    }
}

KeyStateObserver.Subscribe((key, state) => SwitchObserver.Update(key, state))
