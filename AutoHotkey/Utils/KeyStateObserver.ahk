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

    static userCallbackList := Array() 

    static UpdateKeyState(key, state) {

        ; remove " up" from the key name if its there
        key := RegExReplace(key, "i) Up$")
        ; remove first character if it is a *
        key := RegExReplace(key, "i)^\*")


        ; ("Key: " key ", State: " (state ? "down" : "up"), , , 1)

        if not KeyStateObserver.isKeyDown.Has(key)
            throw("Key not found: " key)  ; This will probably never happen
        
        KeyStateObserver.isKeyDown[key] := state
        HotIf()

        for userCallback in KeyStateObserver.userCallbackList
            userCallback(key, state)
    }

    static Get(key){
        return KeyStateObserver.isKeyDown[key]
    }

    static Subscribe(userCallback) {
        KeyStateObserver.UserCallbackList.Push(userCallback)
    }

    static Add(key, passThrough) {
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
    }

}
; usage:
; KeyStateObserver.Add("Numpad1")
; #HotIf KeyStateObserver.Get("Numpad1")
; a::b
; #HotIf
