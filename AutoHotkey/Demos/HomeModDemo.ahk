#Requires AutoHotkey v2.0
#SingleInstance Force

#Include ../Nodes/include.ahk


class KeyMod{

    class STATE{
        static IDLE := 0
        static TBD := 1
        static MOD := 2
    } 

    __New(modkey, key0, key1) {
        this.modkey := modkey
        this.key0 := key0
        this.key1 := key1

        this.modkeyNode := KeyStateNode(modkey, (s) => this.OnModKey(s), false)
        this.key0Node := KeyStateNode(key0, (s) => this.OnKey(s), false)
        this.key1Node := key1

        this.rollback := Array()
        this.fsm := KeyMod.STATE.IDLE
        ; 0 -> tout désactivé
        ; 1 -> mod is down, not decided yet 
    }

    EnterIdleState(){
        this.fsm := KeyMod.STATE.IDLE
        this.rollback := Array()
    }

    EnterTBDState(){
        this.fsm := KeyMod.STATE.TBD        
    }

    EnterModState(){
        this.fsm := KeyMod.STATE.MOD
        Loop this.rollback.Length
            SendInput(this.rollback.Pop())
    }

    OnModKey(state){
        if state {
            ; on mod key down
            if this.fsm == KeyMod.STATE.IDLE {
                this.EnterTBDState()
                SendInput(this.modkey)
                this.rollback.Push("{Backspace}")
            } else if this.fsm == KeyMod.STATE.TBD {
                SendInput(this.modkey)
                this.rollback.Push("{Backspace}")
            } else if this.fsm == KeyMod.STATE.MOD {
                ; nothing to do here
            } else {
                throw "Impossible"
            }
        } else {
            ; on mod key up
            if (this.fsm == KeyMod.STATE.IDLE)  {
                throw "Impossible"
            } else if this.fsm == KeyMod.STATE.TBD {
                this.EnterIdleState()
            } else if this.fsm == KeyMod.STATE.MOD {
                this.EnterIdleState()
            } else {
                throw "Impossible"
            }
        }
    }

    OnKey(state){
        if state {
            ; on key down
            if this.fsm == KeyMod.STATE.IDLE {
                SendInput(this.key0)
            } else if this.fsm == KeyMod.STATE.TBD {
                this.EnterModState()
                SendInput(this.key1)
            } else if this.fsm == KeyMod.STATE.MOD {
                SendInput(this.key1)
            } else {
                throw "Impossible"
            }
        } else {
            ; on key up
            if this.fsm == KeyMod.STATE.IDLE {
                ; nothing to do here
            } else if this.fsm == KeyMod.STATE.TBD {
                ; nothing to do here
            } else if this.fsm == KeyMod.STATE.MOD {
                ; nothing to do here
            } else {
                throw "Impossible"
            }
        }
    }
}

#Include ../Tests/Assert.ahk
TestIt(){
    km := KeyMod("f", "j", "{Left}")

    Assert.Equal(km.fsm, KeyMod.STATE.IDLE)
    Assert.Equal(km.rollback.Length, 0)
    
    km.OnModKey(true)
    Assert.Equal(km.fsm, KeyMod.STATE.TBD)
    Assert.Equal(km.rollback.Length, 1)

    km.OnModKey(false)
    Assert.Equal(km.fsm, KeyMod.STATE.IDLE)
    Assert.Equal(km.rollback.Length, 0)

    km.OnModKey(true)
    km.OnModKey(true)
    Assert.Equal(km.fsm, KeyMod.STATE.TBD)
    Assert.Equal(km.rollback.Length, 2)

    km.OnKey(true)
    Assert.Equal(km.fsm, KeyMod.STATE.MOD)
    Assert.Equal(km.rollback.Length, 0)
}

;TestIt()

KeyMod("f", "j", "{Left}")