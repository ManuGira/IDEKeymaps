#Requires AutoHotkey v2.0

class ProcessNames {
    static VisualStudio := "devenv.exe"
    static VSCode := "code.exe"
    static PyCharm := "pycharm64.exe|pycharm.exe"  ; Both 64-bit and 32-bit versions
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
        ProcessNames.VisualStudio, "{F5}",
        ProcessNames.VSCode, "{F5}",
        ProcessNames.PyCharm, "{F9}",
    )

    static Debug := Map(
        ProcessNames.VisualStudio, "{Ctrl Down}rt{Ctrl Up}", ; debug current test
        ProcessNames.VSCode, "{F5}",
        ProcessNames.PyCharm, "{Ctrl}{F9}",
    )
    
    static StepOver := Map(
        ProcessNames.VisualStudio, "{F10}",
        ProcessNames.VSCode, "{F10}",
        ProcessNames.PyCharm, "{F8}",
    )

    static StepInto := Map(
        ProcessNames.VisualStudio, "{F11}",
        ProcessNames.VSCode, "{F11}",
        ProcessNames.PyCharm, "{F7}",
    )

    static StepOut := Map(
        ProcessNames.VisualStudio, "{Shift}{F11}",
        ProcessNames.VSCode, "{Shift}{F11}",
        ProcessNames.PyCharm, "{Shift}{F8}",
    )

    static SendShortcutByApp(shortcutMap) {
        processName := WinGetProcessName("A")
        for app, shortcut in shortcutMap {
            if (processName ~= "i)" app) {
                SendInput("{Blind}" shortcut)
                return
            }
        }
    }
}