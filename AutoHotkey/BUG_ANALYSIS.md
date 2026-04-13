# Modifier Key Initialization Bug - Root Cause Analysis

## Problem Description
When MainLayout.ahk runs (especially at startup), the system behaves as if modifier keys are permanently pressed, even though:
- All modifier nodes report state = 0 (false)
- GetKeyState() reports the keys as not pressed
- Manually pressing each modifier key once "fixes" the system

## Root Cause

The bug occurs because **SendInput's synthetic key presses don't trigger the hotkeys** that KeyStateObserver has registered.

### What Happens at Startup

1. `MainLayout.ahk` runs and calls `Reset()` at the end
2. `Reset()` calls `fkn.Reset()` which sends synthetic key sequences:
   ```ahk
   SendInput("{Blind}{" k " Up}")      ; Synthetic up
   Sleep(100)
   SendInput("{Blind}{" k " Down}")    ; Synthetic down
   Sleep(100)
   SendInput("{Blind}{" k " Up}")      ; Synthetic up
   ```

3. These `SendInput()` calls affect the **OS state** (Windows thinks keys are pressed/released)
4. BUT these synthetic inputs **DO NOT trigger the hotkeys** that KeyStateObserver registered in [KeyStateObserver.ahk](KeyStateObserver.ahk#L69-L75):
   ```ahk
   Hotkey prefix key, (k) => KeyStateObserver.UpdateKeyState(key, true)
   Hotkey prefix key " Up", (k) => KeyStateObserver.UpdateKeyState(key, false)
   ```

5. Result: **State desync**
   - OS state: Updated by SendInput
   - KeyStateObserver state: Remains unchanged (false for all keys)

### Why Manual Key Press Fixes It

When you physically press a modifier key:
- The real hotkey fires (because physical input triggers hotkeys)
- KeyStateObserver.UpdateKeyState() is called
- KeyStateObserver.isKeyDown[] is updated
- State comes back into sync

## The Problem Chain

```
Reset() sends synthetic input
    ↓
OS state changes (Windows knows keys are up/down)
    ↓
KeyStateObserver hotkeys DON'T fire (synthetic input doesn't trigger hotkeys)
    ↓
KeyStateObserver.isKeyDown[] is NOT updated
    ↓
DESYNC: OS state ≠ KeyStateObserver state
    ↓
KeyboardState's GateNodes use wrong state and send wrong modifier commands
    ↓
System behaves like modifiers are stuck pressed
    ↓
User presses real Shift → hotkey fires → state syncs → system works again
```

## Solution

The fix is to **update KeyStateObserver directly after sending synthetic input**. 

Two places need fixing:

### Fix #1: In `FullKeyboardNode.Reset()`
After each `SendInput()` call, manually update KeyStateObserver:

```ahk
for k in FullKeyboardNode.modKeyLabels {
    this.modKeyNodes0[k].Update(false)
    this.modKeyNodes[k].Update(false)
    
    ; Send synthetic input AND update KeyStateObserver
    SendInput("{Blind}{" k " Up}")
    KeyStateObserver.UpdateKeyState(k, false)  ; ← ADD THIS
    Sleep(100)
    
    SendInput("{Blind}{" k " Down}")
    KeyStateObserver.UpdateKeyState(k, true)   ; ← ADD THIS
    Sleep(100)
    
    SendInput("{Blind}{" k " Up}")
    KeyStateObserver.UpdateKeyState(k, false)  ; ← ADD THIS
    Sleep(100)
}
```

### Fix #2: In `KeyboardState.SendModInput()`
Similarly update KeyStateObserver after sending synthetic modifiers:

```ahk
SendModInput(state, key) {
    if state {
        SendInput("{Blind}{" key " Down}")
        KeyStateObserver.UpdateKeyState(key, true)   ; ← ADD THIS
    } else {
        SendInput("{Blind}{" key " Up}")
        KeyStateObserver.UpdateKeyState(key, false)  ; ← ADD THIS
    }
}
```

## Testing the Bug
See: **MinimalModifierBug.ahk**

**How to reproduce:**
1. Run MinimalModifierBug.ahk
2. Press F2 (simulates Reset's synthetic input)
3. Observe: KeyStateObserver stays false but system gets confused
4. Manually press Shift → system "fixes" itself

