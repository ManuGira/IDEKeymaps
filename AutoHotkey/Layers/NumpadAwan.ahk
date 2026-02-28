#Requires AutoHotkey v2.0
#Include ../Utils/Conditional.ahk
#Include ../Utils/AppShortcuts.ahk

class NumpadAwan {

    static Init(condition) {
        ; 3 -> Forward
        ; 2 -> LShift
        ; 1 -> Ctrl

        ; 6 -> Backward
        ; 5 -> Win
        ; 4 -> RShift

        ; 9 (NumpadDiv) -> Comment / Uncomment
        ; 8 -> Delete
        ; 7 -> Enter

        ; 12 (NumpadAdd) -> F11: Step Into / Step Out
        ; 11 (NumpadSub) -> Step Over
        ; 10 (NumpadMult) -> F5: Debug / Run / Stop


        ; Maps one of the modifier keys (Ctrl, Shift, Alt, Win)
        mapModKey(key, modkey){
            func := (s) => SendInput("{Blind}{" modkey (s ? "Down}" : "Up}"))
            filterNode := ChangeNode( , func, false)
            Conditional.HotKey("$" key, (k) => filterNode.Update(true), condition)
            Conditional.HotKey("$" key " Up", (k) => filterNode.Update(false), (k) => condition(k) || filterNode.GetState())
        }

        ; mapModKey("Numpad1", "Ctrl")
        ; mapModKey("Numpad2", "Shift")
        ; Conditional.HotKey("$Numpad3", (k) => SendInput("{Browser_Forward}"), condition)

        ; mapModKey("Numpad4", "Alt")
        ; mapModKey("Numpad5", "Win")
        ; Conditional.HotKey("$Numpad6", (k) => SendInput("{Browser_Back}"), condition)

        ; 9 (NumpadDiv) -> Comment / Uncomment
        Conditional.HotKey("$NumpadDiv", (k) => AppShortcuts.SendShortcutByApp(AppShortcuts.CommentMap), condition)
        Conditional.HotKey("$^NumpadDiv", (k) => AppShortcuts.SendShortcutByApp(AppShortcuts.UncommentMap), condition)
        
        ; 12 (NumpadAdd) -> F11: Step Into / Step Out
        Conditional.HotKey("$NumpadAdd", (k) => AppShortcuts.SendShortcutByApp(AppShortcuts.StepInto), condition)
        Conditional.HotKey("$+NumpadAdd", (k) => AppShortcuts.SendShortcutByApp(AppShortcuts.StepOut), condition)
        
        ; 11 (NumpadSub) -> Step Over
        Conditional.HotKey("$NumpadSub", (k) => AppShortcuts.SendShortcutByApp(AppShortcuts.StepOver), condition)
        
        ; 10 (NumpadMult) -> F5: Debug / Run / Stop
        Conditional.HotKey("$NumpadMult", (k) => AppShortcuts.SendShortcutByApp(AppShortcuts.Debug), condition)  ; F5 for Debug
        Conditional.HotKey("$+NumpadMult", (k) => AppShortcuts.SendShortcutByApp(AppShortcuts.Stop), condition)  ; Shift+F5 for Stop Debugging
        Conditional.HotKey("$^NumpadMult", (k) => AppShortcuts.SendShortcutByApp(AppShortcuts.Run), condition)  ; Ctrl+F5 for Run
    }
}