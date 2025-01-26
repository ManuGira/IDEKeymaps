#Requires AutoHotkey v2.0

#Include ../Nodes/ToggleNode.ahk
#Include ../Nodes/KeyStateNode.ahk
#Include ../Nodes/AndNode.ahk
#Include ../Utils/Conditional.ahk

mySwitch := ToggleNode(
    AndNode([
        KeyStateNode("Left"), 
        KeyStateNode("Right")
    ]), ,
    true
)

condFunc := (k) => mySwitch.GetState()

; conditional remaps gives a faster alternative to HotIf function. 

Conditional.Remap("a", "q", condFunc, , (k) => ToolTip(k " is q"))  ; optional callback

Conditional.Remap("q", "a", condFunc, , (k) => ToolTip(k " is a"))
Conditional.Remap("w", "z", condFunc, "+")  ; optional modifier. Default: "*", Here w is replaced by z only when {Shift} is true
Conditional.Remap("e", "e", condFunc)
Conditional.Remap("r", "r", condFunc)
Conditional.Remap("t", "t", condFunc)
Conditional.Remap("z", "y", condFunc)

Conditional.Hotkey("*y", (k) => SendInput("{Blind}x"), condFunc)
Conditional.Hotkey("*x", (k) => SendInput("{Blind}y"), condFunc)

; The official way of doing conditional hotkeys is to use Hotif() or #HotIf. But they are laggy when typing fast
; Uncomment the code below and try by yourself

; TECHNIQUE 1: #Hotif. For a::b mapping only. Lags when simultaneous inputs
; #MaxThreadsPerHotkey 5
; #HotIf mySwitch.GetState()
; a::q
; q::a
; w::z
; e::e
; r::r
; t::t
; z::y
; #HotIf
; --------------------------------------------------------- 

; TECHNIQUE 2: Hotif(). For Hotkey() only. Lags when simultaneous inputs. Even When increasing thread count
; #MaxThreadsPerHotkey 5
; HotIf(condFunc)
; Hotkey "*a", (k) => SendInput("{Blind}q"), "T3"
; Hotkey "*q", (k) => SendInput("{Blind}a"), "T3"
; Hotkey "*w", (k) => SendInput("{Blind}z"), "T3"
; Hotkey "*e", (k) => SendInput("{Blind}e"), "T3"
; Hotkey "*r", (k) => SendInput("{Blind}r"), "T3"
; Hotkey "*t", (k) => SendInput("{Blind}t"), "T3"
; Hotkey "*z", (k) => SendInput("{Blind}y"), "T3"
; HotIf()
; --------------------------------------------------------- 
