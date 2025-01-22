#Requires AutoHotkey v2.0
ToolTip()
;#Include OnAnyKeyDown.ahk

global isIdle := true

countMax := 4

ResetCounter(){
    countDown := countMax
}

OnKeyPressSubscribe(ResetCounter)

OnIdleSubscribe(UserFunction){
    UserCallback := UserFunction
}

CheckActivity(){
    global
    if countDown > 0
        countDown--

    isIdle := countDown == 0
    ToolTip("isIdle: " isIdle, , , 1)
}

SetTimer(CheckActivity, 500)



