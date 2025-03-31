#Requires AutoHotkey v2.0
#Include ../Utils/TimeStamp.ahk
#Include ../Utils/Conditional.ahk
#Include ../Nodes/include.ahk

CoordMode("Mouse", "Screen")

class Envelope {
    __New(slope := 200){
        this.slope := slope
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
    static AllModHotKeyClick(key, mouseController, mouseButonToClick, condition) {
        Conditional.Hotkey("$" key, (k) => mouseController.OnClick(mouseButonToClick, true), condition)
        ; Conditional.Hotkey("$+" key, (k) => mouseController.OnClick("+{" mouseButonToClick "}", true), condition)
        ; Conditional.Hotkey("$!" key, (k) => mouseController.OnClick("!{" mouseButonToClick "}", true), condition)
        ; Conditional.Hotkey("$^" key, (k) => mouseController.OnClick("^{" mouseButonToClick "}", true), condition)
        ; Conditional.Hotkey("$+!" key, (k) => mouseController.OnClick("+!{" mouseButonToClick "}", true), condition)
        ; Conditional.Hotkey("$+^" key, (k) => mouseController.OnClick("+^{" mouseButonToClick "}", true), condition)
        ; Conditional.Hotkey("$!^" key, (k) => mouseController.OnClick("!^{" mouseButonToClick "}", true), condition)

        Conditional.Hotkey("$" key " Up", (k) => mouseController.OnClick(mouseButonToClick, false), condition)
    }

    static Init(enableNode) {
        condition := (k) => enableNode.GetState()
        
        mController := MouseController()
        enableNode.Subscribe((s) => mController.OnEnable(s))

        Conditional.Hotkey("$e", (k) => mController.OnUp(true), condition)
        Conditional.Hotkey("$e Up", (k) => mController.OnUp(false), condition)

        Conditional.Hotkey("$s", (k) => mController.OnLeft(true), condition)
        Conditional.Hotkey("$s Up", (k) => mController.OnLeft(false), condition)

        Conditional.Hotkey("$d", (k) => mController.OnDown(true), condition)
        Conditional.Hotkey("$d Up", (k) => mController.OnDown(false), condition)

        Conditional.Hotkey("$f", (k) => mController.OnRight(true), condition)
        Conditional.Hotkey("$f Up", (k) => mController.OnRight(false), condition)
        
        MouseController.AllModHotKeyClick("j", mController, "Left", condition)
        MouseController.AllModHotKeyClick("k", mController, "Middle", condition)
        MouseController.AllModHotKeyClick("l", mController, "Right", condition)
    }

    OnEnable(state){
        if not state
            this.Stop()
    }

    LoopFunc(){
        isEnvXDone := Abs(this.envelopeX.value) < 1 and this.envelopeX.IsReached()
        isEnvYDone := Abs(this.envelopeY.value) < 1 and this.envelopeY.IsReached()
        if (isEnvXDone and isEnvYDone){
            this.isRuning := false
            SetTimer(this.timerFunc, 0)
            return
        }
        
        this.envelopeX.Update(this.period_ms/1000)
        this.envelopeY.Update(this.period_ms/1000)
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
        SetTimer(this.timerFunc, this.period_ms)
    }
    
    Stop(){
        SetTimer(this.timerFunc, 0)
        this.Reset()
    }
    
    Reset(){
        this.envelopeX := Envelope(this.acceleration)
        this.envelopeY := Envelope(this.acceleration)
        this.isRuning := false
        this.left := 0
        this.right := 0
        this.up := 0
        this.down := 0
    }

    __New(){
        this.acceleration := 200
        this.maxSpeed := 1000
        this.period_ms := 30

        this.timerFunc := ObjBindMethod(this, "LoopFunc")

        this.envelopeX := unset
        this.envelopeY := unset
        this.isRuning := unset
        this.left := unset
        this.right := unset
        this.up := unset
        this.down := unset

        this.Reset()
    }

    UpdateTargets(){
        this.envelopeX.target := this.maxSpeed * this.period_ms/1000 * (this.right - this.left)
        this.envelopeY.target := this.maxSpeed * this.period_ms/1000 * (this.down - this.up)
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

    OnClick(button, state){
        ; MouseClick [WhichButton, X, Y, ClickCount, Speed, DownOrUp, Relative]
        MouseClick(button, , , 1, , state ? "D" : "U", )
    }
}

