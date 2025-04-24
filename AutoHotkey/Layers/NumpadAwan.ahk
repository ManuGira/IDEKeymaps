#Requires AutoHotkey v2.0
#Include ../Utils/Conditional.ahk
#Include ../Utils/AppShortcuts.ahk

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
        ; 9 (num /) -> Comment / Uncomment

        ; 10 (num *) -> Step Into / Step Out
        ; 11 (num -) -> Step Over
        ; 12 (num +) -> Debug /Run


        ; Maps one of the modifier keys (Ctrl, Shift, Alt, Win)
        mapModKey(key, modkey){
            func := (s) => SendInput("{Blind}{" modkey (s ? "Down}" : "Up}"))
            filterNode := DummyNode( , func, false)
            Conditional.HotKey("$" key, (k) => filterNode.Update(true), condition)
            Conditional.HotKey("$" key " Up", (k) => filterNode.Update(false), (k) => condition(k) || filterNode.GetState())
        }

        ; mapModKey("Numpad1", "Ctrl")
        ; mapModKey("Numpad2", "Shift")
        ; Conditional.HotKey("$Numpad3", (k) => SendInput("{Browser_Forward}"), condition)

        ; mapModKey("Numpad4", "Alt")
        ; mapModKey("Numpad5", "Win")
        ; Conditional.HotKey("$Numpad6", (k) => SendInput("{Browser_Back}"), condition)

        Conditional.HotKey("$NumpadDiv", (k) => AppShortcuts.SendShortcutByApp(AppShortcuts.CommentMap), condition)
        Conditional.HotKey("$^NumpadDiv", (k) => AppShortcuts.SendShortcutByApp(AppShortcuts.UncommentMap), condition)

        Conditional.HotKey("$NumpadAdd", (k) => AppShortcuts.SendShortcutByApp(AppShortcuts.Debug), condition)
        Conditional.HotKey("$^NumpadAdd", (k) => AppShortcuts.SendShortcutByApp(AppShortcuts.Run), condition)

        Conditional.HotKey("$NumpadSub", (k) => AppShortcuts.SendShortcutByApp(AppShortcuts.StepOver), condition)
        
        Conditional.HotKey("$NumpadMult", (k) => AppShortcuts.SendShortcutByApp(AppShortcuts.StepInto), condition)
        Conditional.HotKey("$^NumpadMult", (k) => AppShortcuts.SendShortcutByApp(AppShortcuts.StepOut), condition)
    }
}