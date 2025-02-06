#Requires AutoHotkey v2.0
#SingleInstance Force

#Include ../Nodes/include.ahk


class KeyMod{

    __New() {
        this.modKeys := Map(
            "a", "{LCtrl}",
            "s", "{LShift}",
            "d", "{LWin}",
            "f", "{LAlt}",
            "j", "{RAlt}",
            "k", "{RWin}",
            "l", "{RShift}",
            "é", "{RCtrl}",
        )

        this.keys := [
                 "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "'", "`^", 
                 "q", "w", "e", "r", "t", "z", "u", "i", "o", "p", "è", "¨",
                 "a", "s", "d", "f", "g", "h", "j", "k", "l", "é", "à", "$",
            "<", "y", "x", "c", "v", "b", "n", "m", ",", ".", "-"
        ]

        this.keyNodeMap := Map()
        this.modNodeMap := Map()
        for key in this.keys{
            keyNode := DummyNode(KeyStateNode(key, , false, false), (s) => this.OnKey(key, s))
            this.keyNodeMap[key] := keyNode
            if this.modKeys.Has(key)
                this.modNodeMap[key] := keyNode
        }

        this.keysDown := Array()
        this.modsDown := Array()
    }

    static Send0(key, state, mod_ := ""){
        SendInput("$" mod_ key (state ? "" : "Up"))
    }

    OnKey(key, state){
        if state {
            ; On key DOWN
            this.keysDown.Push(key)
        } else {
            ; on key UP
            
            i := 1
            mods := ""
            for m in this.modsDown {
                if m == key {
                    this.modsDown.RemoveAt(i)
                    return
                }
                mods := mods m
                i++
            }

            ; if not returned yet, then mods is already partially filled

            i := 1
            for k in this.keysDown{
                if k == key {
                    this.keysDown.RemoveAt(i)
                    break
                }
                newMod := this.modKeys[k]
                mods := mods newMod
                this.modsDown.Push(newMod)
                i++
            }

            if i > this.keysDown.Length
                throw "this key up (" key ") has not been down before"

            KeyMod.Send0(key, true, mods)
            KeyMod.Send0(key, false, mods)
        }
    }
}

km := KeyMod()
