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
    ;static AllModHotKeyClick(key, mouseController, mouseButonToClick, condition) {
    ;    Conditional.Hotkey("$" key, (k) => mouseController.OnClick(mouseButonToClick, true), condition)
    ;    ; Conditional.Hotkey("$+" key, (k) => mouseController.OnClick("+{" mouseButonToClick "}", true), condition)
    ;    ; Conditional.Hotkey("$!" key, (k) => mouseController.OnClick("!{" mouseButonToClick "}", true), condition)
    ;    ; Conditional.Hotkey("$^" key, (k) => mouseController.OnClick("^{" mouseButonToClick "}", true), condition)
    ;    ; Conditional.Hotkey("$+!" key, (k) => mouseController.OnClick("+!{" mouseButonToClick "}", true), condition)
    ;    ; Conditional.Hotkey("$+^" key, (k) => mouseController.OnClick("+^{" mouseButonToClick "}", true), condition)
    ;    ; Conditional.Hotkey("$!^" key, (k) => mouseController.OnClick("!^{" mouseButonToClick "}", true), condition)

    ;    Conditional.Hotkey("$" key " Up", (k) => mouseController.OnClick(mouseButonToClick, false), condition)
    ;}

    /**
     * 
     * @param enableNode {KeyStateNode}: Node that will enable or disable the mouse controller
     */
    static Init(enableNode, sniperModNode) {
        condition := (k) => enableNode.GetState()
        
        mController := MouseController(sniperModNode)
        enableNode.Subscribe((s) => mController.OnEnable(s))

        mapKey(key, func){
            filterNode := ChangeNode()
            Conditional.Hotkey("$" key, (k) => filterNode.Update(true), condition)
            Conditional.Hotkey("$" key " Up", (k) => filterNode.Update(false), condition)
            filterNode.Subscribe(func)
        }

        mapKey("e", (s) => mController.OnUp(s))
        mapKey("s", (s) => mController.OnLeft(s))
        mapKey("d", (s) => mController.OnDown(s))
        mapKey("f", (s) => mController.OnRight(s))

        mapKey("q", (s) => mController.OnScrollUp(s))
        mapKey("a", (s) => mController.OnScrollDown(s))
        
        mapKey("j", (s) => mController.OnClickLeft(s))
        mapKey("k", (s) => mController.OnClickMiddle(s))
        mapKey("l", (s) => mController.OnClickRight(s))

        ;MouseController.AllModHotKeyClick("j", mController, "Left", condition)
        ;MouseController.AllModHotKeyClick("k", mController, "Middle", condition)
        ;MouseController.AllModHotKeyClick("l", mController, "Right", condition)
    }

    OnEnable(state){
        if not state
            this.Stop()
    }

    LoopFunc(){
        
        isEnvXDone := Abs(this.envelopeX.value) < 1 and this.envelopeX.IsReached()
        isEnvYDone := Abs(this.envelopeY.value) < 1 and this.envelopeY.IsReached()
        ;isEnvScrollDone := Abs(this.envelopeScroll.value) < 1 and this.envelopeScroll.IsReached()
        isScrolling := this.scrollDown - this.scrollUp != 0
        if (isEnvXDone and isEnvYDone and not isScrolling){
            this.isRuning := false
            SetTimer(this.timerFunc, 0)
            return
        }
        
        this.envelopeX.Update(this.period_ms/1000) 
        this.envelopeY.Update(this.period_ms/1000)

        damp := (this.sniperModNode.getState() ? 0.25 : 1)
             
        dx := Integer(this.envelopeX.GetValue() * damp)
        dy := Integer(this.envelopeY.GetValue() * damp)

        DllCall("mouse_event", "UInt", 0x01, "UInt", dx, "UInt", dy)

        ;this.envelopeScroll.Update(this.period_ms/1000)

        ;sgn := this.envelopeScroll.GetValue() > 0 ? 1 : -1
        ;scrollSpeedPerPeriod := Max(Abs(this.envelopeScroll.GetValue()), this.scrollMinSpeed*this.period_ms/1000) * sgn/1000
        this.scrollPosition := this.scrollPosition + (this.scrollDown - this.scrollUp)*this.scrollSpeed*this.period_ms/1000 * damp
        ;ToolTip("scrollPosition: " this.scrollPosition ", scrollDown: " this.scrollDown ", scrollUp: " this.scrollUp)
        if Abs(this.scrollPosition) >= 1 {
            sgn := this.scrollPosition > 0 ? 1 : -1
            ds := Integer(Abs(this.scrollPosition))
            this.scrollPosition := this.scrollPosition - ds * sgn
            keyword := sgn > 0 ? "WheelDown" : "WheelUp"
            Send("{" keyword " " ds "}")       
        }
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
        ; ---- reset mouse move -----
        this.envelopeX := Envelope(this.acceleration)
        this.envelopeY := Envelope(this.acceleration)
        this.isRuning := false
        this.left := 0
        this.right := 0
        this.up := 0
        this.down := 0
        
        ; ---- reset wheel scroll -----
        this.envelopeScroll := Envelope(this.scrollAcceleration)
        this.scrollPosition := 0
        this.scrollUp := 0
        this.scrollDown := 0

        if this.clickLeft {
            this.OnClick("Left", false)
            this.clickLeft := false
        }        

        if this.clickMiddle {
            this.OnClick("Middle", false)
            this.clickMiddle := false
        }

        if this.clickRight {
            this.OnClick("Right", false)
            this.clickRight := false
        }
    }

    __New(sniperModNode){
        this.sniperModNode := sniperModNode
        
        this.acceleration := 200
        this.maxSpeed := 1000
        this.period_ms := 30
        this.scrollAcceleration := 1000 ; in milli wheel ticks
        this.scrollSpeed := 30

        this.timerFunc := ObjBindMethod(this, "LoopFunc")

        this.envelopeX := unset
        this.envelopeY := unset
        this.isRuning := unset
        this.left := unset
        this.right := unset
        this.up := unset
        this.down := unset

        this.envelopeScroll := unset
        this.scrollPosition := unset
        this.scrollUp := unset
        this.scrollDown := unset

        this.clickLeft := false
        this.clickMiddle := false
        this.clickRight := false

        this.Reset()
    }

    UpdateTargets(){
        this.envelopeX.target := this.maxSpeed * this.period_ms/1000 * (this.right - this.left)
        this.envelopeY.target := this.maxSpeed * this.period_ms/1000 * (this.down - this.up)
        ;this.envelopeScroll.target := this.scrollMaxSpeed * this.period_ms/1000 * (this.scrollDown - this.scrollUp)
        
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

    OnScrollUp(state){
        this.scrollUp := state
        if state
            Send("{WheelUp 1}")
        this.UpdateTargets()
    }

    OnScrollDown(state){
        this.scrollDown := state
        if state
            Send("{WheelDown 1}")
        this.UpdateTargets()
    }

    OnClickLeft(state){
        this.clickLeft := state
        this.OnClick("Left", state)
    }

    OnClickMiddle(state){
        this.clickMiddle := state
        this.OnClick("Middle", state)
    }

    OnClickRight(state){
        this.clickRight := state
        this.OnClick("Right", state)
    }

    OnClick(button, state){

        ;if this.sniperModNode.GetState()
        ;    SendInput("{Shift down}")
        
        ; MouseClick [WhichButton, X, Y, ClickCount, Speed, DownOrUp, Relative]
        MouseClick(button, , , 1, , state ? "D" : "U", )

        ;if this.sniperModNode.GetState()
        ;    SendInput("{Shift up}")
    }
}

