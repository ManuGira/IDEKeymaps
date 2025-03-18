#Requires AutoHotkey v2.0
#Include ../Utils/Conditional.ahk

class J4K5 {

    static Init(condition) {
        ; Assignation des lettres aux chiffres
        Conditional.Hotkey("$n", (k) => SendInput("{Blind}{Text}0"), condition)
        Conditional.Hotkey("$m", (k) => SendInput("{Blind}{Text}1"), condition)
        Conditional.Hotkey("$,", (k) => SendInput("{Blind}{Text}2"), condition)
        Conditional.Hotkey("$.", (k) => SendInput("{Blind}{Text}3"), condition)
        Conditional.Hotkey("$j", (k) => SendInput("{Blind}{Text}4"), condition)
        Conditional.Hotkey("$k", (k) => SendInput("{Blind}{Text}5"), condition)
        Conditional.Hotkey("$l", (k) => SendInput("{Blind}{Text}6"), condition)
        Conditional.Hotkey("$u", (k) => SendInput("{Blind}{Text}7"), condition)
        Conditional.Hotkey("$i", (k) => SendInput("{Blind}{Text}8"), condition)
        Conditional.Hotkey("$o", (k) => SendInput("{Blind}{Text}9"), condition)

        ; Conditional.Hotkey("$q", (k) => MouseMove(10, 10, 100, "R"), condition)
    }
}