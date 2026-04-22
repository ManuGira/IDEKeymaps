#Requires AutoHotkey v2.0
#Include ../Utils/Conditional.ahk

class FXX {
    static getMods(){
        mods := ""
        if (GetKeyState("Ctrl", "P"))
            mods := mods "^"

        if (GetKeyState("Alt", "P"))
            mods := mods "!"

        if (GetKeyState("LShift", "P"))
            mods := mods "+"
        return mods
    }

    static AllModHotKey(key, keyToSend, condition) {
        Conditional.Hotkey("$" key, (k) => SendInput(FXX.getMods() keyToSend), condition)
        Conditional.Hotkey("$+" key, (k) => SendInput(FXX.getMods() keyToSend), condition)
        Conditional.Hotkey("$!" key, (k) => SendInput(FXX.getMods() keyToSend), condition)
        Conditional.Hotkey("$^" key, (k) => SendInput(FXX.getMods() keyToSend), condition)
        Conditional.Hotkey("$+!" key, (k) => SendInput(FXX.getMods() keyToSend), condition)
        Conditional.Hotkey("$+^" key, (k) => SendInput(FXX.getMods() keyToSend), condition)
        Conditional.Hotkey("$!^" key, (k) => SendInput(FXX.getMods() keyToSend), condition)
    }

    static Init(condition) {
        FXX.AllModHotKey("q", "{F1}", condition) 
        FXX.AllModHotKey("w", "{F2}", condition) 
        FXX.AllModHotKey("e", "{F3}", condition) 
        FXX.AllModHotKey("r", "{F4}", condition) 
        FXX.AllModHotKey("a", "{F5}", condition) 
        FXX.AllModHotKey("s", "{F6}", condition) 
        FXX.AllModHotKey("d", "{F7}", condition) 
        FXX.AllModHotKey("f", "{F8}", condition) 
        FXX.AllModHotKey("y", "{F9}", condition) 
        FXX.AllModHotKey("x", "{F10}", condition) 
        FXX.AllModHotKey("c", "{F11}", condition) 
        FXX.AllModHotKey("v", "{F12}", condition) 
    }
}