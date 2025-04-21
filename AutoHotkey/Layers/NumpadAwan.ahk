#Requires AutoHotkey v2.0
#Include ../Utils/Conditional.ahk

class NumpadAwan {

    static Init(condition) {
        ; 1 -> Ctrl
        ; 2 -> Shift
        ; 3 -> Forward

        ; 4 -> Alt
        ; 5 -> Win
        ; 6 -> Backward

        ; 7 -> Enter
        ; 8 -> Delete
        ; 9 (num /) -> 

        ; 10 (num *) -> Step Into / Step Out
        ; 11 (num -) -> Step Over
        ; 12 (num +) -> Debug


        ; Maps one of the modifier keys (Ctrl, Shift, Alt, Win)
        mapModKey(key, modkey){
            func := (s) => SendInput("{Blind}{" modkey (s ? "Down}" : "Up}"))
            filterNode := DummyNode( , func, false)
            Conditional.HotKey("$" key, (k) => filterNode.Update(true), condition)
            Conditional.HotKey("$" key " Up", (k) => filterNode.Update(false), (k) => condition(k) || filterNode.GetState())
        }

        mapModKey("Numpad1", "Ctrl")
        mapModKey("Numpad2", "Shift")
        Conditional.HotKey("$Numpad3", (k) => SendInput("{Browser_Forward}"), condition)

        mapModKey("Numpad4", "Alt")
        mapModKey("Numpad5", "Win")
        Conditional.HotKey("$Numpad6", (k) => SendInput("{Browser_Back}"), condition)

    }
}