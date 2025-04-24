#Requires AutoHotkey v2.0

class AppTitles {
    static VisualStudio := "Microsoft Visual Studio"
    static VSCode := "Visual Studio Code"
    static PyCharm := "PyCharm"
}

class AppShortcuts {
    static VisualStudio := "Microsoft Visual Studio"
    static VSCode := "Visual Studio Code"
    static PyCharm := "PyCharm"

    static CommentMap := Map(
        AppTitles.VisualStudio, "{Ctrl Down}kc{Ctrl Up}",
        AppTitles.VSCode, "{Ctrl Down}{SC029}{Ctrl Up}",  ; {SC029} is the scan code of "§". We must hardcode it because it is not standardised and differ depending on the keyboard layout
        AppTitles.PyCharm, "{Ctrl Down}/{Ctrl Up}",
    )

    static UncommentMap := Map(
        AppTitles.VisualStudio, "{Ctrl Down}ku{Ctrl Up}",
        AppTitles.VSCode, AppShortcuts.CommentMap[AppTitles.VSCode],
        AppTitles.PyCharm, AppShortcuts.CommentMap[AppTitles.PyCharm],
    )

    static Run := Map(
        AppTitles.VisualStudio, "{F5}",
        AppTitles.VSCode, "{F5}",
        AppTitles.PyCharm, "{F9}",
    )

    static Debug := Map(
        AppTitles.VisualStudio, "{Ctrl Down}rt{Ctrl Up}", ; debug current test
        AppTitles.VSCode, "{F5}",
        AppTitles.PyCharm, "{Ctrl}{F9}",
    )
    
    static StepOver := Map(
        AppTitles.VisualStudio, "{F10}",
        AppTitles.VSCode, "{F10}",
        AppTitles.PyCharm, "{F8}",
    )

    static StepInto := Map(
        AppTitles.VisualStudio, "{F11}",
        AppTitles.VSCode, "{F11}",
        AppTitles.PyCharm, "{F7}",
    )

    static StepOut := Map(
        AppTitles.VisualStudio, "{Shift}{F11}",
        AppTitles.VSCode, "{Shift}{F11}",
        AppTitles.PyCharm, "{Shift}{F8}",
    )

    static SendShortcutByApp(shortcutMap) {
        tile := WinGetTitle("A")
        for app, shortcut in shortcutMap {
            if (tile ~= app) {
                SendInput("{Blind}" shortcut)
                return
            }
        }
    }
}