#Requires AutoHotkey v2.0


class KeyStateObserver{
    static isKeyDown := Map()

    static shiftMap := Map(
        "Numpad1", "NumpadEnd",
        "Numpad2", "NumpadDown",
        "Numpad3", "NumpadPgDn",
        "Numpad4", "NumpadLeft",
        "Numpad5", "NumpadClear",
        "Numpad6", "NumpadRight",
        "Numpad7", "NumpadHome",
        "Numpad8", "NumpadUp",
        "Numpad9", "NumpadPgUp"
    )

    static userCallbackMap := Map() 

    static UpdateKeyState(key, state) {

        ; remove " up" from the key name if its there
        key := RegExReplace(key, "i) Up$")
        ; remove first character if it is a *
        key := RegExReplace(key, "i)^\*")

        if not KeyStateObserver.isKeyDown.Has(key)
            throw("Key not found: " key)  ; This is not supposed to happen
        
        KeyStateObserver.isKeyDown[key] := state

        if KeyStateObserver.userCallbackMap.Has("")
            for userCallback in KeyStateObserver.userCallbackMap[""]
                userCallback(key, state)

        if KeyStateObserver.userCallbackMap.Has(key){
            for userCallback in KeyStateObserver.userCallbackMap[key]{
                userCallback(key, state)
            }
        }
    }

    static GetState(key){
        if not KeyStateObserver.isKeyDown.Has(key)
            throw "key " key " is not tracked"
        return KeyStateObserver.isKeyDown[key]
    }

    static Subscribe(key, callback) {
        if not KeyStateObserver.UserCallbackMap.Has(key)
            KeyStateObserver.UserCallbackMap[key] := Array()
        
        KeyStateObserver.UserCallbackMap[key].Push(callback)
    }

    static SubscribeAll(callback) {
        KeyStateObserver.Subscribe("", callback)
    }
    

    static Add(key, passThrough := true, callback := unset) {
        if KeyStateObserver.isKeyDown.Has(key)
            return 

        prefix := passThrough ? "~$*" : "*"

        KeyStateObserver.isKeyDown[key] := false
        Hotkey prefix key, (k) => KeyStateObserver.UpdateKeyState(key, true)
        Hotkey prefix key " Up", (k) => KeyStateObserver.UpdateKeyState(key, false)

        if KeyStateObserver.shiftMap.Has(key) {
            shiftkey := KeyStateObserver.shiftMap[key]
            Hotkey prefix shiftkey, (k) => KeyStateObserver.UpdateKeyState(key, true)
            Hotkey prefix shiftkey " Up", (k) => KeyStateObserver.UpdateKeyState(key, false)
        }

        if IsSet(callback)
            KeyStateObserver.Subscribe(key, callback)
    }
}