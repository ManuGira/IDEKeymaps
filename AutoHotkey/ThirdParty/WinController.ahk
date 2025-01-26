; Easy Window Dragging -- KDE style (based on the v1 script by Jonny) 
; https://www.autohotkey.com


class WinController{
    static Init(){
        SetWinDelay(2)
        CoordMode("Mouse")
    }

    static Minimize(){
        MouseGetPos ,, &KDE_id
        ; This message is mostly equivalent to WinMinimize,
        ; but it avoids a bug with PSPad.
        PostMessage 0x0112, 0xf020,,, KDE_id
    }

    static ToggleMaximize() {
        MouseGetPos ,, &KDE_id
        ; Toggle between maximized and restored state.
        if WinGetMinMax(KDE_id)
            WinRestore KDE_id
        Else
            WinMaximize KDE_id
    }

    static Move() {
        ; Get the initial mouse position and window id, and
        ; abort if the window is maximized.
        MouseGetPos &KDE_X1, &KDE_Y1, &KDE_id
        if WinGetMinMax(KDE_id)
            return
        ; Get the initial window position.
        WinGetPos &KDE_WinX1, &KDE_WinY1,,, KDE_id
        Loop
        {
            if !GetKeyState("LButton", "P") ; Break if button has been released.
                break
            MouseGetPos &KDE_X2, &KDE_Y2 ; Get the current mouse position.
            KDE_X2 -= KDE_X1 ; Obtain an offset from the initial mouse position.
            KDE_Y2 -= KDE_Y1
            KDE_WinX2 := (KDE_WinX1 + KDE_X2) ; Apply this offset to the window position.
            KDE_WinY2 := (KDE_WinY1 + KDE_Y2)
            WinMove KDE_WinX2, KDE_WinY2,,, KDE_id ; Move the window to the new position.
        }
    }

    static Resize() {
        ; Get the initial mouse position and window id, and
        ; abort if the window is maximized.
        MouseGetPos &KDE_X1, &KDE_Y1, &KDE_id
        if WinGetMinMax(KDE_id)
            return
        ; Get the initial window position and size.
        WinGetPos &KDE_WinX1, &KDE_WinY1, &KDE_WinW, &KDE_WinH, KDE_id
        ; Define the window region the mouse is currently in.
        ; The four regions are Up and Left, Up and Right, Down and Left, Down and Right.
        if (KDE_X1 < KDE_WinX1 + KDE_WinW / 2)
            KDE_WinLeft := 1
        else
            KDE_WinLeft := -1
        if (KDE_Y1 < KDE_WinY1 + KDE_WinH / 2)
            KDE_WinUp := 1
        else
            KDE_WinUp := -1
        Loop
        {
            if !GetKeyState("RButton", "P") ; Break if button has been released.
                break
            MouseGetPos &KDE_X2, &KDE_Y2 ; Get the current mouse position.
            ; Get the current window position and size.
            WinGetPos &KDE_WinX1, &KDE_WinY1, &KDE_WinW, &KDE_WinH, KDE_id
            KDE_X2 -= KDE_X1 ; Obtain an offset from the initial mouse position.
            KDE_Y2 -= KDE_Y1
            ; Then, act according to the defined region.
            WinMove KDE_WinX1 + (KDE_WinLeft+1)/2*KDE_X2  ; X of resized window
                , KDE_WinY1 +   (KDE_WinUp+1)/2*KDE_Y2  ; Y of resized window
                , KDE_WinW  -     KDE_WinLeft  *KDE_X2  ; W of resized window
                , KDE_WinH  -       KDE_WinUp  *KDE_Y2  ; H of resized window
                , KDE_id
            KDE_X1 := (KDE_X2 + KDE_X1) ; Reset the initial position for the next iteration.
            KDE_Y1 := (KDE_Y2 + KDE_Y1)
        }
    }

    static Close() {
        MouseGetPos ,, &KDE_id
        WinClose KDE_id
    }
}

WinController.Init()
