#Requires AutoHotkey v2.0
#Include INode.ahk
#Include ../Utils/KeyStateObserver.ahk

/**
 * Non-static wrapper around KeyStateObserver
 */
class WinSessionStateNode extends INode {

    /**
     * Node that triggers when the Windows session is locked or unlocked
     * State is true when unlocked, false when locked
     * @param callback {(Func<bool>)}
     */
    __New(callback := unset) {
        DllCall("Wtsapi32.dll\WTSRegisterSessionNotification", "Ptr", A_ScriptHwnd, "UInt", 0) ; 0 = NOTIFY_FOR_THIS_SESSION
        OnMessage(0x02B1, (wParam, lParam, msg, hwnd) => wParam = 0x8 ? this.Update(true) : wParam = 0x7 ? this.Update(false) : "") ; WM_WTSSESSION_CHANGE / WTS_SESSION_UNLOCK=0x8 / WTS_SESSION_LOCK=0x7

        if IsSet(callback)
            this.Subscribe(callback)
    }

    Update(state){
        this.state := state
        this.NotifySubscribers()
    }
}
