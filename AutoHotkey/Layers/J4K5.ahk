#Requires AutoHotkey v2.0
#Include ../Utils/Conditional.ahk

class J4K5 {

    static Init(condition) {
        ; Assignation des lettres aux chiffres
        Conditional.Hotkey("$m", (k) => SendInput("{Blind}{Text}1"), condition)
        Conditional.Hotkey("$,", (k) => SendInput("{Blind}{Text}2"), condition)
        Conditional.Hotkey("$.", (k) => SendInput("{Blind}{Text}3"), condition)
        Conditional.Hotkey("$j", (k) => SendInput("{Blind}{Text}4"), condition)
        Conditional.Hotkey("$k", (k) => SendInput("{Blind}{Text}5"), condition)
        Conditional.Hotkey("$l", (k) => SendInput("{Blind}{Text}6"), condition)
        Conditional.Hotkey("$u", (k) => SendInput("{Blind}{Text}7"), condition)
        Conditional.Hotkey("$i", (k) => SendInput("{Blind}{Text}8"), condition)
        Conditional.Hotkey("$o", (k) => SendInput("{Blind}{Text}9"), condition)

        Conditional.Hotkey("$p", (k) => SendInput("{Blind}{Text}@"), condition)
        Conditional.Hotkey("$é", (k) => SendInput("{Blind}{Text}#"), condition)
        Conditional.Hotkey("$-", (k) => SendInput("{Blind}{Text}%"), condition)
        
        Conditional.Hotkey("$n", (k) => SendInput("{Blind}{Text}0"), condition)
        Conditional.Hotkey("$h", (k) => SendInput("{Blind}{Text}."), condition)
        Conditional.Hotkey("$z", (k) => SendInput("{Blind}{Text},"), condition)

        Conditional.Hotkey("$g", (k) => SendInput("{Blind}{Text}:"), condition)
        Conditional.Hotkey("$f", (k) => SendInput("{Blind}{Text}="), condition)
        Conditional.Hotkey("$d", (k) => SendInput("{Blind}{Text}+"), condition)
        Conditional.Hotkey("$s", (k) => SendInput("{Blind}{Text}*"), condition)
        Conditional.Hotkey("$a", (k) => SendInput("{Blind}{Text}^"), condition)

        Conditional.Hotkey("$b", (k) => SendInput("{Blind}{Text}$"), condition)
        Conditional.Hotkey("$v", (k) => SendInput("{Blind}{Text}\"), condition)
        Conditional.Hotkey("$c", (k) => SendInput("{Blind}{Text}-"), condition)
        Conditional.Hotkey("$x", (k) => SendInput("{Blind}{Text}/"), condition)
        Conditional.Hotkey("$y", (k) => SendInput("{Blind}{Text}~"), condition)

        Conditional.Hotkey("$t", (k) => SendInput("{Blind}{Text};"), condition)
        Conditional.Hotkey("$r", (k) => SendInput("{Blind}{Text}|"), condition)
        Conditional.Hotkey("$e", (k) => SendInput("{Blind}{Text}&"), condition)
    }
}