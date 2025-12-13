#Requires AutoHotkey v2.0

class ProcessNames {
    static VisualStudio := "devenv.exe"
    static VSCode := "code.exe"
    static PyCharm := "pycharm64.exe|pycharm.exe"  ; Both 64-bit and 32-bit versions
    static Any := ".*"
}

class AppShortcuts {

    static CommentMap := Map(
        ProcessNames.VisualStudio, "{Ctrl Down}kc{Ctrl Up}",
        ProcessNames.VSCode, "{Ctrl Down}{SC029}{Ctrl Up}",  ; {SC029} is the scan code of "§". We must hardcode it because it is not standardised and differ depending on the keyboard layout
        ProcessNames.PyCharm, "{Ctrl Down}kc{Ctrl Up}",
    )

    static UncommentMap := Map(
        ProcessNames.VisualStudio, "{Ctrl Down}ku{Ctrl Up}",
        ProcessNames.VSCode, AppShortcuts.CommentMap[ProcessNames.VSCode],
        ProcessNames.PyCharm, AppShortcuts.CommentMap[ProcessNames.PyCharm],
    )

    static Run := Map(
        ProcessNames.Any, "^{F5}",
    )

    static Debug := Map(
        ProcessNames.VisualStudio, "{Ctrl Down}rt{Ctrl Up}", 
        ProcessNames.Any, "{F5}",
    )

    static Stop := Map(
        ProcessNames.Any, "+{F5}",
    )
    
    static StepOver := Map(
        ProcessNames.VisualStudio, "{F10}",
        ProcessNames.VSCode, "{F10}",
        ProcessNames.PyCharm, "{F10}",
    )

    static StepInto := Map(
        ProcessNames.Any, "{F11}",
    )

    static StepOut := Map(
        ProcessNames.Any, "+{F11}",
    )

    static SendShortcutByApp(shortcutMap) {
        processName := WinGetProcessName("A")
        for app, shortcut in shortcutMap {
            if (processName ~= "i)" app) {
                SendInput(shortcut)
                return
            }
        }
    }
}