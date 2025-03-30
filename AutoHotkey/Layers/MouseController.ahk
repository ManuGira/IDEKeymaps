#Requires AutoHotkey v2.0
#Include ../Utils/TimeStamp.ahk
#Include ../Utils/Conditional.ahk
#Include ../Nodes/include.ahk

CoordMode("Mouse", "Screen")

class Envelope {
    __New(){
        this.slope := 200
        this.target := 0
        this.value := 0
    }

    IsReached(){
        return Abs(this.value - this.target) < 1
    }

    Update(deltaTime){
        if this.IsReached()
            return this.value
        
        step := this.slope * deltaTime
        if (this.value < this.target)
            this.value := Min(this.value + step, this.target)
        else
            this.value := Max(this.value - step, this.target)
    }

    GetValue(){
        return this.value
    }
}

class MouseController {
    static Init(condition) {
        mController := MouseController()

        ProcessOrPass(processFunc, k1, keyState) {
            
            if condition("-") {  ; "-" is a dummy character not used for evaluating conditions
                TempToolTip(k1 " --- " keyState, 1000)
                processFunc(keyState)
            } else {
                ; if no condition is met, send the key as is
                ; k1 := RegExReplace(k1, "i)^\$")
                ; TempToolTip("no condition is met, send the key as is: {Blind}" k1, 1000)
                ; SendInput("{Blind}" k1)
                if keyState = 1 {
                    SendInput(k1)
                }
            }
        }

        DummyNode(KeyStateNode("e", , false), (state) => ProcessOrPass((s) => mController.OnUp(s), "e", state))
        DummyNode(KeyStateNode("s", , false), (state) => ProcessOrPass((s) => mController.OnLeft(s), "s", state))
        DummyNode(KeyStateNode("d", , false), (state) => ProcessOrPass((s) => mController.OnDown(s), "d", state))
        DummyNode(KeyStateNode("f", , false), (state) => ProcessOrPass((s) => mController.OnRight(s), "f", state))
    }

    LoopFunc(){
        isEnvXDone := Abs(this.envelopeX.value) < 1 and this.envelopeX.IsReached()
        isEnvYDone := Abs(this.envelopeY.value) < 1 and this.envelopeY.IsReached()
        if (isEnvXDone and isEnvYDone){
            this.isRuning := false
            SetTimer(this.timerFunc, 0)
            return
        }
        
        this.envelopeX.Update(0.05)
        this.envelopeY.Update(0.05)
        dx := Integer(this.envelopeX.GetValue())
        dy := Integer(this.envelopeY.GetValue())

        DllCall("mouse_event", "UInt", 0x01, "UInt", dx, "UInt", dy)

        ; string must contain only letters i. and izs length must be equal to dx. for example if x = 5,  "iiiii"
        istr := ""
        Loop Abs(dx)
            istr .= "i"
    }

    Start(){

        if this.isRuning
            return

        this.isRuning := true
        
        SetTimer(this.timerFunc, 50)
        
    }

    __New(){
        this.envelopeX := Envelope()
        this.envelopeY := Envelope()
        this.isRuning := false

        this.left := 0
        this.right := 0
        this.up := 0
        this.down := 0

        this.timerFunc := ObjBindMethod(this, "LoopFunc")
    }

    UpdateTargets(){
        this.envelopeX.target := 40 * (this.right - this.left)
        this.envelopeY.target := 40 * (this.down - this.up)
        this.Start()
    }
    
    OnLeft(state){
        this.left := state
        this.UpdateTargets()
    }

    OnRight(state){
        this.right := state
        this.UpdateTargets()
    }

    OnUp(state){
        this.up := state
        this.UpdateTargets()
    }

    OnDown(state){
        this.down := state
        this.UpdateTargets()
    }

}

TrueFunc(){
    return true
}
MouseController.Init((s) => TrueFunc())
