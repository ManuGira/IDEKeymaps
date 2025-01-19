#Requires AutoHotkey v2.0

global isKeyDown := Map()

global shiftMap := Map(
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

global UserCallback

UpdateKeyState(key, state) {
    global

    ; remove " up" from the key name if its there
    key := RegExReplace(key, "i) Up$")
    ; remove first character if it is a *
    key := RegExReplace(key, "i)^\*")


    ; ("Key: " key ", State: " (state ? "down" : "up"), , , 1)

    if not isKeyDown.Has(key)
        throw("Key not found: " key)  ; This will probably never happen
    
    isKeyDown[key] := state
    HotIf()

    if UserCallback
        UserCallback(key, state)
}

OnKeyDownSubscribe(user_callback) {
    global
    UserCallback := user_callback
}

ObserveKeyDown(key) {
    global
    isKeyDown[key] := false
    Hotkey "*" key, (k) => UpdateKeyState(key, true)
    Hotkey "*" key " Up", (k) => UpdateKeyState(key, false)

    if shiftMap.Has(key) {
        shiftkey := shiftMap[key]
        Hotkey "*" shiftkey, (k) => UpdateKeyState(key, true)
        Hotkey "*" shiftkey " Up", (k) => UpdateKeyState(key, false)
    }
}

; usage:
; ObserveKeyDown("Numpad1")
; #HotIf isKeyDown["Numpad1"]
; a::b
; #HotIf
