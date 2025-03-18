#Requires AutoHotkey v2.0
#Include ../Utils/TimeStamp.ahk
#Include ../Utils/Conditional.ahk
#Include ../Nodes/include.ahk

class Envelope {
    __New(){
        this.slope := 100
        this.prevTime := TimeStamp.Now()
        this.target := 0
        this.value := 0
    }

    IsReached(){
        return Abs(this.value - this.target) < 1
    }

    Update(){
        currentTime := TimeStamp.Now()
        deltaTime := currentTime.Sub(this.prevTime).Value()
        this.prevTime := currentTime

        if this.IsReached() or deltaTime = 0
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

TempToolTip(msg, durationMS){
    ToolTip(msg)
    SetTimer(() => ToolTip(), -durationMS)
}

class MouseController {

    LoopFunc(){
        if Abs(this.envelopeX.value) < 1 and this.envelopeX.IsReached()
            return

        this.envelopeX.Update()
        dx := Integer(this.envelopeX.GetValue())

        ; get x and y mouse position

        xpos := 0
        ypos := 0
        MouseGetPos(&xpos, &ypos)
        MouseMove(xpos+0, ypos+0, 0)

        TempToolTip("dx: " dx, 220)

        SetTimer(() => this.LoopFunc(), -200)
    }

    Start(){

        if this.isRuning
            return

        this.isRuning := true
        this.LoopFunc()
        this.isRuning := false
    }

    __New(){
        this.envelopeX := Envelope()
        this.isRuning := false

        this.left := 0
        this.right := 0
    }

    UpdateTargets(){
        this.envelopeX.target := 100 * (this.right - this.left)
        this.Start()
    }
    
    LeftStart(){
        this.left := 1
        this.UpdateTargets()
    }

    LeftStop(){
        this.left := 0
        this.UpdateTargets()
    }

    RightStart(){
        this.right := 1
        this.UpdateTargets()
    }

    RightStop(){
        this.right := 0
        this.UpdateTargets()
    }
}

mController := MouseController()
Hotkey("$a", (k) => mController.LeftStart())
Hotkey("$a Up", (k) => mController.LeftStop())
Hotkey("$d", (k) => mController.RightStart())
Hotkey("$d Up", (k) => mController.RightStop())
