; Easy Window Dragging -- KDE style (based on the v1 script by Jonny) 
; https://www.autohotkey.com
; This script makes it much easier to move or resize a window: 1) Hold down
; the ALT key and LEFT-click anywhere inside a window to drag it to a new
; location; 2) Hold down ALT and RIGHT-click-drag anywhere inside a window
; to easily resize it; 3) Press ALT twice, but before releasing it the second
; time, left-click to minimize the window under the mouse cursor, right-click
; to maximize it, or middle-click to close it.

; The Double-Alt modifier is activated by pressing
; Alt twice, much like a double-click. Hold the second
; press down until you click.
;
; The shortcuts:
;  Alt + Left Button  : Drag to move a window.
;  Alt + Right Button : Drag to resize a window.
;  Double-Alt + Left Button   : Minimize a window.
;  Double-Alt + Right Button  : Maximize/Restore a window.
;  Double-Alt + Middle Button : Close a window.
;
; You can optionally release Alt after the first
; click rather than holding it down the whole time.

; This is the setting that runs smoothest on my
; system. Depending on your video card and cpu
; power, you may want to raise or lower this value.

#Include WinController.ahk

g_DoubleAlt := false

!LButton::
{
    global g_DoubleAlt  ; Declare it since this hotkey function must modify it.
    if g_DoubleAlt {
        WinController.Minimize()
        g_DoubleAlt := false
        return
    }
    WinController.Move()
}

!RButton::
{
    global g_DoubleAlt
    if g_DoubleAlt
    {
        WinController.ToggleMaximize()
        g_DoubleAlt := false
        return
    }
    WinController.Resize()
}

; "Alt + MButton" may be simpler, but I like an extra measure of security for
; an operation like this.
!MButton::
{
    global g_DoubleAlt
    if g_DoubleAlt
    {
        WinController.Close()
        g_DoubleAlt := false
        return
    }
}

; This detects "double-clicks" of the alt key.
~Alt::
{
    global g_DoubleAlt := (A_PriorHotkey = "~Alt" and A_TimeSincePriorHotkey < 400)
    Sleep 0
    KeyWait "Alt"  ; This prevents the keyboard's auto-repeat feature from interfering.
}