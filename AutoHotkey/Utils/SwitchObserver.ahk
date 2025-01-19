#Requires AutoHotkey v2.0
#Include KeyDownObserver.ahk

class SwitchObserver{
    static switches := Map()
    static switchKeys := Map()

    static Add(name, keys){
        SwitchObserver.switches[name] := false
        SwitchObserver.switchKeys[name] := keys
        for key in keys
            if not isKeyDown.Has(key)
                ObserveKeyDown(key)
    }

    static Get(name){
        return SwitchObserver.switches[name]
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
            if switchState{
                for k in keys{
                    switchState := switchState and isKeyDown[k]            
                }
            }
            SwitchObserver.switches[switchName] := SwitchObserver.switches[switchName] != switchState
        }
    }
}

OnKeyDownSubscribe((key, state) => SwitchObserver.Update(key, state))
