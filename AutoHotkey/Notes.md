# AHK Cheatsheet

## Scripting basics
AHK is a scripting language in itself. Here is a few basics things to know
 * `unset` is equivalent to `None` in python. Test if a variable is set with function `IsSet()`
 * Parenthesis are optional when calling a function. i.e. `Foo(x, y)` is similar to `Foo x, y`  
 * Optional parameters definition: `Bar(a, b:=1, c:=unset){do something}`. To skip an optional parameter simply leave its slot blank: `Bar("K", , 10)` 

## Conditional Hotkeys
Two ways to create a hotkey. With the `::` operator, and with the `Hotkey(...)` function. Their conditions are not declared the same. 
### #Hotif Conditions. 
The `#HotIf` condition works for `::`  mapping only. It lags when simultaneous inputs. 
```ahk
#Requires AutoHotkey v2.0
#MaxThreadsPerHotkey 5
#Include Nodes/ToggleNode.ahk
mySwitch := ToggleNode(["Left", "Right"], true)

; No need for a lambda here. The instruction is saved as a string and interpreted when the hotkey is triggered 
#HotIf mySwitch.GetState()  
a::q
q::a
w::z
e::e
r::r
t::t
z::y
#HotIf 
```

### HotKey(...) Condition
For `Hotkey(...)` only. Lags when simultaneous inputs. Even when increasing thread count
```ahk
#Requires AutoHotkey v2.0
#MaxThreadsPerHotkey 5
#Include Nodes/ToggleNode.ahk
mySwitch := ToggleNode(["Left", "Right"], true)
; Condition function must be a lambda taking 1 parameter
condFunc := (k) => mySwitch.GetState()
HotIf(condFunc)
Hotkey "*a", (k) => SendInput("{Blind}q")
Hotkey "*q", (k) => SendInput("{Blind}a")
Hotkey "*w", (k) => SendInput("{Blind}z")
Hotkey "*e", (k) => SendInput("{Blind}e")
Hotkey "*r", (k) => SendInput("{Blind}r")
Hotkey "*t", (k) => SendInput("{Blind}t")
Hotkey "*z", (k) => SendInput("{Blind}y")
HotIf()
```

### Conditional.Hotkey(...) Condition
The `Conditional` class from script `./Utils/Conditional.ahk` implements an alternative `HotKey(...)` function. You must provide a condition function when creating the hotkey. This is less laggy than the two builtin function. The function accept 2 parameters

```ahk
#Requires AutoHotkey v2.0
#Include Nodes/ToggleNode.ahk
#Include Utils/Conditional.ahk
mySwitch := ToggleNode(["Left", "Right"], true)

; Condition function must be a lambda taking 1 parameter
condFunc := (k) => mySwitch.GetState()

Conditional.Hotkey("*y", (k) => SendInput("{Blind}x"), condFunc)
Conditional.Hotkey("*a", (k) => SendInput("{Blind}q"), condFunc)
Conditional.Hotkey("*q", (k) => SendInput("{Blind}a"), condFunc)
Conditional.Hotkey("*w", (k) => SendInput("{Blind}z"), condFunc)
Conditional.Hotkey("*e", (k) => SendInput("{Blind}e"), condFunc)
Conditional.Hotkey("*r", (k) => SendInput("{Blind}r"), condFunc)
Conditional.Hotkey("*t", (k) => SendInput("{Blind}t"), condFunc)
Conditional.Hotkey("*z", (k) => SendInput("{Blind}y"), condFunc)
```

## KeyStateObserver
The class KeyStateObserver from `Utils/KeyStateObserver.ahk` creates 2 hotkeys for you, 1 for press and 1 for release. 

### Limitation
The passThrough option must be shared among all subscriber of the key. This makes it not really usable if you need the key to passThrough for certain layers and not passThrough for other layers

## Nodes
The Nodes folder contains many implementation of the INode interface. 
All nodes can be included at once with `#Include Nodes/include.ahk`




